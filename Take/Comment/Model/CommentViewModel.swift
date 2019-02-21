import CodableFirebase
import Firebase
import FirebaseFirestore
import Foundation

class CommentViewModel {
    var comment: Comment!
    var id: String {
        return self.comment.id
    }
    var userId: String {
        return self.comment.userId
    }
    var dateString: String {
        guard let date = Double(self.comment.dateString) else { return "" }
        return Date(timeIntervalSince1970: date).monthDayYear(style: "/")
    }
    var message: String {
        return self.comment.message ?? "N/A"
    }
    var imageUrl: String? {
        return self.comment.imageUrl
    }
    func getUsername(completion: @escaping (_ username: String) -> Void) {
        FirestoreService.shared.fs.query(collection: "users", by: "id", with: self.userId, of: User.self) { user in
            guard let user = user.first else { return }
            let userViewModel = UserViewModel(user: user)
            completion(userViewModel.name)
        }
    }
    func getImage(completion: @escaping (_ image: UIImage?) -> Void) {
        guard let imageUrl = self.imageUrl, let theURL = URL(string: imageUrl) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: theURL) { data, _, _ in
            guard let theData = data, let theImage = UIImage(data: theData) else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(theImage)
            }
        }
        .resume()
    }
    init(comment: Comment) {
        self.comment = comment
    }
}
