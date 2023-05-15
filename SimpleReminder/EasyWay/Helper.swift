//
//  Helper.swift
//  KitU
//
//  Created by Otto Dzhandzhuliya on 16.01.2023.
//

import Foundation
import UIKit

class Helper {
    static func tamicOff(views: [UIView]) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    } 
}
