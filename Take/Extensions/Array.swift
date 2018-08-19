//
//  Array.swift
//  Take
//
//  Created by Nathan Macfarlane on 6/20/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
