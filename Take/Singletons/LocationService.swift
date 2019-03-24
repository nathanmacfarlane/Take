import Foundation
import MapKit

class LocationService: NSObject, CLLocationManagerDelegate {
    static let shared = LocationService()
    private var locationManager = CLLocationManager()
    var delegate: LocationServiceDelegate?

    var location: CLLocation? {
        return locationManager.location
    }

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        delegate?.updatedLocation(location: location)
    }
}

protocol LocationServiceDelegate: class {
    func updatedLocation(location: CLLocation)
}
