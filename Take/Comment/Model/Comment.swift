import Foundation

struct Comment: Codable, HypeType {
    var id: String
    var userId: String
    var dateString: String
    var message: String?
    var imageUrl: String?
    var routeId: String

//    init(id: String, userId: String, dateString: String, message: String?, imageUrl: String?, routeId: String) {
//        self.id = id
//        self.userId = userId
//        self.dateString = dateString
//        self.message = message
//        self.imageUrl = imageUrl
//        self.routeId = routeId
//    }
}
