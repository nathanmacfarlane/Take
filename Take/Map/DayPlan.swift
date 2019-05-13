import Foundation

struct DayPlan {
    let easy: MPRoute
    let medium: MPRoute
    let hard: MPRoute
    var distance: Double?
    var distanceMiles: Double? {
        guard let distance = distance else { return nil }
        return distance * 0.0006213712
    }
    var planId: String {
        return String(easy.id) + String(medium.id) + String(hard.id)
    }
}

struct UserPlanFB: Codable {
    var easy: String
    var medium: String
    var hard: String
    var distance: Double?
    var userId: String
    var id: String
    var title: String

    init(dayPlan: DayPlan, title: String, userId: String) {
        self.easy = String(dayPlan.easy.id)
        self.medium = String(dayPlan.medium.id)
        self.hard = String(dayPlan.hard.id)
        self.distance = dayPlan.distance
        self.userId = userId
        self.id = self.easy + self.medium + self.hard
        self.title = title
    }
}
