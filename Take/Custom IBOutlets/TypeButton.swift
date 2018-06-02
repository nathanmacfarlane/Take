//
//  CustomIBOutlets.swift
//  Take
//
//  Created by Family on 5/4/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import UIKit

class TypeButton: UIButton {
    var isType = false
    var selectedColor: UIColor      = UIColor(red: 41/255, green: 60/255, blue: 72/255, alpha: 1.0)
    var deselectedColor: UIColor    = UIColor(red: 175/255, green: 175/255, blue: 175/255, alpha: 1.0)
    
    func roundButton() {
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
    }
    func setType(isType: Bool) {
        self.isType = isType
        self.layer.backgroundColor = self.isType == true ?  selectedColor.cgColor :  deselectedColor.cgColor
    }
    func addBorder(width: CGFloat) {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = width
    }
    
}
