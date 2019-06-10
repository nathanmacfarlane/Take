import Foundation

struct ARDiagram: Codable, HypeType {
    var id: String
    var userId: String
    var dateString: String
    var message: String
    var dgImageUrl: String
    var bgImageUrl: String
    var routeId: String
    var latitude: Double?
    var longitude: Double?
}
