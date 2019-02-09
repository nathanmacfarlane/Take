import Foundation
import MapKit
import UIKit

class MapVC: UIViewController {

    var mapView: MKMapView!
    var initialRoutes: [Route] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        mapView.removeAllAnnotations()

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
                mapView.centerMapOn(coord)
            } else {
                mapView.showAnnotations(mapView.annotations, animated: true)
            }
        }
    }

    func getCenter(arr: [MKAnnotation]) -> CLLocationCoordinate2D {

        if arr.count == 1 {
            return arr[0].coordinate
        }
        var x: Double = 0.0
        var y: Double = 0.0
        var z: Double = 0.0

        for anno in arr {
            let lat = anno.coordinate.latitude * .pi / 180
            let lon = anno.coordinate.longitude * .pi / 180

            x += cos(lat) * cos(lon)
            y += cos(lat) * sin(lon)
            z += sin(lat)
        }

        let total = Double(arr.count)

        x /= total
        y /= total
        z /= total

        let centralLon = atan2(y, x)
        let centralSqrt = sqrt(x * x + y * y)
        let centralLat = atan2(z, centralSqrt)

        return CLLocationCoordinate2D(latitude: centralLat * 180 / .pi, longitude: centralLon * 180 / .pi)
    }

    func initViews() {
        view.backgroundColor = UIColor(named: "#202226")

        mapView = MKMapView(frame: view.frame)
        mapView.showsUserLocation = true

        view.addSubview(mapView)
    }
}
