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

func searchFBRouteCities(byProperty property: String, withValue value: Any, completion: @escaping (_ routeLocals: [City])->()) {
    var routeCities: [City] = []
    let routeCitiesRoot = Database.database().reference(withPath: "cities")
    let namequery = routeCitiesRoot.queryOrdered(byChild: property).queryEqual(toValue: value)
    namequery.observeSingleEvent(of: .value, with: { (snapshot) in
        for item in snapshot.children {
            let newCity = City(snapshot: item as! DataSnapshot)
            routeCities.append(newCity)
        }
        completion(routeCities)
    })
}

func searchFBRouteWalls(byProperty property: String, withValue value: Any, completion: @escaping (_ routeLocals: [Wall])->()) {
    var routeWalls: [Wall] = []
    let routeWallsRoute = Database.database().reference(withPath: "walls")
    let namequery = routeWallsRoute.queryOrdered(byChild: property).queryEqual(toValue: value)
    namequery.observeSingleEvent(of: .value, with: { (snapshot) in
        for item in snapshot.children {
            let newWall = Wall(snapshot: item as! DataSnapshot)
            routeWalls.append(newWall)
        }
        completion(routeWalls)
    })
}

func searchFBRouteAreas(byProperty property: String, withValue value: Any, completion: @escaping (_ routeLocals: [RouteArea])->()) {
    var routeAreas: [RouteArea] = []
    let routeAreasRoot = Database.database().reference(withPath: "areas")
    let namequery = routeAreasRoot.queryOrdered(byChild: property).queryEqual(toValue: value)
    namequery.observeSingleEvent(of: .value, with: { (snapshot) in
        for item in snapshot.children {
            let newArea = RouteArea(snapshot: item as! DataSnapshot)
            routeAreas.append(newArea)
        }
        completion(routeAreas)
    })
}

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

func searchFBArea(with key: String, completion: @escaping (_ area: Area) -> ()) {
    let routesRoot = Database.database().reference(withPath: "areas/\(key)")
    routesRoot.observeSingleEvent(of: .value, with: { (snapshot) in
        let newArea = Area(snapshot: snapshot)
//        for item in snapshot.children {
//            print("item: \(item)")
//        }
        completion(newArea)
    })
}
