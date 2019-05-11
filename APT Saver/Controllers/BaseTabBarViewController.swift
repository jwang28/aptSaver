//
//  BaseTabBarViewController.swift
//  APT Saver
//
//  Created by Jin Joo Lee on 5/9/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import Firebase

class BaseTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //check if user is already logged in
        if Auth.auth().currentUser == nil {
            self.showLoginScreen()
        }
    }
    
    func showLoginScreen() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavigationController = mainStoryboard.instantiateViewController(withIdentifier: "LoginNavigationController")
        //create instant of app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.replaceRootViewController(with: loginNavigationController, animated: true)
    }
}
