import Foundation
import UIKit

extension UserProfileVC: UITableViewDelegate {
    // Nate had this for plan a day stuff
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let routeListVC = RouteListVC()
//        routeListVC.user = self.user
//        routeListVC.routeListViewModel = routeLists[indexPath.row]
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
//        self.navigationController?.pushViewController(routeListVC, animated: true)
//    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
