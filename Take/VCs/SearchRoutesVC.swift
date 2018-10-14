import CoreLocation
import FirebaseAuth
import FirebaseFirestore
import UIKit

class SearchRoutesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {

    var myTableView: UITableView!
    var mySearchBar: UISearchBar!

    // Private Models
    struct SearchResults {
        var walls: [String] = []
        var areas: [String] = []
        var cities: [String] = []
        var routes: [Route] = []

        mutating func clear() {
            self.walls.removeAll()
            self.areas.removeAll()
            self.routes.removeAll()
        }
    }

    // MARK: - Variables
    private let myArray: NSArray = ["First", "Second", "Third"]
    let locationManager: CLLocationManager = CLLocationManager()
    var userCurrentLocation: CLLocation?
    var results: SearchResults = SearchResults()
    var resultsMashed: [Any] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initViews()

        self.resultsMashed = []
        self.results.clear()
        self.myTableView.reloadData()
        self.mySearchBar.text = ""

        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                self.present(LoginVC(), animated: true, completion: nil)
            }
        }

        setupLocations()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    // MARK: - Functions
    func setupLocations() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    // MARK: - SearchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.results.clear()
        self.resultsMashed.removeAll()
        self.myTableView.reloadData()

        self.mySearchBar.resignFirstResponder()

        guard let searchText = searchBar.text else { return }
        let db = Firestore.firestore()
        db.query(type: Route.self, by: "name", with: searchText) { routes in
            self.resultsMashed.append(contentsOf: routes)
            self.results.routes.append(contentsOf: routes)
            self.myTableView.reloadData()
        }
        db.query(type: Route.self, by: "keyword", with: searchText) { routes in
            self.resultsMashed.append(contentsOf: routes)
            self.results.routes.append(contentsOf: routes)
            self.myTableView.reloadData()
        }
        db.query(type: Area.self, by: "name", with: searchText) { areas in
            self.resultsMashed.append(contentsOf: areas)
            for area in areas {
                self.results.areas.append(area.name)
            }
            self.myTableView.reloadData()
        }
        db.query(type: Area.self, by: "keyword", with: searchText) { areas in
            self.resultsMashed.append(contentsOf: areas)
            for area in areas {
                self.results.areas.append(area.name)
            }
            self.myTableView.reloadData()
        }
    }

    // MARK: - LocationManager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        userCurrentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favoriteAction = UIContextualAction(style: .normal, title: "") { (_: UIContextualAction, _: UIView, success: (Bool) -> Void) in
            print("add \((self.resultsMashed[indexPath.row] as? Route)?.name ?? "") to favorites")
            success(true)
        }
        favoriteAction.image = UIImage(named: "heart.png")
        favoriteAction.backgroundColor = self.view.backgroundColor
        let toDoAction = UIContextualAction(style: .normal, title: "") { (_: UIContextualAction, _: UIView, success: (Bool) -> Void) in
            print("add \((self.resultsMashed[indexPath.row] as? Route)?.name ?? "") to to do list")
            success(true)
        }
        toDoAction.image = UIImage(named: "checkmark.png")
        toDoAction.backgroundColor = self.view.backgroundColor
        return UISwipeActionsConfiguration(actions: [toDoAction, favoriteAction])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let anyItem = self.resultsMashed[indexPath.row]
        switch anyItem {
        case is Route:
            guard let theRoute = anyItem as? Route else { return }
            let routeDetailVC = RouteDetailVC()
            routeDetailVC.route = theRoute
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
            self.navigationController?.pushViewController(routeDetailVC, animated: true)
        default:
            print("not accounted for")
        }
    }
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WallCell") as? WallCell else { return UITableViewCell() }
            cell.setWallLabel(with: "NOT IMPLEMENTED YET")
            return cell
        }
    }
    func getRouteCell(route: Route) -> RouteCellTV {
        guard let cell: RouteCellTV = self.myTableView?.dequeueReusableCell(withIdentifier: "RouteCellTV") as? RouteCellTV else { return RouteCellTV() }
        cell.route = route
        cell.initFields()
        return cell
    }

    @objc
    private func goLogout(sender: UIButton!) {
        try! Auth.auth().signOut()
        self.present(LoginVC(), animated: true, completion: nil)
    }

    @objc
    private func goAddNew(sender: UIButton!) {
        print("adding new")
    }

    private func initViews() {
        self.view.backgroundColor = UIColor(named: "BluePrimary")

        self.title = "Search Routes"
        self.navigationController?.navigationBar.titleTextAttributes =
            [.foregroundColor: UIColor(named: "Placeholder") ?? .white,
             .font: UIFont(name: "Avenir-Black", size: 26) ?? .systemFont(ofSize: 26)]

        // nav logout button
        let myNavLogoutButton = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(goLogout))
        myNavLogoutButton.tintColor = UIColor(named: "PinkAccent")
        self.navigationItem.leftBarButtonItem = myNavLogoutButton

        // nav add new button
        let myNavAddNewButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goAddNew))
        myNavAddNewButton.tintColor = UIColor(named: "PinkAccent")
        self.navigationItem.rightBarButtonItem = myNavAddNewButton

        // search bars
        self.mySearchBar = UISearchBar()
        mySearchBar.delegate = self
        mySearchBar.searchBarStyle = .minimal
        mySearchBar.placeholder = "Ex. Bishop Peak"
        let textFieldInsideSearchBar = mySearchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white

        // table view
        self.myTableView = UITableView()
        myTableView.register(RouteCellTV.self, forCellReuseIdentifier: "RouteCellTV")
        myTableView.backgroundColor = .clear
        myTableView.separatorStyle = .none
        myTableView.dataSource = self
        myTableView.delegate = self

        self.view.addSubview(mySearchBar)
        self.view.addSubview(myTableView)

        mySearchBar.translatesAutoresizingMaskIntoConstraints = false
        let searchBarTopConst = NSLayoutConstraint(item: mySearchBar, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 15)
        let searchBarLeadingConst = NSLayoutConstraint(item: mySearchBar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let searchBarTrialingConst = NSLayoutConstraint(item: mySearchBar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([searchBarTopConst, searchBarLeadingConst, searchBarTrialingConst])

        myTableView.translatesAutoresizingMaskIntoConstraints = false
        let tvTopConstraint = NSLayoutConstraint(item: myTableView, attribute: .top, relatedBy: .equal, toItem: mySearchBar, attribute: .bottom, multiplier: 1, constant: 0)
        let tvBottomConstraint = NSLayoutConstraint(item: myTableView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -20)
        let tvLeadingConstraint = NSLayoutConstraint(item: myTableView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 10)
        let tvTrailingConstraint = NSLayoutConstraint(item: myTableView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -10)
        NSLayoutConstraint.activate([tvTopConstraint, tvBottomConstraint, tvLeadingConstraint, tvTrailingConstraint])
    }

}
