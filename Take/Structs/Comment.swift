//
//  Comment.swift
//  Take
//
//  Created by Family on 5/16/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation

struct Comment: Codable {
    var id: String!
    var text: String!
    var date: Date!

    func toAnyObject() -> Any {
        return [
            "id": id,
            "text": text,
            "date": date.monthDayYear(style: "/")
        ]
    }

    init(anyObject: [String: Any]) {
        let tempDate = anyObject["date"] as! String
        self.id = anyObject["id"] as! String
        self.text = anyObject["text"] as! String
        self.date = Date(fromString: tempDate, style: "/")
    }

    init(id: String, text: String, date: Date) {
        self.id = id
        self.text = text
        self.date = date
    }
}
