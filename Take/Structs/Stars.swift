//
//  Stars.swift
//  Take
//
//  Created by Family on 5/16/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation

struct Stars {
    var average: Double
    var starVotes: Int
}

struct Star: Codable {
    var star: Double
    var id: String

    func toAnyObject() -> Any {
        return [
            "star": star,
            "id": id
        ]
    }

    init?(anyObject: [String: Any]) {
        guard let tempStar = anyObject["star"] as? Double, let tempId = anyObject["id"] as? String else { return nil }
        self.star = tempStar
        self.id = tempId
    }

    init(star: Double, id: String) {
        self.star = star
        self.id = id
    }
}
