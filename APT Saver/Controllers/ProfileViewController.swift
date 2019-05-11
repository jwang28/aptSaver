//
//  ProfileViewController.swift
//  APT Saver
//
//  Created by Jin Joo Lee on 5/9/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class ProfileViewController: UIViewController {
    
    //interface builder
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let name = User.currentUser.name {
            self.nameLabel.text = name
        }
        
        if let email =  User.currentUser.email {
            self.emailLabel.text = email
        }
        
        
    }
    
    //custom methods
    func showLoginScreen() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavigationController = mainStoryboard.instantiateViewController(withIdentifier: "LoginNavigationController")
        //create instant of app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.replaceRootViewController(with: loginNavigationController, animated: true)
    }
    
    //button actions methods
    @IBAction func logoutButtonPressed(sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
        LoginManager().logOut()
        do {
            try Auth.auth().signOut()
            User.currentUser.logOut()
            self.showLoginScreen()
        } catch _ {
            print("Something went wrong with logout please try again!")
        }
    }

}
