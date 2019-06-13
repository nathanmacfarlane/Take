import CodableFirebase
import FirebaseAuth
import FirebaseFirestore
import Foundation
import Presentr

class PlanTripDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // injections
    var plan: DayPlan!

    // ui
    var tableView: UITableView!
    var mapView: GMSMapView!
    var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()

        if let userId = Auth.auth().currentUser?.uid {
            let decoder = FirebaseDecoder()
            Firestore.firestore().collection("plans").whereField("id", isEqualTo: plan.planId).whereField("userId", isEqualTo: userId).addSnapshotListener { snapshot, _ in
                guard let snapshot = snapshot else { return }
                for snap in snapshot.documentChanges where snap.type == .added {
                    guard let userPlan = try? decoder.decode(UserPlanFB.self, from: snap.document.data() as Any) else { return }
                    DispatchQueue.main.async {
                        self.textField.text = userPlan.title
                    }
                }
            }
        }
        
        mapView.centerMap(l1: plan.easy.loc, l2: plan.medium.loc, l3: plan.hard.loc)

        _ = mapView.addMarker(route: plan.easy)
        _ = mapView.addMarker(route: plan.medium)
        _ = mapView.addMarker(route: plan.hard)

        mapView.drawPath(easy: plan.easy, medium: plan.medium, hard: plan.hard) { _ in }

        if let plan = plan, let dist = plan.distance {
            title = "\(dist.rounded(toPlaces: 2)) mi"
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var route: MPRoute?
        switch indexPath.row {
        case 0:
            route = plan.easy
        case 1:
            route = plan.medium
        default:
            route = plan.hard
        }
        guard let r = route else { return }
        let routeManagerVC = RouteManagerVC()
        routeManagerVC.routeViewModel = RouteViewModel(route: Route(mpRoute: r))
        navigationController?.pushViewController(routeManagerVC, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return getRouteCell(route: plan.easy, index: indexPath.row)
        case 1:
            return getRouteCell(route: plan.medium, index: indexPath.row)
        default:
            return getRouteCell(route: plan.hard, index: indexPath.row)
        }
    }

    func getRouteCell(route: MPRoute, index: Int) -> PlanDetailRouteTVC {
        guard let cell: PlanDetailRouteTVC = self.tableView.dequeueReusableCell(withIdentifier: "PlanDetailRouteTVC") as? PlanDetailRouteTVC else { return PlanDetailRouteTVC() }
        let rvm = RouteViewModel(route: Route(mpRoute: route))
        cell.nameLabel.text = rvm.name
        cell.difficultyLabel.text = rvm.rating
        cell.typesLabel.text = rvm.typesString
        cell.firstImageView.image = nil
        cell.widthConst?.constant = 55
        cell.selectionStyle = .none
        cell.numLabel.text = "\(index + 1)"
        return cell
    }

    @objc
    func hitSave() {
        if let userId = Auth.auth().currentUser?.uid {
            let text = textField.text ?? ""
            let userPlan = UserPlanFB(dayPlan: plan, title: text.isEmpty ? Date().monthDayYear(style: "/") : text, userId: userId)
            FirestoreService.shared.fs.save(object: userPlan, to: "plans", with: userPlan.id, completion: nil)
        }
        textField.resignFirstResponder()
    }

    func initViews() {
        view.backgroundColor = UISettings.shared.colorScheme.backgroundPrimary

        textField = UITextField()
        textField.returnKeyType = .done
        textField.textColor = UISettings.shared.colorScheme.textPrimary
        textField.attributedPlaceholder = NSAttributedString(string: Date().monthDayYear(style: "/"), attributes: [NSAttributedString.Key.foregroundColor: UISettings.shared.colorScheme.textSecondary])

        let saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(hitSave), for: .touchUpInside)
        saveButton.setTitleColor(UISettings.shared.colorScheme.accent, for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 17)

        mapView = GMSMapView()
        mapView.isMyLocationEnabled = true
        mapView.layer.cornerRadius = 10
        mapView.clipsToBounds = true

        tableView = UITableView()
        tableView.register(PlanDetailRouteTVC.self, forCellReuseIdentifier: "PlanDetailRouteTVC")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false

        view.addSubview(mapView)
        view.addSubview(tableView)
        view.addSubview(textField)
        view.addSubview(saveButton)

        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: textField, attribute: .trailing, relatedBy: .equal, toItem: saveButton, attribute: .leading, multiplier: 1, constant: -5).isActive = true
        NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35).isActive = true

        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: saveButton, attribute: .leading, relatedBy: .equal, toItem: textField, attribute: .trailing, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -25).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35).isActive = true

        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: textField, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: tableView, attribute: .top, multiplier: 1, constant: -10).isActive = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
    }
}
