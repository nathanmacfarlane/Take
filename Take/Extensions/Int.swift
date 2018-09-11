//
//  Int.swift
//  Take
//
//  Created by Nathan Macfarlane on 9/10/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation

extension Int {
    init(top: Int, bottom: Int) {
        self.init(Int(arc4random_uniform(UInt32(top))) + bottom)
    }
}
