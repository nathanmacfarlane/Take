import FirebaseFirestore
import FirebaseAuth
import Foundation
import Presentr
import UIKit

class RouteListPresenterVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var route: Route!
    var routeLists: [RouteListViewModel] = []
    var currentUser: User!
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()

        getLists()
    }

    func initViews() {
        view.backgroundColor = .white

        tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }

    func getLists() {
        guard let firUser = Auth.auth().currentUser else { return }
        FirestoreService.shared.fs.query(collection: "users", by: "id", with: firUser.uid, of: User.self) { users in
            guard let user = users.first, let toDoListId = user.toDo.first else { return }
            self.currentUser = user
            FirestoreService.shared.fs.query(collection: "routeLists", by: "id", with: toDoListId, of: RouteList.self) { lists in
                self.routeLists = lists.map { rl -> RouteListViewModel in
                    RouteListViewModel(routeList: rl)
                }
                self.tableView.reloadData()
                // TODO: - User should be prompted to add it to a specific list
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var list = routeLists[indexPath.row].routeList
        if !list.containsRoute(routeId: self.route.id) {
            if list.routes[currentUser.id] == nil {
                list.routes[currentUser.id] = [self.route.id]
            } else {
                list.routes[currentUser.id]?.append(self.route.id)
            }
            FirestoreService.shared.fs.save(object: list, to: "routeLists", with: list.id) {
                print("save successful")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeLists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "UITableViewCell")
        let listViewModel = routeLists[indexPath.row]
        cell.textLabel?.text = listViewModel.name
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont(name: "Avenir", size: 18)
        if listViewModel.routeList.containsRoute(routeId: self.route.id) {
            cell.detailTextLabel?.text = "Already on the list"
        } else {
            cell.detailTextLabel?.text = listViewModel.detailText
        }
        cell.detailTextLabel?.textColor = .gray
        cell.detailTextLabel?.font = UIFont(name: "Avenir", size: 14)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }

}
