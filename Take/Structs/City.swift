//
//  City.swift
//  Take
//
//  Created by Nathan Macfarlane on 8/8/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Firebase
import Foundation

struct City {
    var state: String
    var id: Int
    var name: String
    var keyword: String?
    private var coverPhoto: String?

    init?(snapshot: DataSnapshot) {
        guard let snapval = snapshot.value as? [String: AnyObject] else { return nil }
        guard let tempState = snapval["state"] as? String, let tempId = snapval["id"] as? Int else { return nil }
        guard let tempName = snapval["name"] as? String, let tempKeyword = snapval["keyword"] as? String, let tempCoverPhoto = snapval["coverPhoto"] as? String else { return nil }
        self.state = tempState
        self.id = tempId
        self.name = tempName
        self.keyword = tempKeyword
        self.coverPhoto = tempCoverPhoto
    }

    func getCoverPhoto(completion: @escaping (_ coverImage: UIImage) -> Void) {
        guard let photoURL = self.coverPhoto, let tempURL = URL(string: photoURL) else { return }
        URLSession.shared.dataTask(with: tempURL) { data, _, _ in
            guard let tempData = data, let tempImage = UIImage(data: tempData) else { return }
            completion(tempImage)
        }
        .resume()
    }
}
