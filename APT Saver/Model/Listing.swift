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
    var image: UIImage
    var title: String
    var description: String
    var rating: ListingRating
    
    init(titled: String, description: String, imageName: String)
    {
        self.title = titled
        self.description = description
        if let image = UIImage(named: imageName){
            self.image = image
        } else{
            self.image = UIImage(named: "default")!
        }
        
        rating = .unrated
    }
}


