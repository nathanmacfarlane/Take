import Foundation
import UIKit

class Route: Codable, Hashable {

    // MARK: - properties
    var name: String
    var id: String
    var pitches: Int
    var types: [String] = [] // TR (Top Rope), Sport, Trad, Boulder
    var rating: Int?
    var buffer: Int?
    var info: String?
    var protection: String?
    var closureInfo: String?
    var latitude: Double?
    var longitude: Double?
    var imageUrls: [String: String] = [:]
    var arDiagrams: [String] = []
    var stars: [String: Star] = [:]
    var area: String?
    var comments: [String] = []

    static func == (lhs: Route, rhs: Route) -> Bool {
        return lhs.id == rhs.id
    }

    var hashValue: Int {
        return id.hashValue
    }

    // MARK: - Coding Keys
    /* Whatever keys are in here are required to be apart of the object in firebase */
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case types
        case latitude
        case longitude
        case area
        case info
        case protection
        case imageUrls
        case stars
        case pitches
        case rating
        case buffer
        case comments
        case closureInfo
    }

    init(name: String, id: String, pitches: Int) {
        self.name = name
        self.id = id
        self.pitches = pitches
        self.types = []
        self.comments = []
        self.imageUrls = [:]
        self.arDiagrams = []
        self.stars = [:]
    }

    init(mpRoute: MPRoute) {
        self.name = mpRoute.name
        self.id = "\(mpRoute.id)"
        if case .int(let pitches) = mpRoute.pitches {
            self.pitches = pitches
        } else {
            self.pitches = 1
        }
        self.types = (mpRoute.type ?? "").split(separator: ",").map(String.init)
        self.comments = []
        self.imageUrls = [:]
        self.arDiagrams = []
        self.stars = [:]
        self.latitude = mpRoute.latitude
        self.longitude = mpRoute.longitude

        (self.rating, self.buffer) = mpRoute.takeRating

//        if let rating = mpRoute.rating {
//
//            if self.types.contains("Boulder") {
//                let splitUp = rating.split(separator: "V")
//                if splitUp.count > 1 {
//                    self.buffer = Int("\(splitUp[1])")
//                }
//            } else {
//                let splitUp = rating.split(separator: ".")
//                if splitUp.count > 1 {
//                    self.rating = Int("\(splitUp[1])")
//                }
//            }
//        }
    }
}
