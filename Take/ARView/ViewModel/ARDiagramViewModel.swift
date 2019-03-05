import Foundation

class ARDiagramViewModel {
    var arDiagram: ARDiagram
    var id: String {
        return self.arDiagram.id
    }
    var userId: String {
        return self.arDiagram.userId
    }
    var dateString: String {
        guard let date = Double(self.arDiagram.dateString) else { return "" }
        return Date(timeIntervalSince1970: date).monthDayYear(style: "/")
    }
    var message: String {
        return self.arDiagram.message
    }
    var dgImageUrl: String {
        return self.arDiagram.dgImageUrl
    }

    var bgImageUrl: String {
        return self.arDiagram.bgImageUrl
    }
    func getUsername(completion: @escaping (_ username: String) -> Void) {
        FirestoreService.shared.fs.query(collection: "users", by: "id", with: self.userId, of: User.self) { user in
            guard let user = user.first else { return }
            let userViewModel = UserViewModel(user: user)
            completion(userViewModel.name)
        }
    }
    init(arDiagram: ARDiagram) {
        self.arDiagram = arDiagram
    }
}
