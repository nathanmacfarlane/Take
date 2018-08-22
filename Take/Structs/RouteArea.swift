//
//  Area.swift
//  Take
//
//  Created by Nathan Macfarlane on 8/7/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Firebase
import Foundation

struct RouteArea {
    var id: Int
    var city: Int
    var keyword: String?
    var name: String
    private var coverPhoto: String?
    var description: String?

    init?(snapshot: DataSnapshot) {
        guard let snapval = snapshot.value as? [String: AnyObject] else { return nil }
        guard let tempCity = snapval["city"] as? Int, let tempId = snapval["id"] as? Int, let tempName = snapval["name"] as? String else { return nil }
        guard let tempKeyword = snapval["keyword"] as? String, let tempCoverPhoto = snapval["coverPhoto"] as? String, let tempDesc = snapval["description"] as? String else { return nil }
        self.city = tempCity
        self.id = tempId
        self.name = tempName
        self.keyword = tempKeyword
        self.coverPhoto = tempCoverPhoto
        self.description = tempDesc
    }

    init() {
        self.id = -1
        self.city = -1
        self.name = ""
    }

    func getCoverPhoto(completion: @escaping (_ coverImage: UIImage) -> Void) {
        guard let photoURL = self.coverPhoto, let actualURL = URL(string: photoURL) else { return }
        URLSession.shared.dataTask(with: actualURL) { data, _, _ in
            guard let theData = data, let coverPhoto = UIImage(data: theData) else { return }
            completion(coverPhoto)
        }
        .resume()
    }

}
