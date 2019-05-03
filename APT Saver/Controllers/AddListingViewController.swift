//
//  AddListingViewController.swift
//  APT Saver
//
//  Created by Jennifer Wang on 5/3/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit

class AddListingViewController: UIViewController {

    @IBOutlet weak var url: UITextField!
    @IBAction func submit(_ sender: Any) {
        if url.text != ""{
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
        
        // Do any additional setup after loading the view.
    }
    

    

}
