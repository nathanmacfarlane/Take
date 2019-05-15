import Foundation
import MapKit

class Area: Codable {

    var id: String
    var name: String
    var latitude: Double
    var longitude: Double
    var radius: Double
    var imageUrl: String?
    var description: String?
    var directions: String?
    var closureInfo: String?

    init(id: String, name: String, location: CLLocation, radius: Double, closureInfo: String?, imageUrl: String?) {
        self.id = id
        self.name = name
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.radius = radius
        self.imageUrl = imageUrl
        self.closureInfo = closureInfo
    }

    convenience init(id: String, name: String, location: CLLocation, radius: Double) {
        self.init(id: id, name: name, location: location, radius: radius, closureInfo: nil, imageUrl: nil)
    }

    convenience init(id: String, name: String, latitude: Double, longitude: Double, radius: Double) {
        self.init(id: id, name: name, location: CLLocation(latitude: latitude, longitude: longitude), radius: radius, closureInfo: nil, imageUrl: nil)
    }
}
