//
//  LabelExtension.swift
//  KitU
//
//  Created by Otto Dzhandzhuliya on 16.01.2023.
//

import Foundation
import UIKit

extension UILabel {
    
    convenience init(text:String,font:UIFont?) {
        self.init()
        self.text = text
        self.font = font
    }
    
}
