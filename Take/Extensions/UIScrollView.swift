//
//  UIScrollView.swift
//  Take
//
//  Created by Family on 5/26/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        if self.contentSize.width < self.bounds.size.width { return }
        let bottomOffset = CGPoint(x: self.contentSize.width - self.bounds.size.width, y: 0)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}
