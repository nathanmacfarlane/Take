import Blueprints
import Firebase
import FirebaseAuth
import Foundation
import UIKit

class RouteListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var tableView: UITableView!
    var collectionView: UICollectionView!
    var routes: [String: [Route]] = [:]
    var descriptionValueLabel: UILabel!
    var routeListViewModel: RouteListViewModel!

    var contributors: [String] {
        return Array(routes.keys)
    }

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
        if let currentUser = Auth.auth().currentUser {
            getToDoLists(user: currentUser)
        }
    }

    func getToDoLists(user: Firebase.User) {
        self.descriptionValueLabel.text = routeListViewModel.description
        routeListViewModel.getRoutes { routes in
            self.routes = routes
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.collectionView.reloadData()
            }
        }
    }

    @objc
    func addContributors() {
        
    }

    func initViews() {
        view.backgroundColor = UIColor(named: "BluePrimaryDark")

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContributors))

        self.title = routeListViewModel.name

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
        NSLayoutConstraint(item: contributorsLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 10).isActive = true
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
        Firestore.firestore().query(collection: "users", by: "id", with: contributors[indexPath.row], of: User.self) { user in
            if let user = user.first {
                UserViewModel(user: user).getProfilePhoto { image in
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                }
            }
        }
        return cell
    }

}
