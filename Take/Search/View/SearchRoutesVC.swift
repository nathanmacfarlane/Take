import CoreLocation
import FirebaseFirestore
import Fuse
import UIKit

class SearchRoutesVC: UIViewController {

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

    @objc
    private func goAddNew(sender: UIButton!) {
        print("adding new")
    }

    private func initViews() {
        self.view.backgroundColor = UIColor(named: "BluePrimary")

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
        myTableView.register(RouteTVC.self, forCellReuseIdentifier: "RouteCellTV")
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
