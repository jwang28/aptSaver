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
        return [favorites(), other()]
    }
    
    //Mark: -private helper methods
    
    private class func favorites() -> ListingType
    {
        var listings = [Listing]()
        
//        listings.append(Listing(address: "Address Here", price: "price",description: "lorem ipsum doler", bed: "3", bath: "2", size: "1000 sq ft", ppsqft: "$66.01/ft sq", amenities: "elevator", transportation: "ACE subway", imageName: "default"))
//        listings.append(Listing(address: "Address Here 2", price: "price",description: "lorem ipsum doler", bed: "3", bath: "2", size: "1000 sq ft", ppsqft: "$66.01/ft sq", amenities: "elevator", transportation: "ACE subway", imageName: "default"))
      
        
        return ListingType(named: "Favorites", includeListings: listings)
    }
    private class func other() -> ListingType
    {
        var listings = [Listing]()
        
        listings.append(Listing(address: "Address Here 3", price: "price",description: "lorem ipsum doler", bed: "3", bath: "2", size: "1000 sq ft", ppsqft: "$66.01/ft sq", amenities: "elevator", transportation: "ACE subway", imageName: "default", favorited: false))
        listings.append(Listing(address: "Address Here", price: "price",description: "lorem ipsum doler", bed: "3", bath: "2", size: "1000 sq ft", ppsqft: "$66.01/ft sq", amenities: "elevator", transportation: "ACE subway", imageName: "default", favorited: false))
        listings.append(Listing(address: "Address Here 2", price: "price",description: "lorem ipsum doler", bed: "3", bath: "2", size: "1000 sq ft", ppsqft: "$66.01/ft sq", amenities: "elevator", transportation: "ACE subway", imageName: "default", favorited: false))
        return ListingType(named: "Other", includeListings: listings)
    }
}
