import Firebase
import FirebaseAuth
import Foundation
import UIKit

extension SearchRoutesVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favoriteAction = UIContextualAction(style: .normal, title: "") { (_: UIContextualAction, _: UIView, success: (Bool) -> Void) in
            print("add \((self.resultsMashed[indexPath.row] as? Route)?.name ?? "") to favorites")
            success(true)
        }
        favoriteAction.image = UIImage(named: "heart.png")
        favoriteAction.backgroundColor = self.view.backgroundColor
        let toDoAction = UIContextualAction(style: .normal, title: "") { (_: UIContextualAction, _: UIView, success: (Bool) -> Void) in
            let db = Firestore.firestore()
            guard let currentUserId = Auth.auth().currentUser?.uid else { return }
            guard let route = self.resultsMashed[indexPath.row] as? Route, let firUser = Auth.auth().currentUser else { return }
            db.query(collection: "users", by: "id", with: firUser.uid, of: User.self) { users in
                guard let user = users.first, let toDoListId = user.toDo.first else { return }
                db.query(collection: "routeLists", by: "id", with: toDoListId, of: RouteList.self) { lists in
                    // TODO: - User should be prompted to add it to a specific list
                    guard var list = lists.first else { return }
                    if !list.containsRoute(routeId: route.id) {
                        if list.routes[currentUserId] == nil {
                            list.routes[currentUserId] = [route.id]
                        } else {
                            list.routes[currentUserId]?.append(route.id)
                        }
                        db.save(object: list, to: "routeLists", with: list.id) {
                            print("save successful")
                        }
                    }
                }
            }
            success(true)
        }
        toDoAction.image = UIImage(named: "icon_plus")
        toDoAction.backgroundColor = self.view.backgroundColor
        return UISwipeActionsConfiguration(actions: [toDoAction])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let anyItem = self.resultsMashed[indexPath.row]
        switch anyItem {
        case is Route:
            guard let theRoute = anyItem as? Route else { return }
            let routeManager = RouteManagerVC()
            routeManager.routeViewModel = RouteViewModel(route: theRoute)
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
            self.navigationController?.pushViewController(routeManager, animated: true)
        default:
            print("not accounted for")
        }
    }

}
