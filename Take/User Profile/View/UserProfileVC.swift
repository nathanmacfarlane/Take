import Firebase
import FirebaseAuth
import Foundation
import Presentr
import UIKit
class UserProfileVC: UIViewController, NotificationPresenterVCDelegate {

    var user: User?
    var routeLists: [RouteListViewModel] = []
    var notifications: [Notification] = []

    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        routeLists = []
        if let currentUser = Auth.auth().currentUser {
            getToDoLists(user: currentUser)
        }
    }

    func getToDoLists(user: Firebase.User) {
        let db = Firestore.firestore()
        db.query(collection: "users", by: "id", with: user.uid, of: User.self) { user in
            guard let user = user.first else { return }
            self.user = user
            for routeListId in user.toDo {
                db.query(collection: "routeLists", by: "id", with: routeListId, of: RouteList.self) { routeList in
                    guard let routeList = routeList.first else { return }
                    self.routeLists.append(RouteListViewModel(routeList: routeList))
                    self.tableView.reloadData()
                }
            }
            let userViewModel = UserViewModel(user: user)
            userViewModel.getNotifications { notifications in
                self.notifications = notifications
                if !notifications.isEmpty {
                    self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "PinkAccent")
                } else {
                    self.navigationItem.rightBarButtonItem?.tintColor = .white
                }
            }
        }
    }

    func clearedNotification(_ noti: Notification) {
        var index = 0
        for notification in notifications {
            if notification.id == noti.id {
                notifications.remove(at: index)
                if notifications.isEmpty {
                    self.navigationItem.rightBarButtonItem?.tintColor = .white
                }
                return
            }
            index += 1
        }
    }

    func selectedNotification(_ noti: Notification) {
        if let noti = noti as? NotificationCollaboration {
            Firestore.firestore().query(collection: "routeLists", by: "id", with: noti.routeListId, of: RouteList.self) { routeList in
                guard let routeList = routeList.first else { return }
                let routeListVC = RouteListVC()
                routeListVC.user = self.user
                routeListVC.notification = noti
                routeListVC.routeListViewModel = RouteListViewModel(routeList: routeList)
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
                self.navigationController?.pushViewController(routeListVC, animated: true)
            }
        }
    }

    @objc
    private func goLogout(sender: UIButton!) {
        try? Auth.auth().signOut()
        self.present(LoginVC(), animated: true, completion: nil)
    }

    @objc
    func notiSelected() {
        guard let user = self.user else { return }
        let presenter: Presentr = {
            let customPresenter = Presentr(presentationType: .topHalf)
            customPresenter.transitionType = .coverVerticalFromTop
            customPresenter.dismissTransitionType = .crossDissolve
            customPresenter.roundCorners = true
            customPresenter.cornerRadius = 15
            customPresenter.backgroundColor = .white
            customPresenter.backgroundOpacity = 0.5
            return customPresenter
        }()
        let npvc = NotificationPresenterVC()
        npvc.delegate = self
        npvc.user = user
        npvc.notifications = self.notifications
        self.customPresentViewController(presenter, viewController: npvc, animated: true)
    }

    func initViews() {
        view.backgroundColor = UIColor(named: "BluePrimaryDark")

        // nav logout button
        let myNavLogoutButton = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(goLogout))
        myNavLogoutButton.tintColor = UIColor(named: "PinkAccent")
        self.navigationItem.leftBarButtonItem = myNavLogoutButton

        // nav noti button
        let notiIcon = UIImage(named: "notification")
        let notiIconButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(notiSelected))
        notiIconButton.image = notiIcon
        notiIconButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = notiIconButton

        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200).isActive = true
    }
}
