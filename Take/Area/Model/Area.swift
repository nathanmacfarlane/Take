import Foundation
import MapKit

class Area: Codable {

    var id: String
    var name: String
    var latitude: Double
    var longitude: Double
    var imageUrl: String?

    init(id: String, name: String, location: CLLocation, imageUrl: String?) {
        self.id = id
        self.name = name
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.imageUrl = imageUrl
    }

    convenience init(id: String, name: String, location: CLLocation) {
        self.init(id: id, name: name, location: location, imageUrl: nil)
    }

    convenience init(id: String, name: String, latitude: Double, longitude: Double) {
        self.init(id: id, name: name, location: CLLocation(latitude: latitude, longitude: longitude), imageUrl: nil)
    }
}
