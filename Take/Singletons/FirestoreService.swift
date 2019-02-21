import Foundation
import FirebaseFirestore

class FirestoreService {

    static let shared = FirestoreService()
    var fs = Firestore.firestore()

}
