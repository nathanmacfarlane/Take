//
//  Area.swift
//  Take
//
//  Created by Nathan Macfarlane on 6/7/18.
//  Copyright © 2018 N8. All rights reserved.
//

import CodableFirebase
import CoreLocation
import FirebaseDatabase
import Foundation
import GeoFire

class Area: Codable {
    var id: String
    var name: String
    var latitude: Double
    var longitude: Double
    var radius: Double
    var coverPhotoUrl: String?
    var description: String
    var city: Int?
    var keyword: String?

    var location: CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case radius
        case latitude
        case longitude
        case coverPhotoUrl
        case description
        case city
        case keyword
    }

    // MARK: - Inits
    init(name: String, radius: Double, latitude: Double, longitude: Double) {
        self.id = UUID().uuidString
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.description = ""
    }

    // MARK: - GeoFire
//    func saveAreaToGF() {
//        let DBRef = Database.database().reference().child("GeoFireAreaKeys")
//        let geoFire = GeoFire(firebaseRef: DBRef)
//        geoFire.setLocation(self.location, forKey: self.id)
//    }

    // MARK: - Functions
    func getCoverPhoto(completion: @escaping (_ coverImage: UIImage?) -> Void) {
        guard let photoURL = self.coverPhotoUrl, let actualURL = URL(string: photoURL) else { return }
        URLSession.shared.dataTask(with: actualURL) { data, _, _ in
            guard let theData = data, let coverPhoto = UIImage(data: theData) else { return }
            completion(coverPhoto)
        }
        .resume()
    }

}
