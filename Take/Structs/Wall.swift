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

    init(snapshot: DataSnapshot) {
        let snapval = snapshot.value            as! [String: AnyObject]
        self.area = snapval["area"]           as! Int
        self.id = snapval["id"]             as! Int
        self.name = snapval["name"]           as! String
        self.coverPhoto = snapval["coverPhoto"] as? String
    }

    func getCoverPhoto(completion: @escaping (_ coverImage: UIImage) -> Void) {
        if let photoURL = self.coverPhoto {
            URLSession.shared.dataTask(with: URL(string: photoURL)!) { data, _, _ in
                completion(UIImage(data: data!)!)
                }.resume()
        }
    }

}
