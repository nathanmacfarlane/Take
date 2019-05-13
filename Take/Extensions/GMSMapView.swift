import Alamofire
import Foundation

extension GMSMapView {
    func centerMap(l1: CLLocation, l2: CLLocation, l3: CLLocation) {
        let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(location: l1), zoom: 14)
        self.camera = camera
    }

    func addMarker(route: MPRoute) -> GMSMarker {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: route.latitude, longitude: route.longitude)
        marker.title = route.name
        marker.map = self
        return marker
    }

    func drawPath(easy: MPRoute, medium: MPRoute, hard: MPRoute, completion: @escaping (_ plan: DayPlan) -> Void) {

        let l1 = easy.loc
        let l2 = medium.loc
        let l3 = hard.loc

        if l1.distance(from: l2) < 1 && l2.distance(from: l3) < 1 {
            completion(DayPlan(easy: easy, medium: medium, hard: hard, distance: 0))
        } else if l1.distance(from: l2) < 1 {
            let origin = "\(l1.coordinate.latitude),\(l1.coordinate.longitude)"
            let destination = "\(l3.coordinate.latitude),\(l3.coordinate.longitude)"
            let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=walking&key=\(Constants.googleKey)"
            drawPathWithUrl(url: url) { distance in
                completion(DayPlan(easy: easy, medium: medium, hard: hard, distance: Double(distance)))
            }
        } else if l2.distance(from: l3) < 1 {
            let origin = "\(l1.coordinate.latitude),\(l1.coordinate.longitude)"
            let destination = "\(l3.coordinate.latitude),\(l3.coordinate.longitude)"
            let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=walking&key=\(Constants.googleKey)"
            drawPathWithUrl(url: url) { distance in
                completion(DayPlan(easy: easy, medium: medium, hard: hard, distance: Double(distance)))
            }
        } else if l1.distance(from: l3) < 1 {
            let origin = "\(l2.coordinate.latitude),\(l2.coordinate.longitude)"
            let destination = "\(l3.coordinate.latitude),\(l3.coordinate.longitude)"
            let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=walking&key=\(Constants.googleKey)"
            drawPathWithUrl(url: url) { distance in
                completion(DayPlan(easy: easy, medium: medium, hard: hard, distance: Double(distance)))
            }
        } else {
            var origin = "\(l1.coordinate.latitude),\(l1.coordinate.longitude)"
            var destination = "\(l2.coordinate.latitude),\(l2.coordinate.longitude)"
            var url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=walking&key=\(Constants.googleKey)"
            var drewOne = false
            var total = 0
            drawPathWithUrl(url: url) { distance in
                if drewOne {
                    completion(DayPlan(easy: easy, medium: medium, hard: hard, distance: Double(total + distance)))
                } else {
                    total = distance
                    drewOne = true
                }
            }
            origin = "\(l2.coordinate.latitude),\(l2.coordinate.longitude)"
            destination = "\(l3.coordinate.latitude),\(l3.coordinate.longitude)"
            url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=walking&key=\(Constants.googleKey)"
            drawPathWithUrl(url: url) { distance in
                if drewOne {
                    completion(DayPlan(easy: easy, medium: medium, hard: hard, distance: Double(total + distance)))
                } else {
                    total = distance
                    drewOne = true
                }
            }
        }
    }

    private func drawPathWithUrl(url: String, completion: @escaping (_ distance: Int) -> Void) {
        AF.request(url).responseJSON { response in
            guard let data = response.data, let result = try? JSONDecoder().decode(Dir.self, from: data) else { return }
            var total = 0
            for route in result.routes {
                self.drawPath(from: route.overview_polyline.points)
                for leg in route.legs {
                    total += leg.distance.value
                }
            }
            completion(total)
        }
    }

    private func drawPath(from polyStr: String) {
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = self // Google MapView
    }
}
