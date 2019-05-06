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
    
    func addTitle(title: String) {
        let titleLable = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        titleLable.textColor = .white
        titleLable.text = title
        titleLable.textAlignment = .center
        self.navigationItem.titleView = titleLable
    }
    
    func addTitleListing(title: String) {
        let titleLable = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        titleLable.textColor = .white
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
}
