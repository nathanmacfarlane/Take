//
//  MapView.swift
//  Take
//
//  Created by Family on 5/29/18.
//  Copyright © 2018 N8. All rights reserved.
//

import FirebaseDatabase
import GeoFire
import MapKit
import UIKit

class MapView: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var mySegControl: UISegmentedControl!
    //    @IBOutlet weak var reloadAreaButton: UIButton!
    @IBOutlet var longPressMapView: UILongPressGestureRecognizer!
    @IBOutlet weak var viewAreaLabel: UILabel!
    @IBOutlet weak var targetImage: UIImageView!
    @IBOutlet weak var viewAreaSwitch: UISwitch!

    // MARK: - Variables
    let locationManager = CLLocationManager()
    var region: MKCoordinateRegion!
    var mapType: MKMapType!

    // MARK: - view load/unload
    override func viewDidLoad() {
        super.viewDidLoad()

        self.myMapView.showsUserLocation = false

        //        self.reloadAreaButton.isHidden = true

        viewAreaLabel.addBorder(color: viewAreaLabel.textColor, width: 1)
        viewAreaLabel.roundView(portion: 3)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

        let location = self.locationManager.location

        self.myMapView.centerMapOn(location!, withRadius: 3000)

        //        queryFromFirebase()
        //        queryFromGeoFire()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if self.viewAreaSwitch.isOn {
            queryFromFirebase()
            queryFromGeoFire()
        }
    }

    // MARK: - gesture recognizer
    @IBAction func longPressRecognized(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let areaOverlay = self.myMapView.addCircle(name: "", coordinate: self.myMapView.centerCoordinate, radius: self.myMapView.visibleDistance() / 4)
            addTitle(areaOverlay: areaOverlay)
        }
    }

    // MARK: - Actionsheets
    func addTitle(areaOverlay: AreaOverlay) {
        var myTextField = UITextField()
        let alertController = UIAlertController(title: nil, message: "New Area Name: ", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.myMapView.remove(areaOverlay)
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            let theLocation = CLLocation(latitude: self.myMapView.centerCoordinate.latitude, longitude: self.myMapView.centerCoordinate.longitude)
            let theRadius = self.myMapView.visibleDistance() / 4
            let area = Area(name: myTextField.text!, location: theLocation, radius: theRadius)
            areaOverlay.area = area
            //            getAreaFromGeoFire(for: "GeoFireAreaKeys", from: theLocation, with: theRadius, completion: { (locations) in
            //                print("done")
            //            })
            area.saveAreaToFB()
            area.saveAreaToGF()
        }
        alertController.addTextField { textField in
            myTextField = textField
            myTextField.placeholder = "Area Name"
        }
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        self.present(alertController, animated: true)
    }

    // MARK: - Toggle Area Switch
    @IBAction func toggleArea(_ sender: UISwitch) {
        //        self.targetImage.isHidden = !sender.isOn
        if !sender.isOn {
            self.myMapView.removeAllOverlays()
        } else {
            queryFromGeoFire()
        }
    }

    // MARK: - SegControl
    @IBAction func segChanged(_ sender: UISegmentedControl) {
        //self.targetImage.image = self.myMapView.mapType == .satellite ? UIImage(named: "NewAreaTarget.png") : UIImage(named: "NewAreaTargetWhite.png")
        self.queryFromFirebase()
        self.myMapView.mapType = MKMapType(rawValue: UInt(sender.selectedSegmentIndex))!
        self.mapType = MKMapType(rawValue: UInt(sender.selectedSegmentIndex))!
        if viewAreaSwitch.isOn {
            self.myMapView.removeAllOverlays()
            self.queryFromGeoFire()
        }
    }

    // MARK: - MapView
    @IBAction func goReloadArea(_ sender: UIButton) {
        //        queryFromFirebase()
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        queryFromFirebase()
        if self.viewAreaSwitch.isOn {
            queryFromGeoFire()
        }
    }
    func queryFromGeoFire() {
        self.myMapView.removeAllOverlays()
        getIdsFromGeoFire(for: "GeoFireAreaKeys", from: self.myMapView.region) { areaIds in
            for id in areaIds {
                searchFBArea(with: id.key, completion: { area in
                    _ = self.myMapView.addCircle(name: area.name, coordinate: area.location.coordinate, radius: area.radius)
                })

            }
        }
    }
    func queryFromFirebase() {
        //        self.myMapView.removeAllAnnotations()
        getIdsFromGeoFire(for: "GeoFireRouteKeys", from: self.myMapView.region) { routeIDs in
            var allRoutes: [Route] = []
            var count = 0
            for id in routeIDs {
                searchFBRoute(byProperty: "id", withValue: Int(id.key)!, completion: { fbRoutes in
                    allRoutes.append(contentsOf: fbRoutes)
                    for route in fbRoutes {
                        if !allRoutes.contains(route) {
                            allRoutes.append(route)
                        }
                    }
                    count += 1
                    if count == routeIDs.count {
                        routesByArea(coord: self.myMapView.centerCoordinate, maxDistance: 1, maxResults: 500, completion: { mpRoutes in
                            for route in mpRoutes {
                                if !allRoutes.contains(route) {
                                    allRoutes.append(route)
                                }
                            }
                            DispatchQueue.main.async {
                                self.myMapView.removeAllAnnotations()
                                self.myMapView.addAnnotations(allRoutes)
                            }
                        })
                    }
                })
            }
        }
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let selectedRoute = view.annotation as? Route {
            self.performSegue(withIdentifier: "goToDetail", sender: selectedRoute)
        }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay as! MKCircle)
        let whiteColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.4)
        let peachColor = UIColor(red: 187 / 255, green: 119 / 255, blue: 131 / 255, alpha: 0.3)
        circleRenderer.fillColor = mapType == .satellite ? whiteColor : peachColor
        return circleRenderer
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is Route {
            let annoView = MKAnnotationView()
            annoView.annotation = annotation
            annoView.canShowCallout = true
            annoView.rightCalloutAccessoryView = UIButton(type: .infoDark)
            let s = (annotation as! Route).star?.roundToInt() ?? 0
            if s <= 2 {
                annoView.image = UIImage(named: "Anno-Circle-Pink.png")
            } else if s < 4 {
                annoView.image = UIImage(named: "Anno-Circle-Blue.png")
            } else {
                annoView.image = UIImage(named: "Anno-Circle-Red.png")
            }
            return annoView
        }
        return nil
    }
    func tapOnOverlay(with tapGesture: UITapGestureRecognizer, on mapView: MKMapView) -> AreaOverlay? {
        let tappedMapView = tapGesture.view
        let tappedPoint = tapGesture.location(in: tappedMapView)
        let tappedCoordinates = mapView.convert(tappedPoint, toCoordinateFrom: tappedMapView)
        let point: MKMapPoint = MKMapPointForCoordinate(tappedCoordinates)
        let overlays = mapView.overlays.filter { o in
            o is AreaOverlay
        }
        for overlay in overlays {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            let datPoint = circleRenderer.point(for: point)
            circleRenderer.invalidatePath()
            if circleRenderer.path.contains(datPoint) {
                return overlay as? AreaOverlay
            }
        }
        return nil
    }

    // MARK: - gesture
    @IBAction func tappedOnMap(_ sender: UITapGestureRecognizer) {
        //        if let tappedCircle = self.tapOnOverlay(with: sender, on: self.myMapView) {
        ////            self.performSegue(withIdentifier: "goToArea", sender: tappedCircle.area!.name!)
        //        }
    }

    // MARK: - Navigation
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            let dc: RouteDetail = segue.destination as! RouteDetail
            dc.theRoute = sender as! Route
            dc.mainImg = UIImage(named: "bg.jpg")
        } else if segue.identifier == "goToArea" {
            //            let dc: AreaView = segue.destination as! AreaView
            //            dc.areaName = sender as! String
        }
    }

}
