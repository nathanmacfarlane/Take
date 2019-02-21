import FirebaseFirestore
import Foundation
import UIKit

struct UserViewModel {

    var user: User
    var id: String
    var name: String
    var username: String?

    init(user: User) {
        self.user = user
        self.id = user.id
        self.name = user.name
        self.username = user.username
    }

    func getProfilePhoto(completion: @escaping (_ image: UIImage) -> Void) {
        guard let userImageString = user.profilePhotoUrl, let userImageUrl = URL(string: userImageString) else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: userImageUrl)) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            completion(image)
        }
        task.resume()
    }
    
    func getNotifications(completion: @escaping (_ notification: [NotificationCollaboration]) -> Void) {
        FirestoreService.shared.fs.query(collection: "notifications", by: "toUser", with: id, of: NotificationCollaboration.self) { notifications in
            completion(notifications)
        }
    }
}
