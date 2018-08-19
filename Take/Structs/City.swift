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

    init(snapshot: DataSnapshot) {
        let snapval = snapshot.value            as! [String: AnyObject]
        self.state = snapval["state"]          as! String
        self.id = snapval["id"]             as! Int
        self.name = snapval["name"]           as! String
        self.keyword = snapval["keyword"]        as? String
        self.coverPhoto = snapval["coverPhoto"]     as? String
    }

    func getCoverPhoto(completion: @escaping (_ coverImage: UIImage) -> Void) {
        if let photoURL = self.coverPhoto {
            URLSession.shared.dataTask(with: URL(string: photoURL)!) { data, _, _ in
                completion(UIImage(data: data!)!)
                }.resume()
        }
    }
}
