import Foundation
import UIKit

class Route: Codable {

    // MARK: - properties
    private var name: String
    private var id: String
    private var pitches: Int
    private var types: [String] = [] // TR (Top Rope), Sport, Trad, Boulder
    private var rating: String?
    private var info: String?
    private var protection: String?
    private var latitude: Double?
    private var longitude: Double?
    var stars: [String: Int] = [:]
    var area: String?
    var imageUrls: [String: String] = [:]
    var routeArUrls: [String: [String]] = [:]
    var commentIds: [String] = []
    var comments: [String] = []

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
        case routeArUrls
        case commentIds
        case comments
    }

    // MARK: - Getters
    func getName() -> String {
        return self.name
    }
    func getId() -> String {
        return self.id
    }
    func getPitches() -> Int {
        return self.pitches
    }
    func getTypes() -> [String] {
        return self.types
    }
    func getInfo() -> String? {
        return self.info
    }
    func getProtection() -> String? {
        return self.protection
    }
    func getRating() -> String? {
        return self.rating
    }
    func getLatitude() -> Double? {
        return self.latitude
    }
    func getLongitude() -> Double? {
        return self.longitude
    }
}
