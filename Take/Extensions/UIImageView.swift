//
//  UIImageView.swift
//  Take
//
//  Created by Family on 5/17/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func roundImage(portion: CGFloat) {
        self.layer.cornerRadius = self.frame.height < self.frame.width ? self.frame.height / portion : self.frame.width / portion
        self.clipsToBounds = true
    }
    //    func addBorder(color: UIColor, width: CGFloat) {
    //        self.layer.borderColor = color.cgColor
    //        self.layer.borderWidth = width
    //    }
    func addTextOver(color: UIColor, text: String) {
        var newText = text
        if newText.count > 3 {
            let arr = newText.split(separator: " ")
            newText = ""
            for charac in arr {
                newText += "\(Array(charac)[0])"
            }
        }
        let label = UILabel(frame: self.frame)
        label.frame.origin = self.frame.origin
        label.textAlignment = .center
        label.text = newText
        label.font = UIFont(name: "Avenir", size: 15)
        label.backgroundColor = .black
        label.textColor = color
        label.frame = self.frame
        self.addSubview(label)
    }
}
