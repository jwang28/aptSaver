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
   //  @IBOutlet weak var listingTransportationLabel: UILabel!
    
    //    var listing: Listing? = ListingType.getListingTypes()[0].listings[0]
    var listing: Listing?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Listing"
        transportCollectionView.delegate = self
        transportCollectionView.dataSource = self
        
        listingImageView.image = listing?.image
        listingTitleTextField.text  = listing?.address
        listingDescriptionTextView.text = listing?.description
        listingPriceLabel.text = listing?.price
        listingBedLabel.text = listing?.bed
        listingBathLabel.text = listing?.bath
        listingSizeLabel.text = listing?.size
        listingPpsqftLabel.text = listing?.ppsqft
        listingAmenitiesLabel.text = listing?.amenities
        // listingTransportationLabel.text = listing?.transportation
        
    }
    
    @IBOutlet weak var transportCollectionView: UICollectionView!
    
}

var dummyTransportOPtions: [[String]] = [["A", "E", "C"], ["N", "Q"], ["R", "W", "B", "F"]]

extension ListingDetailTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyTransportOPtions[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = transportCollectionView.dequeueReusableCell(withReuseIdentifier: "transportCellId", for: indexPath) as! TransportCollectionViewCell
        cell.transportLetter.text = dummyTransportOPtions[indexPath.section][indexPath.row]
        return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dummyTransportOPtions.count
    }
}


