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

class ViewController: UIViewController, GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //FOR FACEBOO SIGN-IN
        //let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        //loginButton.center = view.center
        //loginButton.center = view.center.y - 100
        //view.addSubview(loginButton)
        
        //FOR GOOGLE SIGN-IN
        GIDSignIn.sharedInstance().uiDelegate = self
        // Uncomment to automatically sign in the user.
        GIDSignIn.sharedInstance().signInSilently()
        // TODO(developer) Configure the sign-in button look/feel
        let gSignIn = GIDSignInButton (frame: CGRect(x: 0, y: 0, width: 230, height: 48))
        //make it go to center of screen
        gSignIn.center = view.center
        view.addSubview(gSignIn)
        
        //Add sign out button
        let signOut = UIButton(frame: CGRect(x: 50, y: 50, width: 100, height: 30)) //create UI Button
        signOut.backgroundColor = UIColor.red //set button color to red
        signOut.setTitle("Sign Out", for: .normal) //set title as signout
        signOut.center = view.center  //set to center of screen
        signOut.center.y = view.center.y + 100 //below googlesign button
        signOut.addTarget(self, action: #selector(self.signOut(_:)), for: .touchUpInside) //what happens when we use the signout button, touchUpInsde is when we release tap of the button
        self.view.addSubview(signOut)
        
        // Do any additional setup after loading the view.
    }
    
    //signout function
    @objc func signOut(_ sender: UIButton) {
        print("Signing Out")
        GIDSignIn.sharedInstance().signOut() //will sign us out of google
    }
    
}

