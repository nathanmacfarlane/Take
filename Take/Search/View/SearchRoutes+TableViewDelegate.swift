import Foundation
import UIKit

extension SearchRoutesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favoriteAction = UIContextualAction(style: .normal, title: "") { (_: UIContextualAction, _: UIView, success: (Bool) -> Void) in
            print("add \((self.resultsMashed[indexPath.row] as? Route)?.getName() ?? "") to favorites")
            success(true)
        }
        favoriteAction.image = UIImage(named: "heart.png")
        favoriteAction.backgroundColor = self.view.backgroundColor
        let toDoAction = UIContextualAction(style: .normal, title: "") { (_: UIContextualAction, _: UIView, success: (Bool) -> Void) in
            print("add \((self.resultsMashed[indexPath.row] as? Route)?.getName() ?? "") to to do list")
            success(true)
        }
        toDoAction.image = UIImage(named: "checkmark.png")
        toDoAction.backgroundColor = self.view.backgroundColor
        return UISwipeActionsConfiguration(actions: [toDoAction, favoriteAction])
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
