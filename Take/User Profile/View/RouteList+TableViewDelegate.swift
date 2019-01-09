import Firebase
import Foundation
import UIKit

extension RouteListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let theRoute = cellRoutes[indexPath.row].route
        let routeManager = RouteManagerVC()
        routeManager.routeViewModel = RouteViewModel(route: theRoute)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(routeManager, animated: true)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let toDoAction = UIContextualAction(style: .normal, title: "") { (_: UIContextualAction, _: UIView, success: (Bool) -> Void) in
            let route = self.cellRoutes[indexPath.row].route
            self.routeListViewModel.removeRoute(user: self.user, route: route) { _ in
                DispatchQueue.main.async {
                    var userRoutes = self.routes[self.user.id] ?? []
                    userRoutes = userRoutes.filter { $0.id != route.id }
                    self.routes[self.user.id] = userRoutes
                    self.tableView.reloadData()
                }
            }
            success(true)
        }
        toDoAction.image = UIImage(named: "icon_clear")
        toDoAction.backgroundColor = view.backgroundColor
        return UISwipeActionsConfiguration(actions: [toDoAction])
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return cellRoutes[indexPath.row].owner == user.id
    }
}
