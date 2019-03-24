import CoreLocation
import FirebaseFirestore
import UIKit

class SearchRoutesVC: UIViewController {

    var myTableView: UITableView!
    var mySearchBar: UISearchBar!

    // Private Models
    struct SearchResults {
        var routes: [Route] = []

        mutating func clear() {
            routes.removeAll()
        }
    }

    // MARK: - Variables
    var results: SearchResults = SearchResults()
    var resultsMashed: [Any] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()

        resultsMashed = []
        results.clear()
        myTableView.reloadData()
        mySearchBar.text = ""

    }

    @objc
    private func goAddNew(sender: UIButton!) {
        let addRouteVC = AddEditRouteVC()
        self.present(addRouteVC, animated: true, completion: nil)
    }

    private func initViews() {
        self.view.backgroundColor = UISettings.shared.colorScheme.backgroundPrimary

        // nav add new button
        let myNavAddNewButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goAddNew))
        myNavAddNewButton.tintColor = UISettings.shared.colorScheme.accent
        self.navigationItem.rightBarButtonItem = myNavAddNewButton

        // search bars
        self.mySearchBar = UISearchBar()
        mySearchBar.delegate = self
        mySearchBar.searchBarStyle = .minimal
        mySearchBar.placeholder = "Ex. Bishop Peak"
        let textFieldInsideSearchBar = mySearchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UISettings.shared.colorScheme.textPrimary

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
