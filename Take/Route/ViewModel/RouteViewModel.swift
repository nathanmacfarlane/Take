import CodableFirebase
import FirebaseFirestore
import Foundation
import Geofirestore
import MapKit
import UIKit

class RouteViewModel {
    // MARK: - Variables
    var route: Route

    // MARK: - Constructors
    init(route: Route) {
        self.route = route
    }

    // MARK: - Computed Properties
    var id: String {
        return route.getId()
    }
    var name: String {
        return route.getName()
    }
    var pitchesString: String {
        return "\(route.getPitches())"
    }
    var info: String {
        return route.getInfo() ?? "N/A"
    }
    var protection: String {
        return route.getProtection() ?? "N/A"
    }
    var rating: String {
        return route.getRating() ?? "N/A"
    }

    var averageStar: Double? {
        if route.stars.isEmpty { return nil }
        var sum: Double = 0
        for star in route.stars.values {
            sum += Double(star)
        }
        return sum / Double(route.stars.count)
    }

    var averageStarString: String {
        if let averageStar = averageStar {
            return "\(averageStar) Stars"
        }
        return "N/A"
    }

    var location: CLLocation {
        if let lat = route.getLatitude(), let long = route.getLongitude() {
            return CLLocation(latitude: lat, longitude: long)
        }
        return CLLocation(latitude: -1, longitude: -1)
    }

    var types: [RouteType] {
        return route.getTypes().map { type -> RouteType in
            RouteType(rawValue: type) ?? .tr
        }
    }

    var isTR: Bool {
        return types.contains(.tr)
    }

    var isSport: Bool {
        return types.contains(.sport)
    }

    var isTrad: Bool {
        return types.contains(.trad)
    }

    var isAid: Bool {
        return types.contains(.aid)
    }

    var isBoulder: Bool {
        return types.contains(.boulder)
    }

    var toString: String {
        return "'\(route.getName())' - Difficulty: '\(route.getRating() ?? "N/A")'"
    }

    var typesString: String {
        var types: [String] = []
        for type in route.getTypes() {
            types.append("\(type)")
        }
        return types.joined(separator: ", ")
    }

    func fsLoadImages(completion: @escaping (_ images: [String: UIImage]) -> Void) {
        var images: [String: UIImage] = [:]
        var count = 0
        for routeImage in route.getImageUrls() {
            guard let theURL = URL(string: routeImage.value) else { continue }
            URLSession.shared.dataTask(with: theURL) { data, _, _ in
                guard let theData = data, let theImage = UIImage(data: theData) else { return }
                images[routeImage.key] = theImage
                count += 1
                if count == self.route.getImageUrls().count {
                    completion(images)
                }
            }
            .resume()
        }
    }

    func fsLoadFirstImage(completion: @escaping (_ key: String?, _ image: UIImage?) -> Void) {
        guard let routeImage = route.getImageUrls().first, let theURL = URL(string: routeImage.value) else {
            completion(nil, nil)
            return
        }
        URLSession.shared.dataTask(with: theURL) { data, _, _ in
            guard let theData = data, let theImage = UIImage(data: theData) else {
                completion(nil, nil)
                return
            }
            completion(routeImage.key, theImage)
        }
        .resume()
    }
}
