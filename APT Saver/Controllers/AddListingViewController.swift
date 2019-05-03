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
    @IBAction func submit(_ sender: Any) {
        if url.text != ""{
            let url_new = URL(string: self.url.text!)
            
            let task = URLSession.shared.dataTask(with: url_new!) { (data, response, error) in
                if error != nil {
                    print (error)
                }
                else {
                    //let htmlContent = NSString(data: data!,encoding: String.Encoding.utf8.rawValue)
                    let htmlContent = String(data: data!,encoding: String.Encoding.utf8)!
                    
                    print("end")
                    do {
                        let doc: Document = try SwiftSoup.parseBodyFragment(htmlContent)
                        
                        let address: String? = try doc.getElementsByClass("building-title").text()
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
            
            performSegue(withIdentifier: "submit", sender: self)
        }
    }
    
    var listings: [Listing]?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainTable = segue.destination as! ListingTableViewController
        mainTable.test = url.text
        listings?.append(Listing(titled: "Third Apartment",description: "This is the 1st one you'll be seeing. Hope you like it and sign the lease soon.", imageName: "first"))
        mainTable.listingTypes[0].listings = self.listings!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
