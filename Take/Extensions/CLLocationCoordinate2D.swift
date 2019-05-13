import Foundation
import MapKit

extension CLLocationCoordinate2D {
    init(location: CLLocation) {
        self.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
}
