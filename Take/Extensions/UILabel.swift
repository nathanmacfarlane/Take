//
//  UILabel.swift
//  Take
//
//  Created by Family on 5/27/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func addAbrevText(text: String) {
        var newText = text
        if newText.count > 3 {
            let arr = newText.split(separator: " ")
            newText = ""
            for c in arr {
                newText += "\(Array(c)[0])"
            }
        }
        self.text = newText
    }
}
