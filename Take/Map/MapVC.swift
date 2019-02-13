import Foundation
import MapKit
import UIKit

class MapVC: UIViewController {

    var mapView: MKMapView!
    var initialRoutes: [Route] = []
    var animateMap: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        for route in initialRoutes {
            let routeMarker = MKPointAnnotation()
            let routeViewModel = RouteViewModel(route: route)
            routeMarker.coordinate = routeViewModel.location.coordinate
            routeMarker.title = routeViewModel.name
            routeMarker.subtitle = "\(routeViewModel.rating) \(routeViewModel.typesString)"
            mapView.addAnnotation(routeMarker)
        }

        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways {
            if initialRoutes.isEmpty, let coord = locManager.location {
                mapView.centerMapOn(coord, animated: animateMap)
            } else {
                mapView.showAnnotations(mapView.annotations, animated: animateMap)
            }
        }
    }

    func initViews() {
        view.backgroundColor = UIColor(named: "#202226")
        view.clipsToBounds = true

        mapView = MKMapView()
        mapView.showsUserLocation = true

        view.addSubview(mapView)

        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
}
