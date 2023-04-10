//
//  StackViewExtension.swift
//  KitU
//
//  Created by Otto Dzhandzhuliya on 16.01.2023.
//

import Foundation
import UIKit

extension UIStackView {
    
    convenience init(arrangedSubviews: [UIView],axis: NSLayoutConstraint.Axis,spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
    }
    
    
}
