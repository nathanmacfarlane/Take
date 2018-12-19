import Firebase
import Foundation

/// User data type that is in Firebase
struct User: Codable {
    var id: String
    var name: String
    var profilePhotoUrl: String?
    var username: String?
    var toDo: [String] // array of list ids
}
