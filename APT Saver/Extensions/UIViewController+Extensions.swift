//
//  UIViewController+Extensions.swift
//  APT Saver
//
//  Created by Jin Joo Lee on 5/6/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(titleString title:String = "", messageString message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
        })
        alertController.addAction(action)
        self.present(alertController, animated:true, completion:nil)
    }
    
    func addTitle(title: String) {
        let titleLable = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        titleLable.textColor = .black
        titleLable.text = title
        titleLable.textAlignment = .center
        self.navigationItem.titleView = titleLable
    }
    
    //Changing color for the top bar
    func addTitleListing(title: String) {
        let titleLable = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        titleLable.textColor = .black
        titleLable.text = title
        titleLable.textAlignment = .center
        self.navigationItem.titleView = titleLable
    }
    
    func addPlusButton(withAction action: Selector) {
        let addButton = UIButton(type: .custom)
        addButton.addTarget(self, action: action, for: .touchUpInside)
        addButton.setImage(UIImage(named: "addlink_button-1"), for: .normal)
        addButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        let addBarButton = UIBarButtonItem(customView: addButton)
        
        self.navigationItem.rightBarButtonItem = addBarButton
    }
    
//    func backButton(withAction action: Selector) {
//        let backButton = UIButton(type: .custom)
//        backButton.addTarget(self, action: action, for: .touchUpInside)
//        backButton.setImage(UIImage(named: "back_button_left"), for: .normal)
//        backButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
//
//        let backLinkButton = UIBarButtonItem(customView: backButton)
//        self.navigationItem.rightBarButtonItem = backLinkButton
//    }
}
