//
//  FBFunctions.swift
//  Take
//
//  Created by Family on 6/1/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import FirebaseDatabase
import CoreLocation

func searchFBRoute(byProperty property: String, withValue value: Any, completion: @escaping (_ routes: [Route])->()) {
    var routeResults: [Route] = []
    let routesRoot = Database.database().reference(withPath: "routes")
    let namequery = routesRoot.queryOrdered(byChild: property).queryEqual(toValue: value)
    namequery.observeSingleEvent(of: .value, with: { (snapshot) in
        for item in snapshot.children {
            let newRoute = Route(snapshot: item as! DataSnapshot)
            routeResults.append(newRoute)
        }
        completion(routeResults)
    })
}

func searchFBRoute(inArea path: String, completion: @escaping (_ routeIDs: [Int]) -> ()) {
    var routeResults : [Int] = []
    let routesRoot = Database.database().reference(withPath: "areas\(path)")
    routesRoot.observeSingleEvent(of: .value, with: { (snapshot) in
        for item in snapshot.children {
            if let myRoute = Int((item as! DataSnapshot).key) {
                routeResults.append(myRoute)
            }
        }
        completion(routeResults)
    })
}
