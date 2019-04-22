import Firebase
import FirebaseAuth
import Foundation
import Presentr
import UIKit

extension SearchRoutesVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let toDoAction = UIContextualAction(style: .normal, title: "") { (_: UIContextualAction, _: UIView, success: (Bool) -> Void) in
            let presenter: Presentr = {
                let customPresenter = Presentr(presentationType: .bottomHalf)
                customPresenter.transitionType = .coverVertical
                customPresenter.dismissTransitionType = .crossDissolve
                customPresenter.roundCorners = true
                customPresenter.cornerRadius = 15
                customPresenter.backgroundColor = .white
                customPresenter.backgroundOpacity = 0.5
                return customPresenter
            }()
            let rlpvc = RouteListPresenterVC()
            guard let route = self.resultsMashed[indexPath.row] as? Route else { return }
            rlpvc.route = route
            self.customPresentViewController(presenter, viewController: rlpvc, animated: true)
            success(true)   
        }
        toDoAction.image = UIImage(named: "icon_plus")
        toDoAction.backgroundColor = view.backgroundColor
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
