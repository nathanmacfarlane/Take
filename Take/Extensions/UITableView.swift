//
//  UITableView.swift
//  Take
//
//  Created by Nathan Macfarlane on 6/10/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func scrollToTop(completion: @escaping () -> Void) {
        self.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
}
