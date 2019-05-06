//
//  ViewController.swift
//  aptSaver
//
//  Created by Jin Joo Lee on 5/1/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookCore
import FacebookLogin

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var clickNextButton: UIButton!
    
    //Button for SIGN OUT
    //Not delegate method, all done locally
    @IBAction func signOutWasPressed(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.performSegue(withIdentifier: "LoginToList", sender: self)
            }
        } else {
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
        
        //FOR GOOGLE SIGN-IN
        //method tries to sign the user in without any confirmation dialogue
        //start -> signInSilentyl() => Did it work? => if YES, update info, if needed; if NO, show sign in button
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        
        //FOR FACEBOO SIGN-IN
        //let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        //loginButton.center = view.center
        //loginButton.center = view.center.y - 100
        //view.addSubview(loginButton)
    }
    
    //Signout function
    @objc func signOut(_ sender: UIButton) {
        print("Signing Out")
        GIDSignIn.sharedInstance().signOut() //will sign us out of google
    }
}
