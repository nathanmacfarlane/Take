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
    var star: Double!
    var id: String!

    func toAnyObject() -> Any {
        return [
            "star": star,
            "id": id
        ]
    }

    init(anyObject: [String: Any]) {
        self.star = anyObject["star"] as! Double
        self.id = anyObject["id"] as! String
    }

    init(star: Double, id: String) {
        self.star = star
        self.id = id
    }
}
