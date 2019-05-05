//
//  AddListingViewController.swift
//  APT Saver
//
//  Created by Jennifer Wang on 5/3/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import SwiftSoup

class AddListingViewController: UIViewController {

    
    
    

    @IBAction func SubmitButton(_ sender: Any) {
        if url.text != ""{
            let url_new = URL(string: self.url.text!)
            //let url_new = URL(string: "https://streeteasy.com/building/mantena-431-west-37-street-new_york/2a?similar=1")
            let task = URLSession.shared.dataTask(with: url_new!) { (data, response, error) in
                
                if error != nil {
                    print (error)
                }
                else {
                    let htmlContent = String(data: data!,encoding: String.Encoding.utf8)!
                    do {
                        let doc: Document = try SwiftSoup.parseBodyFragment(htmlContent)
                        
                        self.addressTest = try doc.getElementsByClass("building-title").text()
                        self.price = try doc.getElementsByClass("price").text()
                        self.descriptionText = try doc.getElementsByClass("Description-block jsDescriptionExpanded").text()
                        //get listing details (1=sq ft, price/sq ft, rooms, beds, 5=bath)
                        //problem here because it is inconsistent
                        //let details: [Element] = try doc.getElementsByClass("details_info").get(0).getAllElements().array()
                        let details: Element = try doc.getElementsByClass("details_info").get(0)
                        self.bed = try details.text()
                        
                        
                        //self.size = try details[1].text()
                        //print("size", self.size)
                        //let amenitiesHi: [Element] = try doc.getElementsByClass("AmenitiesBlock-highlights").get(0).getAllElements().array()
                        //let buildingAmenities: [Element] = try doc.getElementsByClass("AmenitiesBlock-list ").get(0).getAllElements().array()
                        //let listingAmenities: [Element] = try doc.getElementsByClass("AmenitiesBlock-list ").get(1).getAllElements().array()
                        let amenitiesHi: Element = try doc.getElementsByClass("AmenitiesBlock-highlights").get(0)
                        
                        let jpgs: Elements? = try doc.getElementById("carousel")?.select("img[src$=.jpg]")
                        
                        print("jpgs", try jpgs?.array())
                        print("get images", try jpgs?.get(1).attr("src"), "end")
                        try self.downloadImage(with: URL(string: (jpgs?.get(0).attr("src"))!)!)
                        
                       // for index in 0...amenitiesHi.count {
                            self.amenities = try amenitiesHi.text()
                            //print(try amenitiesHi.text())
                            
                        //}
                        let transportation: Element = try doc.getElementsByClass("Nearby-transportationList").get(0)
                        self.transportation = try transportation.text()
                        
                        
                    } catch Exception.Error (let type, let message){
                        print(type,message)
                        print(message)
                    } catch {
                        print("")
                    }
                }
            }
            task.resume()
        }
        let delaySeconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delaySeconds) {
            self.performSegue(withIdentifier: "submit", sender: self)
        }
        
    }
    @IBOutlet weak var url: UITextField!
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
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func downloadImage(with url: URL){
        URLSession.shared.dataTask(with: url) { (data,response,error) in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data!){
                    self.images = image
                    print("there is an image")
                }
            }
        }.resume()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainTable = segue.destination as! ListingTableViewController
        
        
        self.listings?.append(Listing(address: self.addressTest, price: self.price ,description: self.descriptionText , bed: self.bed, bath: "", size: "", ppsqft: "", amenities: self.amenities, transportation: self.transportation, imageName: self.images!, favorited: false))
        mainTable.listingTypes[1].listings = self.listings!
        print(mainTable.listingTypes[0].listings)
    }
}

//let url = URL(string: "https://streeteasy.com/building/mantena-431-west-37-street-new_york/2a?similar=1")
//
//let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
//    if error != nil {
//        print (error)
//    }
//    else {
//        //let htmlContent = NSString(data: data!,encoding: String.Encoding.utf8.rawValue)
//        let htmlContent = String(data: data!,encoding: String.Encoding.utf8)!
//
//        print("end")
//        do {
//            let doc: Document = try SwiftSoup.parseBodyFragment(htmlContent)
//
//            let address: String? = try doc.getElementsByClass("building-title").text()
//            let price = try doc.getElementsByClass("price").text()
//            //                    let size = try doc.getElementsByClass("detail_cell first_detail_cell").text()
//            //                    let rooms = try doc.getElementsByClass("details_info").text()
//            //                    let description = try doc.getElementsByClass("Description-block jsDescriptionExpanded").text()
//            //get listing details (1=sq ft, price/sq ft, rooms, beds, 5=bath)
//            //                    let details: [Element] = try doc.getElementsByClass("details_info").get(0).getAllElements().array()
//            //                    let amenitiesHi: [Element] = try doc.getElementsByClass("AmenitiesBlock-highlights").get(0).getAllElements().array()
//            //                    let buildingAmenities: [Element] = try doc.getElementsByClass("AmenitiesBlock-list ").get(0).getAllElements().array()
//            //                    let listingAmenities: [Element] = try doc.getElementsByClass("AmenitiesBlock-list ").get(1).getAllElements().array()
//            //print(try details[4].text())
//            //print (try buildingAmenities[7].text())
//            //print(doc)
//            print(price)
//
//        } catch Exception.Error (let type, let message){
//            print(type,message)
//            print(message)
//        } catch {
//            print("")
//        }
//    }
//}
//
//task.resume()
