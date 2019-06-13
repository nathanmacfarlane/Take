import Foundation
import UIKit

extension UserProfileVC: UITableViewDataSource {
    
    // Nate had this for plan a day stuff
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "UITableViewCell")
//        cell.textLabel?.text = routeLists[indexPath.row].name
//        cell.textLabel?.textColor = .white
//        cell.textLabel?.font = UIFont(name: "Avenir", size: 18)
//        cell.detailTextLabel?.text = routeLists[indexPath.row].detailText
//        cell.detailTextLabel?.textColor = .gray
//        cell.detailTextLabel?.font = UIFont(name: "Avenir", size: 14)
//        cell.backgroundColor = .clear
//        cell.selectionStyle = .none
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return routeLists.count
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: InfoCell = self.infoTableView.dequeueReusableCell(withIdentifier: "InfoCell") as? InfoCell else { return InfoCell() }
        if seg.selectedSegmentIndex == 0 {
            cell.infoLabel.text = self.info[indexPath.row]
        } else {
            cell.infoLabel.text = self.plans[indexPath.row].title
        }
        cell.infoLabel.textColor = .white
        cell.infoLabel.font = UIFont(name: "Avenir", size: 18)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.infoLabel.isUserInteractionEnabled = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if seg.selectedSegmentIndex == 0 {
            return self.info.count
        } else {
            return self.plans.count
        }
    }
}
