//
//  ListingType.swift
//  APT Saver
//
//  Created by Jennifer Wang on 4/29/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit

class ListingType
{
    var name: String
    var listings: [Listing]
    
    init(named: String, includeListings: [Listing])
    {
        name = named
        listings = includeListings
    }
    
    class func getListingTypes() -> [ListingType]
    {
        return [noFee(), Fee()]
    }
    
    //Mark: -private helper methods
    
    private class func noFee() -> ListingType
    {
        var listings = [Listing]()
        
        listings.append(Listing(address: "Address Here", price: "price",description: "lorem ipsum doler", bed: "3", bath: "2", size: "1000 sq ft", ppsqft: "$66.01/ft sq", amenities: "elevator", transportation: "ACE subway", imageName: "default"))
//        listings.append(Listing(titled: "Second Apartment",description: "This is the 2nd one you'll be seeing. Hope you like it and sign the lease soon.", imageName: "default"))
        
        return ListingType(named: "No Fee", includeListings: listings)
    }
    private class func Fee() -> ListingType
    {
        var listings = [Listing]()
        
//        listings.append(Listing(titled: "Second Apartment",description: "This is the 2nd one you'll be seeing. Hope you like it and sign the lease soon.", imageName: "default"))
        
        return ListingType(named: "Fee", includeListings: listings)
    }
}
