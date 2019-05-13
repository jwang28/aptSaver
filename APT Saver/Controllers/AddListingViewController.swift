//
//  AddListingViewController.swift
//  APT Saver
//
//  Created by Jennifer Wang on 5/3/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import SwiftSoup
import WebKit

protocol AddListingViewControllerDelegate {
    func didFinishLoadingData(listings: [Listing])
}

class AddListingViewController: UIViewController, WKNavigationDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //interface builder
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var linkTextFieldContainerView: UIView!
    
    @IBAction func chooseImage(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        //imageView.image =
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
    
    func process(htmlContent: String) {
        do {
            print("htmlContent: \(htmlContent)")
            
            let doc: Document = try SwiftSoup.parseBodyFragment(htmlContent)
            self.addressTest = try doc.getElementsByClass("building-title").text()
            self.price = try doc.getElementsByClass("price").text()
            self.descriptionText = try doc.getElementsByClass("Description-block jsDescriptionExpanded").text()
            
            
            
            guard let details: [Element] = try (doc.getElementsByClass("details_info").first()?.children().array()) else {
                showAlert(titleString: "Error!", messageString: "Something went wrong with the link. Please try again!")
                return
            }
            
            for index in 0...details.count - 1 {
                
                let temp = try details[index].text()
                if self.bed != " "{
                    self.bed = self.bed + " | " + temp
                } else {
                    self.bed = temp
                }
            }
            
            let amenitiesHi: [Element] = try doc.getElementsByClass("AmenitiesBlock-highlightsItem").array()
            for index in 0...amenitiesHi.count - 1  {
                let temp = try amenitiesHi[index].text()
                if self.amenities != " " {
                    self.amenities = self.amenities + " | " + temp
                } else {
                    self.amenities = temp
                }
                print(self.amenities)
            }
            
            let jpgs: Elements? = try doc.getElementById("carousel")?.select("img[src$=.jpg]")
            self.imageUrl = (try jpgs?.get(0).attr("src"))!
            let transportation: Element = try doc.getElementsByClass("Nearby-transportationList").get(0)
            self.transportation = try transportation.text()
            
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
    
    @IBAction func SubmitButton(_ sender: Any) {
        if self.url.text != "" {
            if let url_new = URL(string: self.url.text!) {
                webView.load(URLRequest(url: url_new))
                print("URL: \(url_new)")
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
        })
    }
    
}
