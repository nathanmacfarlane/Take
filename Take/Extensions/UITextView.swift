//
//  UITextField.swift
//  Take
//
//  Created by Family on 5/17/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    func roundField(portion: CGFloat) {
        self.layer.cornerRadius = self.frame.height < self.frame.width ? self.frame.height / portion : self.frame.width / portion
        self.clipsToBounds = true
    }
}
