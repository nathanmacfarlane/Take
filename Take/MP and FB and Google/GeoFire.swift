//
//  GeoFire.swift
//  Take
//
//  Created by Nathan Macfarlane on 6/6/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import FirebaseDatabase
import GeoFire
import MapKit

func getRouteIdsFromGeoFire(from region: MKCoordinateRegion, completion: @escaping (_ routeIDs: [Int : CLLocation])->()) {
    let DBRef = Database.database().reference()
    let geofire = GeoFire(firebaseRef: DBRef.child("GeoFireRouteKeys"))
    var routeIDs : [Int : CLLocation] = [:]
    
    let regionQuery = geofire.query(with: region)
    regionQuery.observe(.keyEntered) { (key, location) in
        routeIDs[Int(key)!] = location
//        print("Key '\(key)' moved within search area and is at location '\(location)'")
    }
    regionQuery.observeReady {
        completion(routeIDs)
    }
}

//let DBRef = Database.database().reference()
//let geoFire = GeoFire(firebaseRef: DBRef)
//
//let center = CLLocation(latitude: 37.7832889, longitude: -122.4056973)
//// Query locations at [37.7832889, -122.4056973] with a radius of 600 meters
//var circleQuery = geoFire.query(at: center, withRadius: 0.6)
//circleQuery.observe(.keyEntered, with: { (key: String?, location: CLLocation?) in
//    
//    //            print("Key '\(key!)' entered the search are and is at location '\(location!)'")
//    // Load the user for the key
//    let userRef = DBRef.child(key!)
//    userRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
//        //                let userDict = snapshot.value as? [String : AnyObject] ?? [:]
//        print("snapshot: \(snapshot)")
//    })
//})
