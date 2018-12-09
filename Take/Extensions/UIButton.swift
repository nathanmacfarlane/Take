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

    func set(image: UIImage, with color: UIColor) {
        let tintedImage = image.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: .normal)
        self.tintColor = color
    }

}
