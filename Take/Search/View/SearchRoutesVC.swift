import CoreLocation
import FirebaseFirestore
import InstantSearchClient
import UIKit

class SearchRoutesVC: UIViewController {

    var myTableView: UITableView!
    var mySearchBar: UISearchBar!

    // Private Models
    struct SearchResults {
        var routes: [Route] = []
        var areas: [Area] = []
        var users: [User] = []

        mutating func clear() {
            routes.removeAll()
            areas.removeAll()
            users.removeAll()
        }
    }

    // MARK: - Variables
    var results: SearchResults = SearchResults()
    var resultsMashed: [Any] = []
    let client = Client(appID: Constants.algoliaAppId, apiKey: Constants.algoliaApiKey)

    var firstComments: [Route: Comment] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

//        let params = [MPQueryParam(title: MPQueryTitle.maxDistance, property: "200"),
//                      MPQueryParam(title: MPQueryTitle.minDiff, property: "5.7"),
//                      MPQueryParam(title: MPQueryTitle.maxDiff, property: "5.12"),
//                      MPQueryParam(title: MPQueryTitle.maxResults, property: "500")]
//
//        MPService.shared.getRoutesForLatLon(latitude: 35.3025, longitude: -120.6974, params: params) { routes in
//            for route in routes {
//                print("route: \(route.name)")
//            }
//        }

//        let ids = ["105737480", "112091906", "114940566", "107455632", "106688108", "107677106"]
//        MPService.shared.getRoutes(ids: ids) { routes in
//            for route in routes {
//                print("route: \(route.name)")
//            }
//        }

//        MPService.shared.getUser(email: "josephmmacfarlane@gmail.com") { user in
//            print("user: \(user)")
//        }

//        MPService.shared.getTicks(email: "josephmmacfarlane@gmail.com") { tickList in
//            for tick in tickList.ticks {
//                print("tick: \(tick.date)")
//            }
//        }

//        MPService.shared.getToDos(email: "josephmmacfarlane@gmail.com") { toDoList in
//            print("toDoList: \(toDoList)")
//        }

        initViews()

    }

    @objc
    private func goAddNew(sender: UIButton!) {
        let addRouteVC = AddEditRouteVC()
        self.present(addRouteVC, animated: true, completion: nil)
    }

    @objc
    func showNewAr() {
        self.present(NewArVC(), animated: true, completion: nil)
    }

    private func initViews() {
        self.view.backgroundColor = UISettings.shared.colorScheme.backgroundPrimary

        // nav add new button
        let myNavAddNewButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goAddNew))
        myNavAddNewButton.tintColor = UISettings.shared.colorScheme.accent
        self.navigationItem.rightBarButtonItem = myNavAddNewButton

        // just for testing
        let testButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showNewAr))
        testButton.tintColor = UISettings.shared.colorScheme.accent
        self.navigationItem.leftBarButtonItem = testButton

        // search bars
        self.mySearchBar = UISearchBar()
        mySearchBar.delegate = self
        mySearchBar.searchBarStyle = .minimal
        mySearchBar.placeholder = "Ex. Bishop Peak"
        let textFieldInsideSearchBar = mySearchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UISettings.shared.colorScheme.textPrimary

        // table view
        self.myTableView = UITableView()
        myTableView.register(RouteTVC.self, forCellReuseIdentifier: "RouteTVC")
        myTableView.register(AreaTVC.self, forCellReuseIdentifier: "AreaTVC")
        myTableView.register(MatchTVC.self, forCellReuseIdentifier: "MatchTVC")
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
