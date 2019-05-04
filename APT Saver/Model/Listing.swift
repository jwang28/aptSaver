//
//  Listing.swift
//  APT Saver
//
//  Created by Jennifer Wang on 3/29/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

//Listing (Fee and No fee)

import UIKit
//import Foundation
enum ListingRating{
    case unrated
    case no
    case maybe
    case yes
    case dream
}

class Listing
{
    
    var address: String
    var price: String
    var description: String
    var bed: String
    var bath: String
    var size: String
    var ppsqft: String
    var amenities: String
    var transportation: String
    var image: UIImage
    
    init(address: String, price: String,description: String, bed: String, bath: String, size: String, ppsqft: String, amenities: String, transportation: String, imageName: String)
    {
        self.address = address
        self.price = price
        self.description = description
        self.bed = bed
        self.bath = bath
        self.size = size
        self.ppsqft = ppsqft
        self.amenities = amenities
        self.transportation = transportation
        if let image = UIImage(named: imageName){
            self.image = image
        } else{
            self.image = UIImage(named: "default")!
        }
    }
}


