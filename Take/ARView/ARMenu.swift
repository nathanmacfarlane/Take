import CodableFirebase
import FirebaseFirestore
import Geofirestore
import MapKit
import UIKit

class ARMenu: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!

    let meters = 1.0
    var routeViewModels: [RouteViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        initViews()

        let geoFirestoreRef = Firestore.firestore().collection("route-geos")
        let geoFirestore = GeoFirestore(collectionRef: geoFirestoreRef)

        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways {
            if let location = locManager.location {
                print("location: \(location)")
                let circleQuery = geoFirestore.query(withCenter: location, radius: meters)
                _ = circleQuery.observe(.documentEntered) { key, _ in
                    guard let routeId = key else { return }
                    Firestore.firestore().collection("routes").whereField("id", isEqualTo: routeId).getDocuments { snapshot, _ in
                        let decoder = FirebaseDecoder()
                        for document in snapshot?.documents ?? [] {
                            guard let result = try? decoder.decode(Route.self, from: document.data() as Any) else { continue }
                            self.routeViewModels.append(RouteViewModel(route: result))
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else { return UITableViewCell() }
        cell.textLabel?.text = routeViewModels[indexPath.row].name
        return cell
    }

    func initViews() {
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.delegate = self
        tableView.dataSource = self

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }

}
