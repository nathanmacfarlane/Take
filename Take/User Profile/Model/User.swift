import Firebase
import Foundation

/// User data type that is in Firebase
struct User: Codable {
    var id: String
    var name: String
    var profilePhotoUrl: String?
    var username: String?
    var toDo: [String] // array of list ids
    var friends: [String]
    var types: [String] = [] // TR (Top Rope), Sport, Trad, Boulder
    var messageIds: [String] = []
    var beer: String
    var whips: String
    var climbYear: String
    var tradGrade: String
    var trGrade: String
    var sportGrade: String
    var boulderGrade: String
    var age: Int
}
