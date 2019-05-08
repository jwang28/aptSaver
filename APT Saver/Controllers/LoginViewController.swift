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
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, LoginButtonDelegate {
//    @IBOutlet weak var welcomeLabel: UILabel!
//    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var facebooksignInButton: FBLoginButton!
    //    @IBOutlet weak var clickNextButton: UIButton!
    
    //Button for SIGN OUT
    //Not delegate method, all done locally
//    @IBAction func signOutWasPressed(_ sender: AnyObject) {
//        GIDSignIn.sharedInstance().signOut()
//    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            Auth.auth().signInAndRetrieveData(with: credential) { [weak self] (authResult, error) in
                if let error = error {
                    print("Error signInAndRetrieveData: \(error.localizedDescription)")
                    return
                }
                // User is signed in
                // ...
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "LoginToList", sender: self)
                }
            }
        } else {
            print(error)
        }
    }
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let tokenString = result?.token?.tokenString {
            let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
            Auth.auth().signInAndRetrieveData(with: credential) { [weak self] (authResult, error) in
                if let error = error {
                    // ...
                    print("Error signInAndRetrieveData: \(error.localizedDescription)")
                    return
                }
                // User is signed in
                // ...
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "LoginToList", sender: self)
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTitle(title: "Login")
        GIDSignIn.sharedInstance()?.delegate = self
        
        //FOR GOOGLE SIGN-IN
        //method tries to sign the user in without any confirmation dialogue
        //start -> signInSilentyl() => Did it work? => if YES, update info, if needed; if NO, show sign in button
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        
        //FOR FACEBOO SIGN-IN
//        let loginButton = FBLoginButton(frame: CGRect(x: 0, y: 0, width: 360, height: 45), permissions: [ .publicProfile ])
//        var center = view.center
//        center.y -= 100
//        loginButton.center = center
//        loginButton.delegate = self
//        view.addSubview(loginButton)
    }
    
    //Signout function
    @objc func signOut(_ sender: UIButton) {
        print("Signing Out")
        GIDSignIn.sharedInstance().signOut() //will sign us out of google
    }
    
    // MARK: - LoginButtonDelegate
    
//    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
//        if let tokenString = result?.token?.tokenString {
//            let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
//            Auth.auth().signInAndRetrieveData(with: credential) { [weak self] (authResult, error) in
//                if let error = error {
//                    // ...
//                    print("Error signInAndRetrieveData: \(error.localizedDescription)")
//                    return
//                }
//                // User is signed in
//                // ...
//                DispatchQueue.main.async {
//                    self?.performSegue(withIdentifier: "LoginToList", sender: self)
//                }
//            }
//        }
//
//    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    func loginButtonWillLogin(_ loginButton: FBLoginButton) -> Bool {
        return true
    }
    
}
