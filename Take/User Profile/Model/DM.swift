import Firebase
import Foundation

/// User data type that is in Firebase
struct DM: Codable {
    var messageId: String
    var userIds: [String]
    var Thread: [ThreadContent]
    
    init(messageId: String, userIds: [String], thread: [ThreadContent]) {
        self.messageId = messageId
        self.userIds = userIds
        self.Thread = thread
    }
}

struct ThreadContent: Codable {
    var message: String
    var sender: String

    init(message: String, sender: String) {
        self.message = message
        self.sender = sender
    }
}

