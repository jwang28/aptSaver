//
//  Helper.swift
//  APT Saver
//
//  Created by Jennifer Wang on 10/05/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import Foundation

func convertDateToString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
    let dateString = formatter.string(from: date)
    return dateString
}
