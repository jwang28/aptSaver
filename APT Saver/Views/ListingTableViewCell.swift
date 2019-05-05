//
//  ListingTableViewCell.swift
//  APT Saver
//
//  Created by Jennifer Wang on 5/1/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit

class ListingTableViewCell: UITableViewCell {

    @IBOutlet weak var listingImageView: UIImageView!
    @IBOutlet weak var listingTitleLabel: UILabel!
    @IBOutlet weak var listingDescriptionLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    
    
    var listing: Listing? {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        listingImageView?.image = listing?.image
        listingTitleLabel?.text = listing?.address
        listingDescriptionLabel?.text = listing?.description
    }
}


