//
//  Comment.swift
//  Take
//
//  Created by Family on 5/16/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation

struct Comment: Codable {
    var id: String
    var text: String
    var date: Date

    func toAnyObject() -> Any {
        return [
            "id": id,
            "text": text,
            "date": date.monthDayYear(style: "/")
        ]
    }

    init?(anyObject: [String: Any]) {
        guard let tempDateString = anyObject["date"] as? String else { return nil }
        guard let tempId = anyObject["id"] as? String else { return nil }
        guard let tempText = anyObject["text"] as? String else { return nil }
        guard let tempDate = Date(fromString: tempDateString, style: "/") else { return nil }
        self.id = tempId
        self.text = tempText
        self.date = tempDate
    }

    init(id: String, text: String, date: Date) {
        self.id = id
        self.text = text
        self.date = date
    }
}
