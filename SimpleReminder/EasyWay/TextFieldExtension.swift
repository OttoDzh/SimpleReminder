//
//  TextFieldExtension.swift
//  KitU
//
//  Created by Otto Dzhandzhuliya on 16.01.2023.
//

import Foundation
import UIKit

extension UITextField {
    
    convenience init(placeholder:String) {
        self.init()
        self.placeholder = placeholder
        self.font = ODFonts.regulatTextFont
        self.borderStyle = .none
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 3))
        self.leftViewMode = .always
        self.backgroundColor = .white
    }
    
}

