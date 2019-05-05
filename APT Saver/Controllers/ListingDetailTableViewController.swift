//
//  ListingDetailTableViewController.swift
//  APT Saver
//
//  Created by Jennifer Wang on 5/1/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit

class ListingDetailTableViewController: UITableViewController {
    @IBOutlet weak var listingTitleTextField: UILabel!
    
    @IBOutlet weak var listingDescriptionTextView: UITextView!
    @IBOutlet weak var listingPriceLabel: UILabel!
    @IBOutlet weak var listingImageView: UIImageView!
    @IBOutlet weak var listingBedLabel: UILabel!
    @IBOutlet weak var listingBathLabel: UILabel!
    @IBOutlet weak var listingSizeLabel: UILabel!
    @IBOutlet weak var listingPpsqftLabel: UILabel!
    @IBOutlet weak var listingAmenitiesLabel: UILabel!
    @IBOutlet weak var listingTransportationLabel: UILabel!
    
    //    var listing: Listing? = ListingType.getListingTypes()[0].listings[0]
    var listing: Listing?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Listing"
        
        listingImageView.image = listing?.image
        listingTitleTextField.text  = listing?.address
        listingDescriptionTextView.text = listing?.description
        listingPriceLabel.text = listing?.price
        listingBedLabel.text = listing?.bed
        listingBathLabel.text = listing?.bath
        listingSizeLabel.text = listing?.size
        listingPpsqftLabel.text = listing?.ppsqft
        listingAmenitiesLabel.text = listing?.amenities
        listingTransportationLabel.text = listing?.transportation
        
    }
    
}


