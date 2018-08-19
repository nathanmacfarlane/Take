//
//  Area.swift
//  Take
//
//  Created by Nathan Macfarlane on 6/7/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import CoreLocation
import FirebaseDatabase
import GeoFire

class Area {
    var id          : String
    var name        : String
    var location    : CLLocation
    var radius      : Double
    
    // MARK: - Inits
    init(name: String, location: CLLocation, radius: Double) {
        self.id         = UUID().uuidString
        self.name       = name
        self.location   = location
        self.radius     = radius
    }
    init?(snapshot: DataSnapshot) {
        id          = snapshot.key
        guard let snapval = snapshot.value as? [String : AnyObject] else {
            return nil
        }
        name        = snapval["name"]           as! String
        location    = CLLocation(latitude: (snapval["location"] as! [Double])[0], longitude: (snapval["location"] as! [Double])[1])
        radius      = snapval["radius"]         as! Double
    }
    
    
    // MARK: - Firebase
    func saveAreaToFB() {
        let routesRoot = Database.database().reference(withPath: "areas")
        routesRoot.updateChildValues([ self.id : self.toAnyObject() ])
    }
    
    // MARK: - GeoFire
    func saveAreaToGF() {
        let DBRef = Database.database().reference().child("GeoFireAreaKeys")
        let geoFire = GeoFire(firebaseRef: DBRef)
        geoFire.setLocation(self.location, forKey: self.id!)
    }
    
    // MARK: - Functions
    func toAnyObject() -> Any {
        return [
            "id"        : id,
            "name"      : name,
            "location"  : [location.coordinate.latitude, location.coordinate.longitude],
            "radius"    : radius
        ]
    }
    
}
