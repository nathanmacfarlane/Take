import Foundation
import UIKit

class PlanTripEditVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ToggledEditRouteDelegate {

    var easyOn: [Int: Bool] = [:]
    var mediumOn: [Int: Bool] = [:]
    var hardOn: [Int: Bool] = [:]

    var allRoutes: [MPRoute] = []

    var segControl: UISegmentedControl!
    var tableView: UITableView!

    var delegate: PlanEditDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        delegate?.toggledRoutes(easyOn: easyOn, mediumOn: mediumOn, hardOn: hardOn)
    }

    func getArr(index: Int) -> [MPRoute] {
        switch index {
        case 0:
            let keys = Array(easyOn.keys)
            return allRoutes.filter { keys.contains($0.id) }
        case 1:
            let keys = Array(mediumOn.keys)
            return allRoutes.filter { keys.contains($0.id) }
        default:
            let keys = Array(hardOn.keys)
            return allRoutes.filter { keys.contains($0.id) }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let selected = segControl.selectedSegmentIndex
        return getArr(index: selected).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selected = segControl.selectedSegmentIndex
        return getRouteCell(route: getArr(index: selected)[indexPath.row])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    func getRouteCell(route: MPRoute) -> PlanEditRouteTVC {
        guard let cell: PlanEditRouteTVC = self.tableView.dequeueReusableCell(withIdentifier: "PlanEditRouteTVC") as? PlanEditRouteTVC else { return PlanEditRouteTVC() }
        let rvm = RouteViewModel(route: Route(mpRoute: route))
        cell.mpRoute = route
        cell.nameLabel.text = rvm.name
        cell.difficultyLabel.text = rvm.rating
        cell.typesLabel.text = rvm.typesString
        cell.firstImageView.image = nil
        cell.widthConst?.constant = 75
        cell.selectionStyle = .none
        cell.delegate = self

        switch segControl.selectedSegmentIndex {
        case 0:
            cell.toggler.isOn = easyOn[route.id] ?? false
        case 1:
            cell.toggler.isOn = mediumOn[route.id] ?? false
        default:
            cell.toggler.isOn = hardOn[route.id] ?? false
        }

        return cell
    }

    func toggledEditRoute(routeId: Int, isOn: Bool) {
        if easyOn[routeId] != nil {
            easyOn[routeId] = isOn
        } else if mediumOn[routeId] != nil {
            mediumOn[routeId] = isOn
        } else if hardOn[routeId] != nil {
            hardOn[routeId] = isOn
        }
    }

    @objc
    func changedSeg() {
        tableView.reloadData()
    }

    func initViews() {
        view.backgroundColor = UISettings.shared.colorScheme.backgroundPrimary

        segControl = UISegmentedControl(items: ["Warmup", "Just Right", "Project"])
        segControl.addTarget(self, action: #selector(changedSeg), for: .valueChanged)
        segControl.selectedSegmentIndex = 0
        segControl.tintColor = UISettings.shared.colorScheme.accent

        tableView = UITableView()
        tableView.register(PlanEditRouteTVC.self, forCellReuseIdentifier: "PlanEditRouteTVC")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        view.addSubview(segControl)
        view.addSubview(tableView)

        segControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: segControl, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: segControl, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: segControl, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 20).isActive = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: segControl, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: segControl, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: segControl, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -20).isActive = true
    }
}

protocol PlanEditDelegate: class {
    func toggledRoutes(easyOn: [Int: Bool], mediumOn: [Int: Bool], hardOn: [Int: Bool])
}
