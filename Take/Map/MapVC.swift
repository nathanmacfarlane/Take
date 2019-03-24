import Foundation
import Geofirestore
import MapKit
import Presentr
import UIKit

enum PreviewSize: CGFloat {
    case small = 100, medium = 175, large = 300
}

class MapVC: UIViewController, MKMapViewDelegate, SelectedAreaProtocol {

    // UI
    var mapView: MKMapView!
    var mapSwitch: UISwitch!
    var preview: MapRoutePreview!
    var previewConstraint: NSLayoutConstraint!
    // Vars
    var initialRoutes: [Route] = []
    var animateMap: Bool = true
    var showSwitch = true
    var areaCache: [String: Area] = [:]
    var currentPreviewSize: PreviewSize = .large

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()

        if let loc = LocationService.shared.location?.coordinate {
            let region = MKCoordinateRegion(center: loc, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
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
            mapView.addAnnotation(routeMarker)
        }
        if !initialRoutes.isEmpty {
            mapView.showAnnotations(mapView.annotations.filter { $0.title != "My Location" }, animated: animateMap)
        }
    }

    @objc
    func switchedSwitch(_ sender: UISwitch) {
        mapView.mapType = sender.isOn ? .satellite : .standard
        mapView.removeAllOverlays()
        mapViewDidChangeVisibleRegion(mapView)
    }

    func selectedArea(area: Area) {
        let areaManager = AreaManagerVC()
        areaManager.areaViewModel = AreaViewModel(area: area)
        navigationController?.pushViewController(areaManager, animated: true)
    }

    @objc
    func tappedMap() {
        hidePreview()
    }

    func initViews() {
        view.backgroundColor = UIColor(named: "#202226")
        view.clipsToBounds = true

        mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = self

        let tapOnMap = UITapGestureRecognizer(target: self, action: #selector(tappedMap))
        mapView.addGestureRecognizer(tapOnMap)

        preview = MapRoutePreview()
        preview.nameLabel.text = "TESTING"
        preview.typeLabel.text = "TR, Sport"
        preview.difficultyLabel.text = "5.10c"
        preview.layer.cornerRadius = 15
        preview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        view.addSubview(mapView)
        view.addSubview(preview)

        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

        preview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: preview, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: preview, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        previewConstraint = NSLayoutConstraint(item: preview, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: currentPreviewSize.rawValue)
        previewConstraint.isActive = true
        NSLayoutConstraint(item: preview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: currentPreviewSize.rawValue).isActive = true

        if showSwitch {
            mapSwitch = UISwitch()
            mapSwitch.backgroundColor = .white
            mapSwitch.onTintColor = UISettings.shared.colorScheme.accent
            mapSwitch.addTarget(self, action: #selector(switchedSwitch), for: .touchUpInside)
            view.addSubview(mapSwitch)
            mapSwitch.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: mapSwitch, attribute: .leading, relatedBy: .equal, toItem: mapView, attribute: .leading, multiplier: 1, constant: 10).isActive = true
            NSLayoutConstraint(item: mapSwitch, attribute: .top, relatedBy: .equal, toItem: mapView, attribute: .top, multiplier: 1, constant: 10).isActive = true
        }
    }

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        hidePreview()

        for anno in mapView.selectedAnnotations {
            mapView.deselectAnnotation(anno, animated: true)
        }
        MPService.shared.getRoutesForLatLon(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude) { mpRoutes in
            let routes = mpRoutes.map { Route(mpRoute: $0) }
            for route in routes {
                if self.routeAlreadyOnMap(key: route.id) { continue }
                self.addRouteAnnotation(route: route)
            }
        }
//        let geoRoutes = FirestoreService.shared.fs.collection("route-geos")
//        let geoFirestoreRoutes = GeoFirestore(collectionRef: geoRoutes)
//        let circleQueryRoutes = geoFirestoreRoutes.query(inRegion: mapView.region)
//        _ = circleQueryRoutes.observe(.documentEntered) { key, _ in
//            guard let key = key else { return }
//            if self.routeAlreadyOnMap(key: key) { return }
//            FirestoreService.shared.fs.query(collection: "routes", by: "id", with: key, of: Route.self) { route in
//                guard let route = route.first else { return }
//                self.addRouteAnnotation(route: route)
//            }
//        }
//
//        let geoAreas = FirestoreService.shared.fs.collection("area-geos")
//        let geoFirestoreAreas = GeoFirestore(collectionRef: geoAreas)
//        let circleQueryAreas = geoFirestoreAreas.query(inRegion: mapView.region)
//        _ = circleQueryAreas.observe(.documentEntered) { key, _ in
//            guard let key = key else { return }
//            if self.areaAlreadyOnMap(key: key) { return }
//            if let area = self.areaCache[key] {
//                self.addOverlay(area: area)
//            } else {
//                FirestoreService.shared.fs.query(collection: "areas", by: "id", with: key, of: Area.self) { area in
//                    guard let area = area.first else { return }
//                    self.areaCache[key] = area
//                    self.addOverlay(area: area)
//                    self.addAreaAnnotation(area: area)
//                }
//            }
//        }
    }

