import Foundation
import UIKit

extension SearchRoutesVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultsMashed.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let anyItem = self.resultsMashed[indexPath.row]
        switch self.resultsMashed[indexPath.row] {
        case is Route: 
            guard let theRoute = anyItem as? Route else { return UITableViewCell() }
            return getRouteCell(route: theRoute)
        case is Area:
            guard let theArea = anyItem as? Area else { return UITableViewCell() }
            return getAreaCell(area: theArea)
        default:
            return UITableViewCell()
        }
    }

    func getRouteCell(route: Route) -> RouteTVC {
        guard let cell: RouteTVC = self.myTableView.dequeueReusableCell(withIdentifier: "RouteTVC") as? RouteTVC else { return RouteTVC() }
        let rvm = RouteViewModel(route: route)
        cell.nameLabel.text = rvm.name
        cell.difficultyLabel.text = rvm.rating
        cell.typesLabel.text = rvm.typesString
        cell.firstImageView.image = nil
        cell.selectionStyle = .none
        if let comment = firstComments[route], let url = comment.imageUrl {
            ImageCache.shared.getImage(for: url) { image in
                DispatchQueue.main.async {
                    cell.setImage(image: image)
                }
            }
        } else {
            cell.widthConst?.constant = 0
            DispatchQueue.global(qos: .background).async {
                FirestoreService.shared.fs.query(collection: "comments", by: "routeId", with: route.id, of: Comment.self, and: 1) { comment in
                    guard let comment = comment.first else { return }
                    self.firstComments[route] = comment
                    comment.imageUrl?.getImage { image in
                        cell.setImage(image: image)
                    }
                }
            }
        }
        return cell
    }

    func getAreaCell(area: Area) -> AreaTVC {
        guard let cell: AreaTVC = self.myTableView?.dequeueReusableCell(withIdentifier: "AreaTVC") as? AreaTVC else { return AreaTVC() }
        let avm = AreaViewModel(area: area)
        cell.nameLabel.text = avm.name
        cell.selectionStyle = .none
        avm.cityAndState { city, state in
            DispatchQueue.main.async {
                cell.difficultyLabel.text = "\(city), \(state)"
            }
        }
        cell.typesLabel.text = avm.latAndLongString
        if let url = avm.area.imageUrl {
            DispatchQueue.global(qos: .background).async {
                ImageCache.shared.getImage(for: url) { image in
                    DispatchQueue.main.async {
                        cell.indicator.stopAnimating()
                        cell.indicator.removeFromSuperview()
                        cell.firstImageView.image = image ?? UIImage(named: "noImages.png")
                    }
                }
            }
        }
        return cell
    }
}
