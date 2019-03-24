import Foundation
import MapKit
import UIKit

class AreaViewModel {

    var area: Area
    var id: String {
        return area.id
    }
    var name: String {
        return area.name
    }
    var location: CLLocation {
        return CLLocation(latitude: area.latitude, longitude: area.longitude)
    }

    init(area: Area) {
        self.area = area
    }

    var latAndLongString: String {
        return "\(Double(location.coordinate.latitude).rounded(toPlaces: 4)) \(Double(location.coordinate.longitude).rounded(toPlaces: 4))"
    }

    func cityAndState(completion: @escaping (_ city: String, _ state: String) -> Void) {
        self.location.cityAndState { c, s, _ in
            completion(c ?? "", s ?? "")
        }
    }
}
