//
//  Area.swift
//  Take
//
//  Created by Nathan Macfarlane on 6/7/18.
//  Copyright © 2018 N8. All rights reserved.
//

import CoreLocation
import FirebaseDatabase
import Foundation
import GeoFire

class Area {
    var id: String
    var name: String
    var location: CLLocation
    var radius: Double

    // MARK: - Inits
    init(name: String, location: CLLocation, radius: Double) {
        self.id = UUID().uuidString
        self.name = name
        self.location = location
        self.radius = radius
    }
    init?(snapshot: DataSnapshot) {
        id = snapshot.key
        guard let snapval = snapshot.value as? [String: AnyObject] else {
            return nil
        }

        if let tempName = snapval["name"] as? String {
            self.name = tempName
        }
        if let tempLocation = (snapval["location"] as? [Double]) {
            self.location = CLLocation(latitude: tempLocation[0], longitude: tempLocation[1])
        }
        if let tempRadius = snapval["radius"] as? Double {
            self.radius = tempRadius
        }

    }

    // MARK: - Firebase
    func saveAreaToFB() {
        let routesRoot = Database.database().reference(withPath: "areas")
        routesRoot.updateChildValues([ self.id: self.toAnyObject() ])
    }

    // MARK: - GeoFire
    func saveAreaToGF() {
        let DBRef = Database.database().reference().child("GeoFireAreaKeys")
        let geoFire = GeoFire(firebaseRef: DBRef)
        geoFire.setLocation(self.location, forKey: self.id)
    }

    // MARK: - Functions
    func toAnyObject() -> Any {
        return [
            "id": id,
            "name": name,
            "location": [location.coordinate.latitude, location.coordinate.longitude],
            "radius": radius
        ]
    }

}
