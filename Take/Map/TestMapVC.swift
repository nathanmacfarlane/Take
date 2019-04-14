import ClusterKit
import Foundation
import Geofirestore
import GoogleMaps
import MapKit
import UIKit

class RouteItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var routeKey: String?

    init(position: CLLocationCoordinate2D, routeKey: String?) {
        self.position = position
        self.routeKey = routeKey
    }
}

class TestMapVC: UIViewController, GMSMapViewDelegate, GMUClusterManagerDelegate, GMUClusterRendererDelegate {

    // vars
    private var addedRoutes: [String] = []
    private var selectedInfoWindow: MarkerCallout?

    // clustering
    private var mapView: GMSMapView!
    private var clusterManager: GMUClusterManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()

        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        renderer.delegate = self
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)

        clusterManager.cluster()

        clusterManager.setDelegate(self, mapDelegate: self)

        if let routesUrl = Bundle.main.url(forResource: "RoutesPersisted", withExtension: "plist"), let routes = NSDictionary(contentsOf: routesUrl) as? [String: AnyObject] {
            for id in Array(routes.keys) {
                guard let route = routes[id], let latitude = route["la"] as? Double, let longitude = route["lo"] as? Double else { continue }
                let item = RouteItem(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), routeKey: id)
                self.clusterManager.add(item)
            }
        }
    }

    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        if marker.userData as? RouteItem != nil {
            marker.icon = UIImage(named: "icon_map_route")
        } else if let data = marker.userData as? GMUCluster {
            var size = 40
            switch data.count {
            case 0...5:
                size = 25
            case 5...25:
                size = 40
            default:
                size = 60
            }

            let view = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
            let imageView = UIImageView(frame: view.frame)

            let countLabel = UILabel(frame: view.frame)
            countLabel.text = "\(data.count)"
            countLabel.textAlignment = .center
            countLabel.textColor = .white

            imageView.image = UIImage(named: "icon_map_cluster")

            view.addSubview(imageView)
            view.addSubview(countLabel)

            marker.iconView = view
        }
    }

    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position, zoom: mapView.camera.zoom + 1)
        mapView.animate(to: newCamera)
        return false
    }

    private func randomScale() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
    }

    func initViews() {

        if let user = LocationService.shared.location {
            let camera = GMSCameraPosition.camera(withTarget: user.coordinate, zoom: 15.0)
            mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            mapView.delegate = self
            view = mapView
            mapView.isMyLocationEnabled = true
        }
    }

//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        marker.zIndex = 2
//        return false
//    }
//
//    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
//        marker.zIndex = 1
//    }

    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let infoWindow = selectedInfoWindow, let route = infoWindow.route else { return }
        let routeManager = RouteManagerVC()
        routeManager.routeViewModel = RouteViewModel(route: route)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(routeManager, animated: true)
        }
    }

    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        marker.tracksInfoWindowChanges = true
        if let data = marker.userData as? RouteItem {
            let callout = MarkerCallout(size: CGSize(width: 200, height: 90), routeKey: data.routeKey)
            callout.loadRoute { route in
                let routeViewModel = RouteViewModel(route: route)
                DispatchQueue.main.async {
                    callout.stopLoading()
                    callout.titleLabel.text = routeViewModel.name
                    callout.ratingLabel.text = routeViewModel.rating
                    callout.typesLabel.text = routeViewModel.typesString
                }
            }
            self.selectedInfoWindow = callout
            return callout
        }
        return nil
    }

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
//        let geoRoutes = FirestoreService.shared.fs.collection("route-geos")
//        let geoFirestoreRoutes = GeoFirestore(collectionRef: geoRoutes)
//        let circleQueryRoutes = geoFirestoreRoutes.query(inRegion: mapView.region)
//        _ = circleQueryRoutes.observe(.documentEntered) { key, location in
//            if !self.addedRoutes.contains("\(key as Any)"), let loc = location {
//                self.addedRoutes.append("\(key as Any)")
//                DispatchQueue.main.async {
//                    let item = RouteItem(position: CLLocationCoordinate2D(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude), routeKey: key)
//                    self.clusterManager.add(item)
//                }
//            }
//        }
    }
}

extension GMSMapView {
    var region: MKCoordinateRegion {
        get {
            let visibleRegion = self.projection.visibleRegion()
            let bounds = GMSCoordinateBounds(region: visibleRegion)
            let latitudeDelta = bounds.northEast.latitude - bounds.southWest.latitude
            let longitudeDelta = bounds.northEast.longitude - bounds.southWest.longitude
            let center = CLLocationCoordinate2DMake(
                (bounds.southWest.latitude + bounds.northEast.latitude) / 2,
                (bounds.southWest.longitude + bounds.northEast.longitude) / 2)
            let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
            return MKCoordinateRegion(center: center, span: span)
        }
        set {
            let northEast = CLLocationCoordinate2DMake(newValue.center.latitude - newValue.span.latitudeDelta / 2, newValue.center.longitude - newValue.span.longitudeDelta / 2)
            let southWest = CLLocationCoordinate2DMake(newValue.center.latitude + newValue.span.latitudeDelta / 2, newValue.center.longitude + newValue.span.longitudeDelta / 2)
            let bounds = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
            let update = GMSCameraUpdate.fit(bounds, withPadding: 0)
            self.moveCamera(update)
        }
    }
}
