//
//  DetailMapView.swift
//  Take
//
//  Created by Nathan Macfarlane on 9/9/18.
//  Copyright © 2018 N8. All rights reserved.
//

import MapKit
import UIKit

class DetailMapView: UIViewController, MKMapViewDelegate {

    // MARK: - IBOutlets
    @IBOutlet private weak var myMapView: MKMapView!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var routeNameLabel: UILabel!
    @IBOutlet private weak var saveButton: UIButton!

    // MARK: - Variables
    var theRoute: Route!
    var editMode: Bool = false

    // MARK: - View Load/Unload
    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.isHidden = !editMode
        routeNameLabel.text = theRoute.name

        if !editMode {
            self.cancelButton.setTitle("Back", for: .normal)
        }

        if let routeLocation = theRoute.location {
            myMapView.centerMapOn(routeLocation)
            myMapView.addPin(from: theRoute)
        }

    }

    // MARK: - MapView
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if editMode {
            self.myMapView.removeAllAnnotations()
            let annotation = MKPointAnnotation()
            annotation.coordinate = mapView.centerCoordinate
            annotation.title = theRoute.name
            self.myMapView.addAnnotation(annotation)
        }
    }

    // MARK: - Navigation
    @IBAction private func hitCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction private func hitSave(_ sender: Any) {
        self.theRoute.latitude = self.myMapView.centerCoordinate.latitude
        self.theRoute.longitude = self.myMapView.centerCoordinate.longitude
        self.dismiss(animated: true, completion: nil)
    }
}
