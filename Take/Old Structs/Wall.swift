//
//  Wall.swift
//  Take
//
//  Created by Nathan Macfarlane on 8/7/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Firebase
import Foundation

struct Wall {
    var area: Int
    var id: Int
    var name: String
    private var coverPhoto: String?

    init?(snapshot: DataSnapshot) {
        guard let snapval = snapshot.value as? [String: AnyObject] else { return nil }
        guard let tempArea = snapval["area"] as? Int, let tempId = snapval["id"] as? Int, let tempName = snapval["name"] as? String else { return nil }

        self.area = tempArea
        self.id = tempId
        self.name = tempName
        self.coverPhoto = snapval["coverPhoto"] as? String
    }

    func getCoverPhoto(completion: @escaping (_ coverImage: UIImage) -> Void) {
        guard let photoURL = self.coverPhoto, let actualURL = URL(string: photoURL) else { return }
        URLSession.shared.dataTask(with: actualURL) { data, _, _ in
            guard let tempData = data, let coverPhoto = UIImage(data: tempData) else { return }
            completion(coverPhoto)
        }
        .resume()
    }

}
