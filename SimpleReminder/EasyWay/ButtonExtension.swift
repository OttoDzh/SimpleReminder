//
//  ButtonExtension.swift
//  KitU
//
//  Created by Otto Dzhandzhuliya on 16.01.2023.
//

import Foundation
import UIKit

extension UIButton {
    
    convenience init(title: String,
                     bgColor: UIColor,
                     textColor: UIColor,
                     font: UIFont?,
                     cornerRadius: CGFloat) {
        self.init(type: .system)
        
        self.setTitle(title,for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
        self.backgroundColor = bgColor
        
    }
    
}


