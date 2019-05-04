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

    @IBOutlet weak var url: UITextField!
    var address: String?
    @IBAction func submit(_ sender: Any) {
        if url.text != ""{
            //let url_new = URL(string: self.url.text!)
            let url_new = URL(string: "https://streeteasy.com/building/mantena-431-west-37-street-new_york/2a?similar=1")
            
            let task = URLSession.shared.dataTask(with: url_new!) { (data, response, error) in
                if error != nil {
                    print (error)
                }
                else {
                    //let htmlContent = NSString(data: data!,encoding: String.Encoding.utf8.rawValue)
                    let htmlContent = String(data: data!,encoding: String.Encoding.utf8)!
                    do {
                        let doc: Document = try SwiftSoup.parseBodyFragment(htmlContent)
                        
                        self.address = try doc.getElementsByClass("building-title").text()
                        let price = try doc.getElementsByClass("price").text()
                        
                        print(price)
                        
                    } catch Exception.Error (let type, let message){
                        print(type,message)
                        print(message)
                    } catch {
                        print("")
                    }
                }
            }
            task.resume()
            
            performSegue(withIdentifier: "submit", sender: self)
        }
    }
    
    var listings: [Listing]?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainTable = segue.destination as! ListingTableViewController
        //mainTable.test = url.text
        listings?.append(Listing(address: "address", price: "4500",description: "lorem ipsum doler other irrelevant information here to fill  up space", bed: "3", bath: "2", size: "1000 sq ft", ppsqft: "$66.01/ft sq", amenities: "elevator", transportation: "ACE subway", imageName: "first"))
        mainTable.listingTypes[0].listings = self.listings!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
