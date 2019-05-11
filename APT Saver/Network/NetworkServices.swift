//
//  NetworkServices.swift
//  APT Saver
//
//  Created by Jin Joo Lee on 5/9/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import Foundation
import Firebase

class NetworkServices {
    
    //save apartment information on firebase database
    static func saveApartmentOnFirebase(appartmentInfo: [String: Any], completion: @escaping ((Bool, Error?) -> ())) {
        let apartmentRef = Database.database().reference(withPath: "apartments").child(User.currentUser.id!).child(appartmentInfo["date"] as! String)
        apartmentRef.setValue(appartmentInfo) { (error, ref) in
            if error != nil {
                print("Apartment information doesn't saved on firebase!")
                completion(false, error)
            } else {
                print("Apartment information saved on firebase!")
                completion(true, nil)
            }
        }
    }
    
    //fetch all apartments from firebase database
    static func fetchApartments(completion: @escaping (_ response: Any?) -> Void) {
        let apartmentRef = Database.database().reference(withPath: "apartments").child("\(User.currentUser.id!)")
        apartmentRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.value != nil {
                var apartments: [Listing] = []
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                        let apartment = Listing(snapshot: snapshot) {
                        apartments.append(apartment)
                    }
                }
                completion(apartments)
            } else {
                completion(nil)
            }
        })
    }
    
    
    //mark apartment as favorite
    static func markApartmentFavourite(data: [String: Any], completion: @escaping ((Bool, Error?) -> ())) {
        let apartmentRef = Database.database().reference(withPath: "apartments").child(User.currentUser.id!).child(data["date"] as! String)
        apartmentRef.setValue(data) { (error, ref) in
            if error == nil {
                completion(true, nil)
                print("Apartment favorite changed!")
            } else {
                completion(false, error)
                print("Apartment favorite not changed!")
            }
        }
        
    }
    
    //update
    static func updateApartmentInfo(data: [String: Any], completion: @escaping ((Bool, Error?) -> ())) {
        let apartmentRef = Database.database().reference(withPath: "apartments").child(User.currentUser.id!).child(data["date"] as! String)
        apartmentRef.setValue(data) { (error, ref) in
            if error == nil {
                completion(true, nil)
                print("Apartment info updated!")
            } else {
                completion(false, error)
                print("Apartment info not updated!")
            }
        }
        
    }
    
    //delete apartment from firebase
    static func deleteApartmentInfo(data: [String: Any], completion: @escaping ((Bool, Error?) -> ())) {
        let apartmentRef = Database.database().reference(withPath: "apartments").child(User.currentUser.id!).child(data["date"] as! String)
        apartmentRef.removeValue { (error, ref) in
            if error == nil {
                completion(true, nil)
                print("Apartment deleted!")
            } else {
                completion(false, error)
                print("Apartment can not deleted!")
            }
        }
    }
}
