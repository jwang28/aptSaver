//
//  User.swift
//  APT Saver
//
//  Created by Jin Joo Lee on 5/9/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

let UserID = "id"
let UserName = "fullname"
let UserEmail = "email"

import Foundation
import Firebase

class User {
    var id: String?
    var name: String?
    var email: String?
    
    // Used to check either user is logged in or not
    var isLoggedIn: Bool {
        return self.id != nil
    }
    
    static let currentUser : User = {
        let instance = User()
        return instance
    }()
    
    init() {
        self.setUp()
    }
    
    fileprivate func setUp(){
        self.id = UserDefaults.standard.string(forKey: UserID)
        self.name = UserDefaults.standard.string(forKey: UserName)
        self.email = UserDefaults.standard.string(forKey: UserEmail)
    }
    
    func saveUserInformation(userInfo: [String: Any]) {
        if let id = userInfo[UserID] as? String {
            self.id = id
            UserDefaults.standard.set(self.id, forKey: UserID)
        }
        if let name = userInfo[UserName] as? String {
            self.name = name
            UserDefaults.standard.set(self.name, forKey: UserName)
        }
        if let email = userInfo[UserEmail] as? String {
            self.email = email
            UserDefaults.standard.set(self.email, forKey: UserEmail)
        }
    }
    
    func logOut(){
        self.id = nil
        self.name = nil
        self.email = nil
        
        UserDefaults.standard.set(nil, forKey: UserID)
        UserDefaults.standard.set(nil, forKey: UserName)
        UserDefaults.standard.set(nil, forKey: UserEmail)
    }
}
