import Firebase
import Foundation

/// User data type that is in Firebase
struct DM: Codable {
    var messageId: String
    var userIds: [String]
    var Thread: [ThreadContent]
}

struct ThreadContent: Codable {
    var message: String
    var sender: String
}
