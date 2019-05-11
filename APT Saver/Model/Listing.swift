//
//  Listing.swift
//  APT Saver
//
//  Created by Jennifer Wang on 3/29/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

//Listing (Fee and No fee)

import UIKit
import Firebase

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
    var imageUrl: String
    var favorited: Bool
    var notes: String
    var appointmentDate: String
    var addedDate: String
    
    init() {
        self.address = ""
        self.price = ""
        self.description = ""
        self.bed = ""
        self.bath = ""
        self.size = ""
        self.ppsqft = ""
        self.amenities = ""
        self.transportation = ""
        self.favorited = false
        self.imageUrl = ""
        self.notes = ""
        self.appointmentDate = ""
        self.addedDate = ""
    }
    
    init(address: String, price: String,description: String, bed: String, bath: String, size: String, ppsqft: String, amenities: String, transportation: String, imageUrl: String, favorited: Bool, notes: String, appointmentDate: String, addedDate: String) {
        self.address = address
        self.price = price
        self.description = description
        self.bed = bed
        self.bath = bath
        self.size = size
        self.ppsqft = ppsqft
        self.amenities = amenities
        self.transportation = transportation
        self.favorited = favorited
        self.imageUrl = imageUrl
        self.notes = notes
        self.appointmentDate = appointmentDate
        self.addedDate = addedDate
    }
    
    //init class properties using firebase key value pair
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let address = value["address"] as? String,
            let price = value["price"] as? String,
            let description = value["description"] as? String,
            let bed = value["bed"] as? String,
            let bath = value["bath"] as? String,
            let size = value["size"] as? String,
            let ppsqft = value["ppsqft"] as? String,
            let amenities = value["amenities"] as? String,
            let transportation = value["transportation"] as? String,
            let favorited = value["favorited"] as? Bool,
            let imageUrl = value["imageUrl"] as? String,
            let notes = value["notes"] as? String,
            let appointmentDate = value["appointmentDate"] as? String,
            let addedDate = value["date"] as? String else {
                return nil
        }
        
        self.address = address
        self.price = price
        self.description = description
        self.bed = bed
        self.bath = bath
        self.size = size
        self.ppsqft = ppsqft
        self.amenities = amenities
        self.transportation = transportation
        self.favorited = favorited
        self.imageUrl = imageUrl
        self.notes = notes
        self.appointmentDate = appointmentDate
        self.addedDate = addedDate
    }
    
    //convert properties data in to dictionary
    func dictionary() -> [String: Any] {
        var dic = [String: Any]()
        dic["address"] = self.address
        dic["price"] = self.price
        dic["description"] = self.description
        dic["bed"] = self.bed
        dic["bath"] = self.bath
        dic["size"] = self.size
        dic["ppsqft"] = self.ppsqft
        dic["amenities"] = self.amenities
        dic["transportation"] = self.transportation
        dic["imageUrl"] = self.imageUrl
        dic["notes"] = self.notes
        dic["appointmentDate"] = self.appointmentDate
        dic["favorited"] = self.favorited
        dic["date"] = self.addedDate
        
        return dic
    }
}


