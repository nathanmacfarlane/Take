//
//  MPFunctions.swift
//  Take
//
//  Created by Family on 5/29/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import CoreLocation

/* returns array of routes of the user's favorite routes
 /  NOTE: array will be empty if user has no favorite routes
 /
 / To call this function: routesByIds(routeIDs: myIDs, completion: { (favorites) -> () in })
 */
func routesByArea(coord: CLLocationCoordinate2D, completion: @escaping (_ routes: [Route])->()) {
    let maxDistance = 50
    let theURL = URL(string: "https://www.mountainproject.com/data/get-routes-for-lat-lon?lat=\(coord.latitude)&lon=\(coord.longitude)&maxDistance=\(maxDistance)&key=200051285-43fc64b054234a9de6b9f73089e26d50")
    URLSession.shared.dataTask(with: theURL!) { (data, response, error) -> Void in
        // Check if data was received successfully
        if error == nil && data != nil {
            if let newData = data {
                do {
                    let decoder = JSONDecoder()
                    let theRouteStuff = try decoder.decode(RouteService.self, from: newData)
                    completion(theRouteStuff.routes)
                    
                } catch {
                    print("Exception on Decode: \(error)")
                }
            }
        } else {
            completion([])
        }
        }.resume()
}

