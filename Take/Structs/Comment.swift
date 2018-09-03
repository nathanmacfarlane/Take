//
//  Comment.swift
//  Take
//
//  Created by Family on 5/16/18.
//  Copyright © 2018 N8. All rights reserved.
//

import FirebaseFirestore
import Foundation

struct Comment: Codable {
    var id: String
    var userId: String
    var text: String
    var dateString: String
    var date: Date {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: self.dateString) ?? Date()
    }

    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case text
        case dateString
    }

    func delete(route: Route) {
        guard let index = route.commentIds.index(of: self.id) else { return }
        route.commentIds.remove(at: index)
        route.fsSave()
        Firestore.firestore().collection("comments").document(self.id).delete()
    }
}
