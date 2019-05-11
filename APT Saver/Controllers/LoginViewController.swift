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

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    //interface builder
    @IBOutlet weak var googleSignInButton: UIButton!
    @IBOutlet weak var facebookSignInButton: UIButton!
    
    //properties
    
    
    //viewcontroller's lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTitle(title: "Login")
    }
    
    //custom methods
    func showHomeScreen() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = mainStoryboard.instantiateViewController(withIdentifier: "BaseTabBarViewController")
        //create instant of app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.replaceRootViewController(with: mainTabBarController, animated: true)
    }
    
    //button's actions
    @IBAction func googleSignInButtonPressed() {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.signIn()
        
    }
    
    @IBAction func facebookSignInButtonPressed() {
        let loginManager = LoginManager()
        
        loginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if error != nil {
                self.showAlert(titleString: "Error!", messageString: "Something went wrong. Try again.")
                print(error!)
            } else {
                if let tokenString = result?.token?.tokenString {
                    //getting credential from facebook for login
                    let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
                    //firebase
                    Auth.auth().signInAndRetrieveData(with: credential) { [weak self] (authResult, error) in
                        if let error = error {
                            self?.showAlert(titleString: "Error!", messageString: "Something went wrong. Try again.")
                            print("Error signInAndRetrieveData: \(error.localizedDescription)")
                            return
                        }
                        
                        //fetch user information from facebook
                        let req = GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: result?.token?.tokenString, version: nil, httpMethod: HTTPMethod(rawValue: "GET"))
                        req.start(completionHandler: { (connection, result, error) in
                            if error == nil {
                                let userData = result as! [String: Any]
                                //save user information into UserDefaults
                                let fullName = userData["name"] as! String
                                let email = userData["email"] as! String
                                
                                var userDataDic = [String: Any]()
                                userDataDic["id"] = Auth.auth().currentUser?.uid
                                userDataDic["fullname"] = fullName
                                userDataDic["email"] = email
                                
                                User.currentUser.saveUserInformation(userInfo: userDataDic)
                                // User is signed in
                                self!.showHomeScreen()
                            } else {
                                do {
                                    try Auth.auth().signOut()
                                } catch _ {
                                    print("Something went wrong with logout please try again!")
                                }
                                self?.showAlert(titleString: "Error!", messageString: "Something went wrong. Try again.")
                            }
                        })
                        
                        
                    }
                }
            }
        }
    }
    
    //google signin delegate methods
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            Auth.auth().signInAndRetrieveData(with: credential) { [weak self] (authResult, error) in
                if let error = error {
                    self?.showAlert(titleString: "Error!", messageString: "Something went wrong. Try again.")
                    print("Error signInAndRetrieveData: \(error.localizedDescription)")
                    return
                }
                //save user information into UserDefaults
                let fullName = user.profile.name
                let email = user.profile.email
                
                var userDataDic = [String: Any]()
                userDataDic["id"] = Auth.auth().currentUser?.uid
                userDataDic["fullname"] = fullName
                userDataDic["email"] = email
                
                User.currentUser.saveUserInformation(userInfo: userDataDic)
                
                // User is signed in
                self!.showHomeScreen()
            }
        } else {
            print(error)
            self.showAlert(titleString: "Error!", messageString: "Something went wrong. Try again.")
        }
    }
    
}
