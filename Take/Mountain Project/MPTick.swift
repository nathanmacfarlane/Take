import Foundation

struct MPTick: Codable {
    var routeId: Int
    var date: String
    var pitches: Int
    var notes: String
    var style: String
    var leadStyle: String
    var tickId: Int
    var userStars: Int
    var userRating: String
}

struct MPTickList: Codable {
    var hardest: String
    var average: String
    var ticks: [MPTick]
}
