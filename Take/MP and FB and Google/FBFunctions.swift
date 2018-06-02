//
//  FBFunctions.swift
//  Take
//
//  Created by Family on 6/1/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import FirebaseDatabase

func searchFBRoute(byProperty property: String, withValue value: String, completion: @escaping (_ routes: [Route])->()) {
    var routeResults: [Route] = []
    let routesRoot = Database.database().reference(withPath: "routes")
    let namequery = routesRoot.queryOrdered(byChild: property).queryEqual(toValue: value)
    namequery.observeSingleEvent(of: .value, with: { (snapshot) in
        for item in snapshot.children {
            routeResults.append(Route(snapshot: item as! DataSnapshot))
        }
        completion(routeResults)
    })
}
