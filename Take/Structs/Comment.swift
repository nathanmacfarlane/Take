import CodableFirebase
import Firebase
import FirebaseFirestore
import Foundation
import UIKit

struct Comment: Codable {
    var id: String
    var userId: String
    var dateString: String
    var message: String?
    var imageUrls: [String: String] = [:]

//    init?(snapshot: DataSnapshot) {
//        guard let snapval = snapshot.value as? [String: AnyObject] else { return nil }
//        guard let tempUserId = snapval["userId"] as? Int, let tempId = snapval["id"] as? Int, let tempDateString = snapval["dateString"] as? String else { return nil }
//        guard let message = snapval["message"] as? String, let tempImageUrls = snapval["coverPhoto"] as? String, let tempDesc = snapval["description"] as? String else { return nil }
////        self.city = tempCity
////        self.id = tempId
////        self.name = tempName
////        self.keyword = tempKeyword
////        self.coverPhoto = tempCoverPhoto
////        self.description = tempDesc
//    }

    func fsSave() {
        guard let data = try! FirebaseEncoder().encode(self) as? [String: Any] else { return }
        let collection = Firestore.firestore().collection("comments")
        collection.document("\(self.id)").setData(data)
    }
}
