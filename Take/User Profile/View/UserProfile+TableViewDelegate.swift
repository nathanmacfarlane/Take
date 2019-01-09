import Foundation
import UIKit

extension UserProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let routeListVC = RouteListVC()
        routeListVC.user = self.user
        routeListVC.routeListViewModel = routeLists[indexPath.row]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(routeListVC, animated: true)
    }
}
