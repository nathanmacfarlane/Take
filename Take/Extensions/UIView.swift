//
//  UIView.swift
//  Take
//
//  Created by Family on 5/17/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func roundView(portion: CGFloat) {
        self.layer.cornerRadius = self.frame.height < self.frame.width ? self.frame.height/portion : self.frame.width/portion
        self.clipsToBounds = true
    }
    func addBorder(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
