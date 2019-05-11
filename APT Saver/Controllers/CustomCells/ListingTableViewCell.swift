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
    @IBOutlet weak var listingPriceLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    
    var listing: Listing? {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        if let url = URL(string: listing!.imageUrl) {
            downloadImage(with: url)
        }
        listingTitleLabel?.text = listing?.address
        listingPriceLabel?.text = listing?.price
    }
    
    func downloadImage(with url: URL) {
        URLSession.shared.dataTask(with: url) { (data,response,error) in
            if error != nil {
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    self.listingImageView.image = image
                    print("there is an image")
                }
            }
            } .resume()
    }
}


