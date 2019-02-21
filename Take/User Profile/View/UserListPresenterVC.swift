import FirebaseFirestore
import Foundation
import UIKit

class UserListPresenterVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var users: [UserViewModel] = []
    var currentUser: UserViewModel!
    var routeList: RouteList!
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
        for friend in currentUser.user.friends {
            FirestoreService.shared.fs.query(collection: "users", by: "id", with: friend, of: User.self) { user in
                guard let user = user.first else { return }
                self.users.append(UserViewModel(user: user))
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    func initViews() {
        view.backgroundColor = .white

        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        if !routeList.contributors.contains(user.id) && !routeList.invitees.contains(user.id) {
            routeList.invitees.append(user.id)
            FirestoreService.shared.fs.save(object: routeList, to: "routeLists", with: routeList.id) {
                self.dismiss(animated: true, completion: nil)
            }
            let title = "\(user.name) added you to \(routeList.name)"
            let notification = NotificationCollaboration(date: Date(), fromUser: currentUser.id, toUser: user.id, routeListId: routeList.id, title: title)
            FirestoreService.shared.fs.save(object: notification, to: "notifications", with: notification.id, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "UITableViewCell")
        let userViewModel = users[indexPath.row]
        cell.textLabel?.text = userViewModel.name
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont(name: "Avenir", size: 18)
        if routeList.contributors.contains(userViewModel.id) {
            cell.detailTextLabel?.text = "Already a Contributor"
        } else {
            cell.detailTextLabel?.text = userViewModel.username
        }
        cell.detailTextLabel?.textColor = .gray
        cell.detailTextLabel?.font = UIFont(name: "Avenir", size: 14)
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        return cell
    }
}
