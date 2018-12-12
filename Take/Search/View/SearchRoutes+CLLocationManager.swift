import CoreLocation
import Foundation

extension SearchRoutesVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        userCurrentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
    }
}
