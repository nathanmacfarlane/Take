import FirebaseFirestore
import Foundation

enum NotificationType {
    case collaboration
}

struct Alert: Codable {
    var body: String
    var title: String
}

struct FirebaseNotification: Codable {
    var alert: Alert
}

struct NotificationCollaboration: Codable, Notification {

    var date: Double
    var fromUser: String
    var toUser: String
    var routeListId: String
    var title: String
    var id: String
    var body: String

    init(date: Date, fromUser: String, toUser: String, routeListId: String, title: String) {
        self.date = date.timeIntervalSince1970
        self.fromUser = fromUser
        self.toUser = toUser
        self.routeListId = routeListId
        self.title = title
        self.body = ""
        self.id = UUID().uuidString
    }

    func clear(completion: ((_ success: Bool) -> Void)? ) {
        Firestore.firestore().delete(document: id, from: "notifications") { successful in
            completion?(successful)
        }
    }
}

struct NotificationMessage: Codable, Notification {
    var toUser: String
    var title: String
    var body: String
    var date: Double
    var id: String
    var fromUser: String
    var messagesId: String

    init(fromUser: User, toUser: String, message: String, messagesId: String) {
        self.date = Date().timeIntervalSince1970
        self.fromUser = fromUser.id
        self.toUser = toUser
        self.title = "DM from \(fromUser.username ?? fromUser.name)"
        self.body = message
        self.messagesId = messagesId
        self.id = UUID().uuidString
    }

    func clear(completion: ((_ success: Bool) -> Void)? ) {
        FirestoreService.shared.fs.delete(document: id, from: "notifications") { successful in
            completion?(successful)
        }
    }

}

protocol Notification {
    var toUser: String { get set }
    var title: String { get set }
    var body: String { get set }
    var date: Double { get }
    var id: String { get }
    func clear(completion: ((_ success: Bool) -> Void)?)
}
