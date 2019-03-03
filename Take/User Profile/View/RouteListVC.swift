import Blueprints
import FirebaseFirestore
import FirebaseAuth
import Foundation
import Presentr
import UIKit

class RouteListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var tableView: UITableView!
    var collectionView: UICollectionView!
    var routes: [String: [Route]] = [:]
    var descriptionValueLabel: UILabel!
    var routeListViewModel: RouteListViewModel!
    var contributors: [User] = []
    var inviteView: UIView!
    var user: User!
    var notification: NotificationCollaboration?
    var inviteViewConstraint: NSLayoutConstraint!

    var cellRoutes: [OwnerRoute] {
        var temp: [OwnerRoute] = []
        for userId in routes.keys {
            for route in routes[userId] ?? [] {
                temp.append(OwnerRoute(owner: userId, route: route))
            }
        }
        return temp
    }

    struct OwnerRoute {
        var owner: String
        var route: Route
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()

        tableView.reloadData()
        getToDoLists()
    }

    func getToDoLists() {
        self.descriptionValueLabel.text = routeListViewModel.description
        routeListViewModel.getRoutes { routes in
            self.routes = routes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        routeListViewModel.getContributors { contributors in
            self.contributors = contributors
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    @objc
    func addContributors() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let presenter: Presentr = {
            let customPresenter = Presentr(presentationType: .bottomHalf)
            customPresenter.transitionType = .coverVertical
            customPresenter.dismissTransitionType = .crossDissolve
            customPresenter.roundCorners = true
            customPresenter.cornerRadius = 15
            customPresenter.backgroundColor = .white
            customPresenter.backgroundOpacity = 0.5
            return customPresenter
        }()
        FirestoreService.shared.fs.query(collection: "users", by: "id", with: userId, of: User.self) { user in
            guard let user = user.first else { return }
            let uspvc = UserListPresenterVC()
            uspvc.currentUser = UserViewModel(user: user)
            uspvc.routeList = self.routeListViewModel.routeList
            self.customPresentViewController(presenter, viewController: uspvc, animated: true)
        }
    }

    @objc
    func accept() {
        var invitees = routeListViewModel.routeList.invitees
        invitees = removeUser(user: self.user, list: invitees)
        routeListViewModel.routeList.invitees = invitees
        routeListViewModel.routeList.contributors.append(user.id)
        FirestoreService.shared.fs.save(object: routeListViewModel.routeList, to: "routeLists", with: routeListViewModel.id) {
            self.inviteViewConstraint.constant = 0.0
            if let noti = self.notification {
                FirestoreService.shared.fs.delete(document: noti.id, from: "notifications", completion: nil)
            }
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
            self.routeListViewModel.getContributors { contributors in
                self.contributors = contributors
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        user.toDo.append(routeListViewModel.id)
        FirestoreService.shared.fs.save(object: user, to: "users", with: user.id, completion: nil)
    }

    @objc
    func decline() {
        var invitees = routeListViewModel.routeList.invitees
        invitees = removeUser(user: self.user, list: invitees)
        routeListViewModel.routeList.invitees = invitees
        FirestoreService.shared.fs.save(object: routeListViewModel.routeList, to: "routeLists", with: routeListViewModel.id) {
            self.inviteViewConstraint.constant = 0.0
            if let noti = self.notification {
                FirestoreService.shared.fs.delete(document: noti.id, from: "notifications", completion: nil)
            }
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }

    func removeUser(user: User, list: [String]) -> [String] {
        var invitees = list
        var index = 0
        for invitee in invitees {
            if invitee == user.id {
                invitees.remove(at: index)
                break
            }
            index += 1
        }
        return invitees
    }

    func initInviteView() {
        inviteView = UIView()
        inviteView.backgroundColor = .black
        inviteView.clipsToBounds = true
        view.addSubview(inviteView)

        let inviteLabel = UILabel()
        inviteLabel.text = "You've been invited by ..."
        inviteLabel.font = UIFont(name: "Avenir-Black", size: 20)
        inviteLabel.textColor = .gray
        inviteLabel.textAlignment = .center

        if let noti = self.notification {
            FirestoreService.shared.fs.query(collection: "users", by: "id", with: noti.fromUser, of: User.self) { user in
                guard let user = user.first else { return }
                inviteLabel.text = "You've been invited by \(user.name)"
            }
        } else {
            FirestoreService.shared.fs.query(collection: "notifications", by: "toUser", with: self.user.id, of: NotificationCollaboration.self) { noti in
                guard let noti = noti.first else { return }
                FirestoreService.shared.fs.query(collection: "users", by: "id", with: noti.fromUser, of: User.self) { user in
                    guard let user = user.first else { return }
                    inviteLabel.text = "You've been invited by \(user.name)"
                }
            }
        }

        let acceptButton = UIButton()
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 20)
        acceptButton.setTitleColor(UIColor(named: "PinkAccent"), for: .normal)
        acceptButton.addTarget(self, action: #selector(accept), for: .touchUpInside)

        let declineButton = UIButton()
        declineButton.setTitle("Decline", for: .normal)
        declineButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 20)
        declineButton.setTitleColor(UIColor(named: "PinkAccent"), for: .normal)
        declineButton.addTarget(self, action: #selector(decline), for: .touchUpInside)

        inviteView.addSubview(inviteLabel)
        inviteView.addSubview(acceptButton)
        inviteView.addSubview(declineButton)

        inviteView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: inviteView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: inviteView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: inviteView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        inviteViewConstraint = NSLayoutConstraint(item: inviteView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 90)
        inviteViewConstraint.isActive = true

        inviteLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: inviteLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: inviteLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: inviteLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: inviteLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true

        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: acceptButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: acceptButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: acceptButton, attribute: .top, relatedBy: .equal, toItem: inviteLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: acceptButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true

        declineButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: declineButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: declineButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: declineButton, attribute: .top, relatedBy: .equal, toItem: inviteLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: declineButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true

    }

    func initViews() {
        view.backgroundColor = UIColor(named: "BluePrimaryDark")

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContributors))

        self.title = routeListViewModel.name

        if routeListViewModel.routeList.invitees.contains(user.id) {
            initInviteView()
        }

        let contributorsLabel = UILabel()
        contributorsLabel.text = "Contributors"
        contributorsLabel.font = UIFont(name: "Avenir-Black", size: 20)
        contributorsLabel.textColor = .gray

        // contributors list
        let horizontalLayout = HorizontalBlueprintLayout(
            itemsPerRow: view.frame.width / 100.0,
            itemSize: CGSize(width: 80, height: 80),
            minimumInteritemSpacing: 10,
            minimumLineSpacing: 10,
            sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: horizontalLayout)
        collectionView.register(RouteListUserCVC.self, forCellWithReuseIdentifier: "RouteListUserCVC")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false

        let descriptionLabel = UILabel()
        descriptionLabel.text = "Description"
        descriptionLabel.font = UIFont(name: "Avenir-Black", size: 20)
        descriptionLabel.textColor = .gray

        descriptionValueLabel = UILabel()
        descriptionValueLabel.numberOfLines = 0
        descriptionValueLabel.font = UIFont(name: "Avenir", size: 15)
        descriptionValueLabel.textColor = .white

        let routesLabel = UILabel()
        routesLabel.text = "Routes"
        routesLabel.font = UIFont(name: "Avenir-Black", size: 20)
        routesLabel.textColor = .gray

        // todo lists
        tableView = UITableView()
        tableView.register(RouteListTVC.self, forCellReuseIdentifier: "RouteListTVC")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(contributorsLabel)
        view.addSubview(collectionView)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionValueLabel)
        view.addSubview(routesLabel)
        view.addSubview(tableView)

        contributorsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: contributorsLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: contributorsLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        if routeListViewModel.routeList.invitees.contains(user.id) {
            NSLayoutConstraint(item: contributorsLabel, attribute: .top, relatedBy: .equal, toItem: inviteView, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        } else {
            NSLayoutConstraint(item: contributorsLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 10).isActive = true
        }
        NSLayoutConstraint(item: contributorsLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: contributorsLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: descriptionLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: descriptionLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: descriptionLabel, attribute: .top, relatedBy: .equal, toItem: collectionView, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: descriptionLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true

        descriptionValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: descriptionValueLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: descriptionValueLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: descriptionValueLabel, attribute: .top, relatedBy: .equal, toItem: descriptionLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true

        routesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: routesLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: routesLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: routesLabel, attribute: .top, relatedBy: .equal, toItem: descriptionValueLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: routesLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: routesLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contributors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RouteListUserCVC", for: indexPath) as? RouteListUserCVC else { return UICollectionViewCell() }
        UserViewModel(user: contributors[indexPath.row]).getProfilePhoto { image in
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        }
        return cell
    }

}
