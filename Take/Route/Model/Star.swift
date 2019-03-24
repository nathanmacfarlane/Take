import Foundation

class Star: Codable, HypeType, Hashable {
    var id: String
    var userId: String
    var value: Double
    var dateString: String

    init(userId: String, value: Double, dateString: String) {
        self.userId = userId
        self.value = value
        self.dateString = dateString
        self.id = UUID().uuidString
    }

    static func == (lhs: Star, rhs: Star) -> Bool {
        return false
    }

    var hashValue: Int {
        return 0
    }

    convenience init(userId: String, value: Double, date: Date) {
        self.init(userId: userId, value: value, dateString: "\(date.timeIntervalSince1970)")
    }
}
