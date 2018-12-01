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
    var imageUrl: String?

    func fsSave() {
        guard let data = try! FirebaseEncoder().encode(self) as? [String: Any] else { return }
        let collection = Firestore.firestore().collection("comments")
        collection.document("\(self.id)").setData(data)
    }
}
