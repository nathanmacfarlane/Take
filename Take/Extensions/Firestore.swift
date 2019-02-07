import CodableFirebase
import Firebase
import FirebaseFirestore
import Foundation

extension Firestore {
    /// Generic firebase query for classes that conform to Decodable
    /// - Parameters:
    ///   - collection: Name of firebase collection containing desired object(s)
    ///   - field: Query on (ex: name, id, type)
    ///   - value: Variable to query with
    ///   - type: Class type (ex: Route, Comment)
    ///   - completion: Fires when the query is completed
    ///   - results: Array of objects matching the type specified
    func query<T>(collection: String, by field: String, with value: Any, of type: T.Type, completion: @escaping (_ results: [T]) -> Void) where T: Decodable {
        var results: [T] = []
        let decoder = FirebaseDecoder()
        self.query(collection: collection, by: field, with: value) { documents in
            for doc in documents {
                guard let result = try? decoder.decode(T.self, from: doc.data() as Any) else { continue }
                results.append(result)
            }
            completion(results)
        }
    }

    /// Generic firebase save function for classes that conform to Encodable
    /// - Parameters:
    ///   - object: Any type that conforms to Encodable Protocol
    ///   - collection: Name of firebase collection that the object will be saved to
    ///   - title: Document title in collection
    ///   - completion: Optional. Use for notification upon completion of save
    func save<T>(object: T, to collection: String, with title: String, completion: (() -> Void)? ) where T: Encodable {
        guard let data = try? FirebaseEncoder().encode(object) as? [String: Any], let objectData = data else { return }
        Firestore.firestore().collection(collection).document(title).setData(objectData) { _ in
            completion?()
        }
    }
    /// Generic firebase delete function
    /// - Parameters:
    ///   - document: Probably an Id for an object
    ///   - collection: The collection that contains the document to be deleted
    ///   - completion: Optional. Use for notification upon completion of deletion
    func delete(document: String, from collection: String, completion: ((_ success: Bool) -> Void)? ) {
        Firestore.firestore().collection(collection).document(document).delete { err in
            completion?(err != nil)
        }
    }
    /// Generic private internal function used by previous function
    private func query(collection: String, by field: String, with value: Any, completion: @escaping (_ results: [QueryDocumentSnapshot]) -> Void) {
        let settings = self.settings
        settings.areTimestampsInSnapshotsEnabled = true
        self.settings = settings
        self.collection(collection).whereField(field, isEqualTo: value).getDocuments { snapshot, err in
            guard err == nil, let snap = snapshot else { return }
            completion(snap.documents)
        }
    }
}
