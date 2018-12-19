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
}
