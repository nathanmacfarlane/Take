import Foundation
import UIKit

extension SearchRoutesVC: UITableViewDataSource {

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

    func getRouteCell(route: Route) -> RouteTVC {
        guard let cell: RouteTVC = self.myTableView?.dequeueReusableCell(withIdentifier: "RouteCellTV") as? RouteTVC else { return RouteTVC() }
        let rvm = RouteViewModel(route: route)
        cell.routeViewModel = rvm
        cell.nameLabel.text = rvm.name
        cell.difficultyLabel.text = rvm.rating
        cell.typesLabel.text = rvm.typesString
        DispatchQueue.global(qos: .background).async {
            rvm.fsLoadFirstImage { _, image in
                DispatchQueue.main.async {
                    cell.indicator.stopAnimating()
                    cell.indicator.removeFromSuperview()
                    cell.firstImageView.image = image ?? UIImage(named: "noImages.png")
                }
            }
        }
        return cell
    }
}
