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
    var isType: Bool = false
    let selectedColor: UIColor = UIColor(red: 41 / 255, green: 60 / 255, blue: 72 / 255, alpha: 1.0)
    let deselectedColor: UIColor = UIColor(red: 175 / 255, green: 175 / 255, blue: 175 / 255, alpha: 1.0)

    func setType(isType: Bool) {
        self.isType = isType
        self.layer.backgroundColor = self.isType == true ?  selectedColor.cgColor :  deselectedColor.cgColor
    }
    func addBorder(width: CGFloat) {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = width
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
    }

}
