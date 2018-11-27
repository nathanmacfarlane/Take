//
//  User.swift
//  Take
//
//  Created by Family on 5/23/18.
//  Copyright © 2018 N8. All rights reserved.
//

import CodableFirebase
import Foundation
import UIKit

class User: Codable {
    var name: String
    var username: String
    var id: String
    var profilePhotoUrl: String?

    func getProfilePhoto(completion: @escaping (_ profileImage: UIImage) -> Void) {
        guard let profilePhotoUrl = profilePhotoUrl, let actualUrl = URL(string: profilePhotoUrl) else { return }
        URLSession.shared.dataTask(with: actualUrl) { data, _, _ in
            guard let theData = data, let theImage = UIImage(data: theData) else { return }
            completion(theImage)
        }
        .resume()
    }

    init(name: String, username: String) {
        self.name = name
        self.id = UUID().uuidString
        self.username = username
    }
}
