//
//  RouteImage.swift
//  Take
//
//  Created by Nathan Macfarlane on 8/24/18.
//  Copyright © 2018 N8. All rights reserved.
//

import CodableFirebase
import Firebase
import Foundation
import UIKit

struct RouteImage: Codable {
    var imageId: String
    var smallUrl: String
    var largeUrl: String?
    var description: String
    var userId: String
    var date: Date
    var stars: [Star]

    init?(largeUrl: String, smallUrl: String, description: String, imageId: String) {
        self.smallUrl = smallUrl
        self.largeUrl = largeUrl
        self.description = description
        guard let currentUser = Auth.auth().currentUser?.uid else { return nil }
        self.userId = currentUser
        self.imageId = imageId
        self.date = Date()
        self.stars = []
    }

    init?(description: String, imageId: String) {
        self.smallUrl = ""
        self.largeUrl = ""
        self.description = description
        guard let currentUser = Auth.auth().currentUser?.uid else { return nil }
        self.userId = currentUser
        self.imageId = imageId
        self.date = Date()
        self.stars = []
    }

    func getModel() -> Any {
        return try! FirebaseEncoder().encode(self)
    }
}
