import Foundation
import UIKit

class Route: Codable {

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
    var routeArUrls: [String: [String]] = [:]
    var stars: [String: Int] = [:]
    var area: String?
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
        case buffer
        case routeArUrls
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
        self.routeArUrls = [:]
        self.stars = [:]
    }
}
