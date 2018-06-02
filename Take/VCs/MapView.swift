//
//  MapView.swift
//  Take
//
//  Created by Family on 5/29/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit
import MapKit

class MapView: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var myMapView: MKMapView!
    
    // MARK: - Variables
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        let location = self.locationManager.location
        
        centerMapOnLocation(location: location!)
        
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        myMapView.setRegion(coordinateRegion, animated: true)
    }

}
