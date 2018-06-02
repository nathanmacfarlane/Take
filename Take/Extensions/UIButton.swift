//
//  UIButton.swift
//  Take
//
//  Created by Family on 5/17/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func roundButton(portion: CGFloat) {
        self.layer.cornerRadius = self.frame.height < self.frame.width ? self.frame.height/portion : self.frame.width/portion
        self.clipsToBounds = true
    }
    func addAbrevText(text : String) {
        var newText = text
        if newText.count > 3 {
            let arr = newText.split(separator: " ")
            newText = ""
            for c in arr {
                newText += "\(Array(c)[0])"
            }
        }
        self.setTitle(newText, for: .normal)
    }
}

