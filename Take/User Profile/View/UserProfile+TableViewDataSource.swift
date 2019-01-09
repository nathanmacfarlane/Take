import Foundation
import UIKit

extension UserProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "UITableViewCell")
        cell.textLabel?.text = routeLists[indexPath.row].name
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "Avenir", size: 18)
        cell.detailTextLabel?.text = routeLists[indexPath.row].detailText
        cell.detailTextLabel?.textColor = .gray
        cell.detailTextLabel?.font = UIFont(name: "Avenir", size: 14)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeLists.count
    }
}
