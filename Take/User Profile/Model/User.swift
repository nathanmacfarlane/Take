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
    var tradGrade: Int
    var trGrade: Int
    var sportGrade: Int
    var boulderGrade: Int
    var age: Int
    var trLetter: String
    var tradLetter: String
    var sportLetter: String
    var bio: String
    var location: [Double]
    var info: [String]
}
