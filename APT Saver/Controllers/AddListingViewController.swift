//
//  AddListingViewController.swift
//  APT Saver
//
//  Created by Jennifer Wang on 5/3/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import SwiftSoup

protocol AddListingViewControllerDelegate {
    func didFinishLoadingData(listings: [Listing])
}

class AddListingViewController: UIViewController {
    
    //interface builder
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var linkTextFieldContainerView: UIView!
    
    //properties
    var delegate: AddListingViewControllerDelegate?
    var images = UIImage(named: "default")
    var addressTest = " "
    var price = " "
    var descriptionText = " "
    var bed = " "
    var bath = " "
    var size = " "
    var ppsqft = " "
    var amenities = " "
    var transportation = " "
    var listings: [Listing]?
    
    //viewcontroller's lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
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
            
            let details: [Element] = try (doc.getElementsByClass("details_info").first()?.children().array())!
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
            try self.downloadImage(with: URL(string: (jpgs?.get(0).attr("src"))!)!)
            let transportation: Element = try doc.getElementsByClass("Nearby-transportationList").get(0)
            self.transportation = try transportation.text()
            
            self.dismiss(animated: true, completion: {
                self.listings?.append(Listing(address: self.addressTest, price: self.price ,description: self.descriptionText , bed: self.bed, bath: "", size: "", ppsqft: "", amenities: self.amenities, transportation: self.transportation, imageName: self.images!, favorited: false, notes: "", appointmentDate: ""))
                self.delegate?.didFinishLoadingData(listings:  self.listings!)
            })
            
        } catch Exception.Error (let type, let message) {
            print(type,message)
            print(message)
        } catch {
            print("")
        }
    }
    
    func downloadImage(with url: URL) {
        URLSession.shared.dataTask(with: url) { (data,response,error) in
            if error != nil {
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    self.images = image
                    print("there is an image")
                }
            }
        } .resume()
    }
    
    //button's actions
    @IBAction func BackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SubmitButton(_ sender: Any) {
        // TODO: remove this line of code (testing URL)
        url.text = "https://streeteasy.com/building/the-continental-885-6-avenue-new_york/35g"
        
        //Created another webView and parse data from there because streeteasy won't let outside bots to parse through data
        if url.text != ""{
            let url_new = URL(string: self.url.text!)
            webView.loadRequest(URLRequest(url: url_new!))
            print("URL: \(url_new!)")
            
            //            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4.0) {
            //                let string = self.webView.stringByEvaluatingJavaScript(from: "document.body.innerHTML")!
            //                print("string: \(string)")
            //                self.process(htmlContent: string)
            //            }
            //            let string = self.webView.stringByEvaluatingJavaScript(from: "document.body.innerHTML")!
            //            print("string: \(string)")
            //            self.process(htmlContent: string)
            //            return
            
            //Letting URL parse through
            let task = URLSession.shared.dataTask(with: url_new!) { (data, response, error) in
                if error != nil {
                    print (error!)
                } else {
                    let htmlContent = String(data: data!,encoding: String.Encoding.utf8)!
                    self.process(htmlContent: htmlContent)
                }
            }
            task.resume()
        }
    }
    
    
    //segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainTable = segue.destination as! ListingTableViewController
        self.listings?.append(Listing(address: self.addressTest, price: self.price ,description: self.descriptionText , bed: self.bed, bath: "", size: "", ppsqft: "", amenities: self.amenities, transportation: self.transportation, imageName: self.images!, favorited: false, notes: "", appointmentDate: ""))
        mainTable.listingTypes[1].listings = self.listings!
        print(mainTable.listingTypes[0].listings)
    }
}
