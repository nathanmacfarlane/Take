import Foundation
import UIKit

extension SearchRoutesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultsMashed.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let anyItem = self.resultsMashed[indexPath.row]
        switch self.resultsMashed[indexPath.row] {
        case is Route:
            guard let theRoute = anyItem as? Route else { return UITableViewCell() }
            return getRouteCell(route: theRoute)
        default:
            return UITableViewCell()
        }
    }

    func getRouteCell(route: Route) -> RouteTableViewCell {
        guard let cell: RouteTableViewCell = self.myTableView?.dequeueReusableCell(withIdentifier: "RouteCellTV") as? RouteTableViewCell else { return RouteTableViewCell() }
        cell.routeViewModel = RouteViewModel(route: route)
        cell.initFields()
        return cell
    }
}
