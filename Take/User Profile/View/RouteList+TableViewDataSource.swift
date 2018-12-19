import Firebase
import Foundation
import UIKit

extension RouteListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RouteListTVC") as? RouteListTVC else { return UITableViewCell() }
        let rvm = RouteViewModel(route: cellRoutes[indexPath.row].route)
        cell.nameLabel.text = rvm.name
        cell.difficultyLabel.text = rvm.rating
        cell.typesLabel.text = rvm.typesString
        cell.selectionStyle = .none
        Firestore.firestore().query(collection: "users", by: "id", with: cellRoutes[indexPath.row].owner, of: User.self) { user in
            if let user = user.first {
                let userViewModel = UserViewModel(user: user)
                userViewModel.getProfilePhoto { image in
                    DispatchQueue.main.async {
                        cell.ownerPhoto.image = image
                    }
                }
            }
        }
        return cell
    }
}
