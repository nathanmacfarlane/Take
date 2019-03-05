import Foundation
import Geofirestore
import MapKit
import UIKit

class MapVC: UIViewController, MKMapViewDelegate {

    var mapView: MKMapView!
    var initialRoutes: [Route] = []
    var animateMap: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()

        if let loc = LocationService.shared.location?.coordinate {
            let region = MKCoordinateRegion(center: loc, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: false)
        }

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
        if !initialRoutes.isEmpty {
            mapView.showAnnotations(mapView.annotations.filter { $0.title != "My Location" }, animated: animateMap)
        }
    }

    func initViews() {
        view.backgroundColor = UIColor(named: "#202226")
        view.clipsToBounds = true

        mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = self

        view.addSubview(mapView)

        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        mapView.removeAllAnnotations()
        let geoFirestoreRef = FirestoreService.shared.fs.collection("route-geos")
        let geoFirestore = GeoFirestore(collectionRef: geoFirestoreRef)
        let circleQuery = geoFirestore.query(inRegion: mapView.region)
        _ = circleQuery.observe(.documentEntered) { key, location in
            guard let latitude = location?.coordinate.latitude, let longitude = location?.coordinate.longitude, let key = key else { return }
            let anno = MKPointAnnotation()
            anno.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            FirestoreService.shared.fs.query(collection: "routes", by: "id", with: key, of: Route.self) { route in
                guard let route = route.first else { return }
                let routeViewModel = RouteViewModel(route: route)
                anno.title = routeViewModel.name
                anno.subtitle = "\(routeViewModel.rating) \(routeViewModel.typesString)"
            }
            mapView.addAnnotation(anno)
        }
    }
}
