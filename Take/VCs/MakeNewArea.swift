//
//  MakeNewArea.swift
//  Take
//
//  Created by Nathan Macfarlane on 6/7/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit
import MapKit

class MakeNewArea: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet var longPressMapView: UILongPressGestureRecognizer!
    
    // MARK: - Variables
    let locationManager = CLLocationManager()
    
    
    // MARK: - View load/unload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        let location = self.locationManager.location
        
        self.myMapView.centerMapOn(location!, withRadius: 3000)
        
    }
    
    // MARK: - gesture recognizer
    @IBAction func longPressRecognized(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let newArea = showCircle(coordinate: self.myMapView.centerCoordinate, radius: self.myMapView.visibleDistance()/4)
            addTitle(newArea: newArea)
        }
    }
    
    // MARK: - MapView
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay as! MKCircle)
        circleRenderer.fillColor = UIColor(red: 187/255, green: 119/255, blue: 131/255, alpha: 1.0)
        circleRenderer.alpha = 0.4
        return circleRenderer
    }
    func showCircle(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance) -> MKCircle {
        let circle = MKCircle(center: coordinate, radius: radius)
        self.myMapView.add(circle)
        return circle
    }
    
    // MARK: - Actionsheets
    func addTitle(newArea: MKCircle) {
        var myTextField = UITextField()
        let alertController = UIAlertController(title: nil, message: "New Area Name: ", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            self.myMapView.remove(newArea)
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            let area = Area(name: myTextField.text!, location: CLLocation(latitude: self.myMapView.centerCoordinate.latitude, longitude: self.myMapView.centerCoordinate.longitude), radius: self.myMapView.visibleDistance()/4)
            area.saveAreaToFB()
        }
        alertController.addTextField { (textField) in
            myTextField = textField
            myTextField.placeholder = "Area Name"
        }
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        self.present(alertController, animated: true)
    }
    
    // MARK: - Navigation
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
