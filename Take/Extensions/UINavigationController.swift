//
//  UINavigationBar.swift
//  Take
//
//  Created by Nathan Macfarlane on 9/9/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    func makeTransparent() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
    }
}
