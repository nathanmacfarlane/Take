import Firebase
import FirebaseAuth
import Foundation
import UIKit

protocol NotificationPresenterVCDelegate: class {
    func clearedNotification(_ noti: Notification)
    func selectedNotification(_ noti: Notification)
}

class NotificationPresenterVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var user: User!
    var notifications: [Notification] = []
    var tableView: UITableView!
    weak var delegate: NotificationPresenterVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }

    func initViews() {
        view.backgroundColor = .white

        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            self.delegate?.selectedNotification(self.notifications[indexPath.row])
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let clear = UIContextualAction(style: .normal, title: "") { (_: UIContextualAction, _: UIView, success: @escaping (Bool) -> Void) in
            let noti = self.notifications[indexPath.row]
            noti.clear { successful in
                self.notifications.remove(at: indexPath.row)
                self.tableView.reloadData()
                self.delegate?.clearedNotification(noti)
                success(successful)
            }
        }
        clear.image = UIImage(named: "icon_clear")
        clear.backgroundColor = UIColor(named: "PinkAccent")
        return UISwipeActionsConfiguration(actions: [clear])
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "UITableViewCell")
        let noti = notifications[indexPath.row]
        let date = Date(timeIntervalSince1970: noti.date)
        cell.textLabel?.text = noti.title
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont(name: "Avenir", size: 18)
        cell.detailTextLabel?.text = date.monthDayYearHour()
        cell.detailTextLabel?.textColor = .gray
        cell.detailTextLabel?.font = UIFont(name: "Avenir", size: 14)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
}
