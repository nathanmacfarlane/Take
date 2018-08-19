//
//  Area.swift
//  Take
//
//  Created by Nathan Macfarlane on 8/7/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import Firebase

struct RouteArea {
    var id: Int
    var city: Int
    var keyword: String?
    var name: String
    private var coverPhoto: String?
    var description : String?
    
    init(snapshot: DataSnapshot) {
        let snapval         = snapshot.value            as! [String : AnyObject]
        self.city           = snapval["city"]           as! Int
        self.id             = snapval["id"]             as! Int
        self.name           = snapval["name"]           as! String
        self.keyword        = snapval["keyword"]        as? String
        self.coverPhoto     = snapval["coverPhoto"]     as? String
        self.description    = snapval["description"]    as? String
    }
    
    func getCoverPhoto(completion: @escaping (_ coverImage: UIImage) -> Void) {
        if let photoURL = self.coverPhoto {
            URLSession.shared.dataTask(with: URL(string: photoURL)!) { data, response, error in
                completion(UIImage(data: data!)!)
            }.resume()
        }
    }
    
}
