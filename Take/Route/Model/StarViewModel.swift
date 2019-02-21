import FirebaseFirestore
import Foundation

class StarViewModel {
    var star: Star!

    var userId: String {
        return star.userId
    }
    var dateString: String {
        guard let date = Double(star.dateString) else { return "" }
        return Date(timeIntervalSince1970: date).monthDayYear(style: "/")
    }
    var value: Double {
        return star.value
    }
    func getUsername(completion: @escaping (_ username: String) -> Void) {
        FirestoreService.shared.fs.query(collection: "users", by: "id", with: self.userId, of: User.self) { user in
            guard let user = user.first else { return }
            let userViewModel = UserViewModel(user: user)
            completion(userViewModel.name)
        }
    }

    init(star: Star) {
        self.star = star
    }
}
