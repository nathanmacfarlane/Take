import Foundation
import UIKit

class Route: Codable {

    // MARK: - properties
    var name: String
    var id: String
    var pitches: Int
    var types: [String] = [] // TR (Top Rope), Sport, Trad, Boulder
    var rating: String?
    var info: String?
    var protection: String?
    var latitude: Double?
    var longitude: Double?
    var imageUrls: [String: String] = [:]
    var routeArUrls: [String: [String]] = [:]
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
}
