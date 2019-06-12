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
    
    init(id: String, name: String, username: String) {
        self.id = id
        self.name = name
        //var profilePhotoUrl: String?
        self.username = username
        self.toDo = []
        self.friends = []
        self.types = []
        self.messageIds = []
        self.tradGrade = 0
        self.trGrade = 0
        self.sportGrade = 0
        self.boulderGrade = 0
        self.age = 0
        self.trLetter = ""
        self.tradLetter = ""
        self.sportLetter = ""
        self.bio = ""
        self.location = [0,0]
        self.info = ["how", "do", "you", "send"]
    }
}
