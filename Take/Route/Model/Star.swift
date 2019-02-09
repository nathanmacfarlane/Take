import Foundation

class Star: Codable, HypeType {
    var userId: String
    var value: Double
    var dateString: String

    init(userId: String, value: Double, dateString: String) {
        self.userId = userId
        self.value = value
        self.dateString = dateString
    }

    convenience init(userId: String, value: Double, date: Date) {
        self.init(userId: userId, value: value, dateString: "\(date.timeIntervalSince1970)")
    }
}
