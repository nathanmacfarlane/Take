import UIKit

class PlanTripVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // injections
    var suggestedRoutes: [MPRoute] = []
    var allRoutes: [String] = []
    var sortedSuggestedRoutes: [MPRoute] {
        return suggestedRoutes.sorted { $0.stars ?? 0 > $1.stars ?? 0 }
    }
    //variables
    private var headerHeight: CGFloat = 100
    // outlets
    private var tableView: UITableView!
    private var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }

    @objc
    func hitBack() {
        self.dismiss(animated: true, completion: nil)
    }

    func initViews() {
        view.backgroundColor = UISettings.shared.colorScheme.backgroundPrimary

        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = headerHeight

        backButton = UIButton()
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(hitBack), for: .touchUpInside)
        backButton.titleLabel?.font = UIFont(name: "Avenir", size: 20)
        backButton.setTitleColor(UISettings.shared.colorScheme.accent, for: .normal)

        view.addSubview(tableView)
        view.addSubview(backButton)

        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: backButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: backButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: backButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35).isActive = true
        NSLayoutConstraint(item: backButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 20).isActive = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let percent = 1 - (scrollView.contentOffset.y + 20) / headerHeight
        backButton.alpha = percent
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: headerHeight))
        view.backgroundColor = .clear
        return view
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedSuggestedRoutes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.backgroundColor = .clear

        let route = sortedSuggestedRoutes[indexPath.row]

        cell.textLabel?.text = route.name
        cell.textLabel?.font = UIFont(name: "Avenir-Black", size: 14)
        cell.textLabel?.textColor = .white

        cell.detailTextLabel?.text = "\(route.rating ?? "") \((route.stars ?? 1) - 1)"
        cell.detailTextLabel?.font = UIFont(name: "Avenir-Black", size: 12)
        cell.detailTextLabel?.textColor = .white

        return cell
    }
}
