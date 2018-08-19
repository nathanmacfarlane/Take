//
//  Google.swift
//  Take
//
//  Created by Family on 6/1/18.
//  Copyright © 2018 N8. All rights reserved.
//

import CoreLocation
import Foundation
import MapKit

func forwardGeocoding(address: String, completion: @escaping (_ coordinate: CLLocationCoordinate2D) -> Void) {
    CLGeocoder().geocodeAddressString(address) { placemarks, error in
        if error != nil {
            print("error: \(String(describing: error))")
            return
        }
        if let coordinate = placemarks?[0].location?.coordinate {
            completion(coordinate)
        }
    }
}
