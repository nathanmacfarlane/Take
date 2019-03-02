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
        return route.id
    }
    var name: String {
        return route.name
    }
    var pitchesString: String {
        return "\(route.pitches)"
    }
    var pitchesDouble: Double {
        return Double(route.pitches)
    }
    var info: String {
        return route.info ?? "N/A"
    }
    var closureInfo: String? {
        return route.closureInfo
    }
    var protection: String {
        return route.protection ?? "N/A"
    }
    var rating: String {
        if let rating = route.rating {
            return "5.\(rating)\(buffer ?? "")"
        }
        return "N/A"
    }

    var stars: [String: Star] {
        return route.stars
    }

    var starsArray: [Star] {
        return Array(route.stars.values)
    }

    var averageStar: Double? {
        if route.stars.isEmpty { return nil }
        let sum = route.stars.values.reduce(0) { $0 + $1.value }
        return sum / Double(route.stars.count)
    }

    var averageStarString: String {
        if let averageStar = averageStar {
            return "\(averageStar) Stars"
        }
        return "N/A"
    }

    var location: CLLocation {
        if let lat = route.latitude, let long = route.longitude {
            return CLLocation(latitude: lat, longitude: long)
        }
        return CLLocation(latitude: -1, longitude: -1)
    }

    var latAndLongString: String {
        return "\(Double(location.coordinate.latitude).rounded(toPlaces: 4)) \(Double(location.coordinate.longitude).rounded(toPlaces: 4))"
    }

    func cityAndState(completion: @escaping (_ city: String, _ state: String) -> Void) {
        self.location.cityAndState { c, s, _ in
            completion(c ?? "", s ?? "")
        }
    }

    var types: [RouteType] {
        return route.types.map { type -> RouteType in
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

    var buffer: String? {
        guard let buffer = route.buffer else { return nil }
        switch buffer {
        case 0: return "a"
        case 1: return "b"
        case 2: return "c"
        case 3: return "d"
        default:
            return""
        }
    }

    var toString: String {
        var str = route.name
        if let rating = route.rating {
            str.append(" - Difficulty: 5.'\(rating)")
            if let buffer = buffer {
                str.append(buffer)
            }
        }
        return str
    }

    var typesString: String {
        var types: [String] = []
        for type in route.types {
            types.append("\(type)")
        }
        return types.joined(separator: ", ")
    }

    func getStar(forUser: String) -> Double? {
        return route.stars[forUser]?.value
    }

    func addStar(_ star: Double, forUserId userId: String) {
        route.stars[userId] = Star(userId: userId, value: star, date: Date())
    }

    func getArea(completion: @escaping (_ area: Area) -> Void) {
        if let routeId = self.route.area {
            FirestoreService.shared.fs.query(collection: "areas", by: "id", with: routeId, of: Area.self) { area in
                guard let area = area.first else { return }
                completion(area)
            }
        }
    }

    func getCurrentWeather(completion: @escaping (_ weather: WeatherViewModel) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/weather?units=imperial&lat=\(self.location.coordinate.latitude)&lon=\(self.location.coordinate.longitude)&APPID=\(Constants.weatherApiKey)"
        guard let now = URL(string: url) else {
            print("bad url")
            return
        }
        URLSession.shared.dataTask(with: now) { data, _, _ in
            guard let data = data else { return }
            guard let weather = try? JSONDecoder().decode(Weather.self, from: data) else {
                print("could not return weather")
                return
            }
            completion(WeatherViewModel(weather: weather))
        }
        .resume()
    }

    func getForecastWeather(completion: @escaping (_ forecast: ForecastViewModel) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/forecast?units=imperial&lat=\(self.location.coordinate.latitude)&lon=\(self.location.coordinate.longitude)&APPID=\(Constants.weatherApiKey)"
        guard let future = URL(string: url) else { return }
        URLSession.shared.dataTask(with: future) { data, _, _ in
            guard let data = data, let forecast = try? JSONDecoder().decode(Forecast.self, from: data) else { return }
            completion(ForecastViewModel(forecast: forecast))
        }
        .resume()
    }

    func fsLoadFirstImage(completion: @escaping (_ key: String?, _ image: UIImage?) -> Void) {
        guard let commentId = route.comments.first else {
            completion(nil, nil)
            return
        }
        FirestoreService.shared.fs.query(collection: "comments", by: "id", with: commentId, of: Comment.self) { comment in
            guard let comment = comment.first else { return }
            comment.imageUrl?.getImage { image in
                completion(commentId, image)
            }
        }
    }

    func saveToGeoFire() {
        let geoFirestoreRef = Firestore.firestore().collection("route-geos")
        let geoFirestore = GeoFirestore(collectionRef: geoFirestoreRef)
        geoFirestore.setLocation(location: location, forDocumentWithID: id) { error in
            if error == nil {
                print("Saved location successfully!")
            }
        }
    }
}
