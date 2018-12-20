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
