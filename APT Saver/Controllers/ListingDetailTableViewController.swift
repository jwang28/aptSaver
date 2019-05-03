//
//  ListingDetailTableViewController.swift
//  APT Saver
//
//  Created by Jennifer Wang on 5/1/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit

class ListingDetailTableViewController: UITableViewController {
    @IBOutlet weak var listingTitleTextField: UITextField!
    
    @IBOutlet weak var listingDescriptionTextView: UITextView!
    @IBOutlet weak var listingImageView: UIImageView!
//    var listing: Listing? = ListingType.getListingTypes()[0].listings[0]
    var listing: Listing?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Listing"
        
        listingImageView.image = listing?.image
        listingTitleTextField.text  = listing?.title
        listingDescriptionTextView.text = listing?.description
    }
    

}
