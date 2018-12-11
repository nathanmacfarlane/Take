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
    private var imageUrls: [String: String] = [:]
    private var routeArUrls: [String: [String]] = [:]
    var stars: [String: Int] = [:]
    var area: String?
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
        return name
    }
    func getId() -> String {
        return id
    }
    func getPitches() -> Int {
        return pitches
    }
    func getTypes() -> [String] {
        return types
    }
    func getInfo() -> String? {
        return info
    }
    func getProtection() -> String? {
        return protection
    }
    func getRating() -> String? {
        return rating
    }
    func getLatitude() -> Double? {
        return latitude
    }
    func getLongitude() -> Double? {
        return longitude
    }
    func getImageUrls() -> [String: String] {
        return imageUrls
    }
    func getArUrls() -> [String: [String]] {
        return routeArUrls
    }
}
