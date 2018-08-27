//
//  UITextField.swift
//  Take
//
//  Created by Nathan Macfarlane on 8/26/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func underlined() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
