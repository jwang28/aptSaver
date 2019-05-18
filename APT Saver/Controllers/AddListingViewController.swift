//
//  AddListingViewController.swift
//  APT Saver
//
//  Created by Jennifer Wang on 4/15/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import SwiftSoup
import WebKit
import TesseractOCR
import GPUImage
import AVFoundation

protocol AddListingViewControllerDelegate {
    func didFinishLoadingData(listings: [Listing])
}

class AddListingViewController: UIViewController, WKNavigationDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, G8TesseractDelegate {
    
    //interface builder
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var linkTextFieldContainerView: UIView!
    @IBOutlet weak var croppedImage: UIImageView!
    
    //image picker that takes a picture of a link. The photo is then chosen to be processed and extracted for the URL text using Tesseract OCR
    @IBAction func chooseImage(_ sender: UIButton) {
        let scannerHeight = 20
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in imagePickerController.sourceType = .camera
            
            //add an overlay to indicate the area users should capture the URL
            imagePickerController.cameraOverlayView = UIImageView(image: UIImage(named: "boxwithborder")!)
            let width = self.view.frame.size.width
            //default ratio
            let height = width * (4/3)

            //print("navigation bar height: ", imagePickerController.navigationBar.frame.height, "width: ", width, " photo height: ", height)
            //create custom overlay size
            imagePickerController.cameraOverlayView?.frame = (CGRect(x: 0+10, y: 44+height/2-CGFloat(scannerHeight/2) , width: width-20, height: CGFloat(scannerHeight)))
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //select image from camera and extract URL text using tesseract OCR
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let scannerHeight = CGFloat(20)
        if let tesseract = G8Tesseract(language: "eng") {
            tesseract.delegate = self
            let width = image.size.width
            let height = image.size.height
            let scale = image.size.width/picker.view.frame.size.width
            //print("width is: ", width, "height is: ", height)
            //print("new navigation bar height: ", picker.navigationBar.frame.height, " picker width is: ", picker.view.frame.size.width)
            
            //match the overlay from previous step with the cropped portion of the image (URL)
            let cropRect = CGRect(origin: CGPoint(x: 10*scale, y: height/2 - (scannerHeight/2*scale)), size: CGSize(width: width-20, height: (scannerHeight-2)*scale))

            //crop full image to extract portion with URL
            UIGraphicsBeginImageContextWithOptions(cropRect.size, false, 0)
            image.draw(at: CGPoint(x:-cropRect.origin.x, y:-cropRect.origin.y))
            let crop = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let myGroup = DispatchGroup()
            myGroup.enter()
            
            //can toggle between processing with and without binarization to notice the difference. Processing accuracy is determined by many factors, including the scanned area, processing speed/time, lighting, distortion, etc
            //let cropped = UIImage(data: crop!.pngData()!)?.binarize()
            let cropped = UIImage(data: crop!.pngData()!)
            myGroup.leave()
            myGroup.notify(queue: DispatchQueue.main){
                //uncomment to view the resulting processed and cropped image
                //self.croppedImage.image = cropped!
                tesseract.image = cropped!
                tesseract.recognize()
                print(tesseract.recognizedText)
                var imageText = tesseract.recognizedText
                imageText = imageText!.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
                imageText = imageText!.replacingOccurrences(of: "\n", with: "", options: NSString.CompareOptions.literal, range: nil)
                
                //processed text recognized from image should be added to the url text field. Note that processing accuracy highly depends on camera and lighting. More improvements to come in later features
                self.url.text = imageText
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func progressImageRecognition(for tesseract: G8Tesseract) {
        print("Recognition Progress \(tesseract.progress) %")
    }
    //properties
    var delegate: AddListingViewControllerDelegate?
    var imageUrl = ""
    var addressTest = " "
    var price = " "
    var descriptionText = " "
    var bed = " "
    var bath = " "
    var size = " "
    var ppsqft = " "
    var amenities = " "
    var transportation = " "
    var listing = Listing()
    
    //viewcontroller's lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        
        self.webView.navigationDelegate = self
    }
    
    //custom methods
    func configureUI() {
        self.linkTextFieldContainerView.layer.cornerRadius = self.linkTextFieldContainerView.bounds.height / 2
    }
    //sort processing according to website
    func process(htmlContent: String){
        if (self.url.text?.contains("streeteasy"))!{
            processStreetEasy(htmlContent: htmlContent)
        }
        else{
            processZillow(htmlContent: htmlContent)
        }
    }
    //scrape elements from streeteasy
    func processStreetEasy(htmlContent: String) {
        do {
            //print("htmlContent: \(htmlContent)")
            let doc: Document = try SwiftSoup.parseBodyFragment(htmlContent)
            self.addressTest = try doc.getElementsByClass("building-title").text()
            self.price = try doc.getElementsByClass("price").text()
            self.descriptionText = try doc.getElementsByClass("Description-block jsDescriptionExpanded").text()
            
            //streeteasy may block scraping on the first pass. This code checks if streeteasy has bot detection and prompts user to resubmit html rrequest if needed
            guard let details: [Element] = try (doc.getElementsByClass("details_info").first()?.children().array()) else {
                showAlert(titleString: "Error!", messageString: "Something went wrong with the link. Please try again!")
                return
            }
            //append details regarding bedrooms, baths, sqft, etc in one string
            for index in 0...details.count - 1 {
                
                let temp = try details[index].text()
                if self.bed != " "{
                    self.bed = self.bed + " | " + temp
                } else {
                    self.bed = temp
                }
            }
            
            //apend details regarding amenities
            let amenitiesHi: [Element] = try doc.getElementsByClass("AmenitiesBlock-highlightsItem").array()
            for index in 0...amenitiesHi.count - 1  {
                let temp = try amenitiesHi[index].text()
                if self.amenities != " " {
                    self.amenities = self.amenities + " | " + temp
                } else {
                    self.amenities = temp
                }
            }
            
            //get listing images and choose the first image as the cover photo
            let jpgs: Elements? = try doc.getElementById("carousel")?.select("img[src$=.jpg]")
            self.imageUrl = (try jpgs?.get(0).attr("src"))!
            
            //get transportation information from website
            let transportation: Element = try doc.getElementsByClass("Nearby-transportationList").get(0)
            self.transportation = try transportation.text()
            
            //save listing into database
            self.listing = Listing(address: self.addressTest, price: self.price ,description: self.descriptionText , bed: self.bed, bath: "", size: "", ppsqft: "", amenities: self.amenities, transportation: self.transportation, imageUrl: self.imageUrl, favorited: false, notes: "", appointmentDate: "", addedDate: convertDateToString(date: Date()))
            
            //saving apartment detail on firebase
            NetworkServices.saveApartmentOnFirebase(appartmentInfo: self.listing.dictionary()) { (isAdded, error) in
                if error == nil && isAdded == true {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        } catch Exception.Error (let type, let message) {
            print(type,message)
            print(message)
        } catch {
            print("")
        }
    }
    //scrape data from zillow website
    func processZillow(htmlContent: String) {
        do {
            //view extracted html
            //print("htmlContent: \(htmlContent)")
            
            let doc: Document = try SwiftSoup.parseBodyFragment(htmlContent)
            self.addressTest = try doc.getElementsByClass("ds-address-container").text()
            self.price = try doc.getElementsByClass("ds-value").get(0).text()
            self.descriptionText = try doc.getElementsByClass("ds-overview-section").get(1).text()
            //print("description: ", self.descriptionText)
            guard let details: [Element] = try (doc.getElementsByClass("ds-bed-bath-living-area-container").first()?.children().array()) else {
                showAlert(titleString: "Error!", messageString: "Something went wrong with the link. Please try again!")
                return
            }
            //similar to streeteasy - append listing details
            for index in 0...details.count - 1 {
                
                let temp = try details[index].text()
                if self.bed != " "{
                    self.bed = self.bed + " | " + temp
                } else {
                    self.bed = temp
                }
            }
            
            //similar - append amenities details
            let amenitiesHi: [Element] = try doc.getElementsByClass("ds-home-fact-list-item").array()
            for index in 0...amenitiesHi.count - 1  {
                let temp = try amenitiesHi[index].text()
                if self.amenities != " " {
                    self.amenities = self.amenities + " | " + temp
                } else {
                    self.amenities = temp
                }
                print(self.amenities)
            }
            
            //get photos from listing
            let jpgs: Elements? = try doc.getElementsByClass("media-stream").select("img[src$=.jpg]")
            self.imageUrl = (try jpgs?.get(0).attr("src"))!
            
            //add listing to database
            self.listing = Listing(address: self.addressTest, price: self.price ,description: self.descriptionText , bed: self.bed, bath: "", size: "", ppsqft: "", amenities: self.amenities, transportation: self.transportation, imageUrl: self.imageUrl, favorited: false, notes: "", appointmentDate: "", addedDate: convertDateToString(date: Date()))
            
            //saving apartment detail on firebase
            NetworkServices.saveApartmentOnFirebase(appartmentInfo: self.listing.dictionary()) { (isAdded, error) in
                if error == nil && isAdded == true {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        } catch Exception.Error (let type, let message) {
            print(type,message)
            print(message)
        } catch {
            print("")
        }
    }
    
    //button's actions
    @IBAction func BackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //submit the data to be processed and filtered into a listing
    @IBAction func SubmitButton(_ sender: Any) {
        if self.url.text != "" {
            if let url_new = URL(string: self.url.text!){
                //check if the website is supported
                if ((self.url.text?.contains("streeteasy"))! || (self.url.text?.contains("zillow"))!){
                    webView.load(URLRequest(url: url_new))
                    //print("URL: \(url_new)")
                    
                    //remove keyboard once submitted
                    self.view.endEditing(true)
                    
                    //set up temporrary imageview to display loading gif
                    let imageView = UIImageView(frame: self.view.frame)
                    imageView.loadGif(name: "loadgif")
                    imageView.contentMode = .scaleAspectFit
                    //fill the background with same color as loading gif for custom UX
                    imageView.backgroundColor =  UIColor(red: 114/255, green: 102/255, blue: 226/255, alpha: 1)
                    self.view.addSubview(imageView)
                }
                else{
                    self.showAlert(titleString: "Error!", messageString: "Only StreetEasy and Zillow are supported at this time.")
                }
            } else {
                self.showAlert(titleString: "Error!", messageString: "Invalid URL. Please enter valid url!")
            }
        } else {
            self.showAlert(titleString: "Error!", messageString: "Please eneter streeteasy apartment link.")
        }
    }
    
    //webview navigation delegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WEbview finish loading.")
        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()", completionHandler: { (html, error) in
            let htmlString = html as! String
            self.process(htmlContent: htmlString)
            print("finished evaluating javascript")
        })
    }
    
}
extension UIImage {
    /// Save PNG in the Documents directory
    func save(_ name: String) {
        //save processed images to check if it is correct
        let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        //let path: String = "/Users/jenniferwang/Documents/Transportation"
        print("path is: ", path)
        let url = URL(fileURLWithPath: path).appendingPathComponent(name)
        try! self.pngData()?.write(to: url)
        print("saved image at \(url)")
    }
    
    //convert all pixels in the image to either black or white for more accurate image processing
    func binarize() -> UIImage? {
        let grayScaledImg = self.grayImage()
        let imageSource = GPUImagePicture(image: grayScaledImg)
        let stillImageFilter = GPUImageAdaptiveThresholdFilter()
        stillImageFilter.blurRadiusInPixels = 8.0
        
        imageSource!.addTarget(stillImageFilter)
        stillImageFilter.useNextFrameForImageCapture()
        imageSource!.processImage()
        guard let retImage: UIImage = stillImageFilter.imageFromCurrentFramebuffer(with: UIImage.Orientation.up) else {
            print("unable to obtain UIImage from filter")
            return nil
        }
        return retImage
    }
    
    //processing image before binarization
    func grayImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1.0)
        let imageRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: imageRect, blendMode: .luminosity, alpha:  1.0)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage
    }

}
