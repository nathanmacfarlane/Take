//
//  MapView.swift
//  Take
//
//  Created by Family on 5/29/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit
import MapKit
import GeoFire
import FirebaseDatabase

class MapView: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var mySegControl: UISegmentedControl!
    @IBOutlet weak var reloadAreaButton: UIButton!
    
    // MARK: - Variables
    let locationManager = CLLocationManager()
    
    // MARK: - Variables
    
    
    // MARK: - view load/unload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        let location = self.locationManager.location
        
        self.myMapView.centerMapOn(location!, withRadius: 3000)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        queryFromFirebase()
    }
    
    // MARK: - SegControl
    @IBAction func segChanged(_ sender: UISegmentedControl) {
        self.myMapView.mapType = MKMapType(rawValue: UInt(sender.selectedSegmentIndex))!
    }
    
    // MARK: - MapView
    @IBAction func goReloadArea(_ sender: UIButton) {
        queryFromFirebase()
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        queryFromFirebase()
    }
    func queryFromFirebase() {
        self.myMapView.removeAllAnnotations()
        getRouteIdsFromGeoFire(from: self.myMapView.region) { (routeIDs) in
            for id in routeIDs {
                searchFBRoute(byProperty: "id", withValue: id.key, completion: { (fbRoutes) in
                    routesByArea(coord: self.myMapView.centerCoordinate, maxDistance: 1, maxResults: 500, completion: { (mpRoutes) in
                        DispatchQueue.main.async {
                            var allRoutes = fbRoutes
                            for route in mpRoutes {
                                if !allRoutes.contains(route) {
                                    allRoutes.append(route)
                                }
                            }
                            self.myMapView.addAnnotations(allRoutes)
                        }
                    })
                })
            }
        }
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let selectedRoute = view.annotation as? Route {
            self.performSegue(withIdentifier: "goToDetail", sender: selectedRoute)
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is Route {
            let annoView = MKPinAnnotationView()
            annoView.pinTintColor = .red
            annoView.annotation = annotation
            annoView.canShowCallout = true
            annoView.animatesDrop = false
            annoView.rightCalloutAccessoryView = UIButton(type: .infoDark)
            return annoView
        }
        return nil
    }
    
    //Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            let dc:RouteDetail = segue.destination as! RouteDetail
            dc.theRoute = sender as! Route
            dc.mainImg  = UIImage(named: "bg.jpg")
        }
    }

}