    func areaAlreadyOnMap(key: String) -> Bool {
        for annotation in mapView.annotations {
            guard let annotation = annotation as? AreaAnnotation else { continue }
            if annotation.area.id == key { return true }
        }
        return false
    }

    func routeAlreadyOnMap(key: String) -> Bool {
        for annotation in mapView.annotations {
            guard let annotation = annotation as? RouteAnnotation else { continue }
            if annotation.route.id == key { return true }
        }
        return false
    }

    func addRouteAnnotation(route: Route) {
        let routeViewModel = RouteViewModel(route: route)
        let anno = RouteAnnotation(route: route)
        guard let latitude = route.latitude, let longitude = route.longitude else { return }
        anno.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        anno.title = routeViewModel.name
        anno.subtitle = "\(routeViewModel.rating) \(routeViewModel.typesString)"
        DispatchQueue.main.async {
            if self.routeAlreadyOnMap(key: route.id) { return }
            self.mapView.addAnnotation(anno)
        }
    }

    func addAreaAnnotation(area: Area) {
        let areaViewModel = AreaViewModel(area: area)
        let anno = AreaAnnotation(area: area)
        anno.coordinate = CLLocationCoordinate2D(latitude: area.latitude, longitude: area.longitude)
        anno.title = areaViewModel.name
        DispatchQueue.main.async {
            if self.areaAlreadyOnMap(key: area.id) { return }
            self.mapView.addAnnotation(anno)
        }
    }

    func addOverlay(area: Area) {
        if self.areaAlreadyOnMap(key: area.id) { return }
        let circle = AreaOverlay(center: CLLocationCoordinate2D(latitude: area.latitude, longitude: area.longitude), radius: area.radius)
        circle.area = area
        mapView.addOverlay(circle)
    }

    override func viewDidLayoutSubviews() {
        if showSwitch == true {
            mapSwitch.layer.cornerRadius = mapSwitch.frame.height / 2
            mapSwitch.clipsToBounds = true
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circleOverlay = overlay as? AreaOverlay else { return MKOverlayRenderer() }
        let circleRenderer = MKCircleRenderer(circle: circleOverlay)
        circleRenderer.strokeColor = UISettings.shared.colorScheme.accent
        circleRenderer.alpha = 1.0
        return circleRenderer
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = MKMarkerAnnotationView()
        guard let annotation = annotation as? AreaAnnotation else { return nil }
        let identifier = "areaAnnotation"

        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            annotationView = dequedView
        } else {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView.markerTintColor = UISettings.shared.colorScheme.accent
        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let routePin = view.annotation as? RouteAnnotation {
            let routeViewModel = RouteViewModel(route: routePin.route)
            preview.nameLabel.text = routeViewModel.name
            preview.difficultyLabel.text = routeViewModel.rating
            preview.typeLabel.text = routeViewModel.typesString
            preview.cosmos.rating = routeViewModel.averageStar ?? 0
            preview.pitchesLabel.text = "\(routeViewModel.pitchesString) Pitch\(routeViewModel.pitchesDouble > 1 ? "es" : "")"
            preview.clearImages()
            FirestoreService.shared.fs.query(collection: "comments", by: "routeId", with: routeViewModel.id, of: Comment.self) { comment in
                guard let comment = comment.first, let imageUrl = comment.imageUrl else { return }
                self.preview.addImage(photoUrl: imageUrl)
            }
            showPreview()
        } else if let areaPin = view.annotation as? AreaAnnotation {
            print("selected area: \(areaPin.area.name)")
        }
    }

    func hidePreview() {
        preview.movement = 0
        if previewConstraint.constant == currentPreviewSize.rawValue { return }
        previewConstraint.constant = currentPreviewSize.rawValue
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func showPreview() {
        if previewConstraint.constant == 0 { return }
        previewConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

private class AreaOverlay: MKCircle {
    var area: Area?
}

private class RouteAnnotation: MKPointAnnotation {
    var route: Route
    init(route: Route) {
        self.route = route
    }
    @objc
    func tappedAnno() {

    }
}

private class AreaAnnotation: MKPointAnnotation {
    var area: Area
    init(area: Area) {
        self.area = area
    }
}
