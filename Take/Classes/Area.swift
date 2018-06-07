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

class Area {
    var id          : String!
    var name        : String!
    var location    : CLLocation!
    var radius      : Double!
    
    init(name: String, location: CLLocation, radius: Double) {
        self.id         = UUID().uuidString
        self.name       = name
        self.location   = location
        self.radius     = radius
    }
    
    
    // MARK: - Firebase
    func saveAreaToFB() {
        let routesRoot = Database.database().reference(withPath: "areas")
        routesRoot.updateChildValues([ self.id : self.toAnyObject() ])
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
