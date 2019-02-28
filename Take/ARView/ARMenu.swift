import CodableFirebase
import FirebaseFirestore
import Geofirestore
import MapKit
import UIKit

class ARMenu: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    var loadingButton: UIButton!

    let meters = 100.0
    var routeViewModels: [RouteViewModel] = []
    var mapVC: MapVC!
    var mapBG: UIView!

    var totalCount = 0
    var loadedCount = 0

    var diagrams: [String: [ArImage]] = [:]
    var routesMap: [String: Int] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hex: "#202226")

        initViews()

        let geoFirestoreRef = Firestore.firestore().collection("route-geos")
        let geoFirestore = GeoFirestore(collectionRef: geoFirestoreRef)

        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways {
            
            if let location = locManager.location {
                let circleQuery = geoFirestore.query(withCenter: location, radius: meters)
                _ = circleQuery.observe(.documentEntered) { key, _ in
                    guard let routeId = key else { return }
                    Firestore.firestore().collection("routes").whereField("id", isEqualTo: routeId).getDocuments { snapshot, _ in
                        let decoder = FirebaseDecoder()
                        for document in snapshot?.documents ?? [] {
                            guard let result = try? decoder.decode(Route.self, from: document.data() as Any) else { continue }
                            self.totalCount += result.routeArUrls.values.count
                            if !result.routeArUrls.keys.isEmpty {
                                self.routeViewModels.append(RouteViewModel(route: result))
                                self.tableView.insertRows(at: [IndexPath(row: self.routeViewModels.count - 1, section: 0)], with: .middle)
                                self.routesMap[result.id] = self.routeViewModels.count - 1
                                for urls in result.routeArUrls.values {
                                    self.addImage(route: result, dgUrl: urls[1], bgUrl: urls[0])
                                }
                            }
                        }
                    }
                }
            }
        }

    }

    func addImage(route: Route, dgUrl: String, bgUrl: String) {
        var count = 0
        var dgImage: UIImage?
        var bgImage: UIImage?
        bgUrl.getImage { image in
            bgImage = image
            count += 1
            self.handleImages(route: route, count: count, dgImage: dgImage, bgImage: bgImage)
        }
        dgUrl.getImage { image in
            dgImage = image
            count += 1
            self.handleImages(route: route, count: count, dgImage: dgImage, bgImage: bgImage)
        }
    }

    func handleImages(route: Route, count: Int, dgImage: UIImage?, bgImage: UIImage?) {
        if count == 2 {
            if self.diagrams[route.id] != nil {
                self.diagrams[route.id]?.append(ArImage(dgImage: dgImage, bgImage: bgImage))
            } else {
                self.diagrams[route.id] = [ArImage(dgImage: dgImage, bgImage: bgImage)]
            }
            if let index = routesMap[route.id], let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? ARLoadingTVC, let total = cell.totalCount {
                cell.currentCount += 1
                cell.progressBar.setProgress(cell.currentCount / total, animated: true)
            }
            loadedCount += 1
            if loadedCount == totalCount {
                loadingButton.setTitle("View AR", for: .normal)
                loadingButton.addTarget(self, action: #selector(goToAr), for: .touchUpInside)
            }
        }
    }

    @objc
    func goToAr() {
        let arView = ARViewVC()
        var arImages: [ArImage] = []
        for value in self.diagrams.values {
            arImages.append(contentsOf: value)
        }
        arView.diagrams = arImages
        present(arView, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeViewModels.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ARLoadingTVC") as? ARLoadingTVC else { return UITableViewCell() }
        cell.nameLabel.text = routeViewModels[indexPath.row].name
        cell.numberDiagramsLabel.text = "\(routeViewModels[indexPath.row].route.routeArUrls.keys.count)"
        cell.totalCount = Float(routeViewModels[indexPath.row].route.routeArUrls.keys.count)
        cell.currentCount = 0
        return cell
    }

    func initViews() {
        mapBG = UIView()
        mapBG.backgroundColor = UIColor(hex: "#2C416A")
        mapVC = MapVC()

        loadingButton = UIButton()
        loadingButton.setTitle("Loading Routes", for: .normal)
        loadingButton.setTitleColor(UIColor(hex: "#C7C7C7"), for: .normal)
        loadingButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 17)

        let nearbyLabel = UILabel()
        nearbyLabel.text = "Nearby AR Diagrams"
        nearbyLabel.textColor = UIColor(hex: "#808080")
        nearbyLabel.font = UIFont(name: "Avenir-Medium", size: 17)

        tableView = UITableView()
        tableView.register(ARLoadingTVC.self, forCellReuseIdentifier: "ARLoadingTVC")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false

        view.addSubview(mapBG)
        addChild(mapVC)
        view.addSubview(mapVC.view)
        mapBG.addSubview(loadingButton)
        view.addSubview(nearbyLabel)
        view.addSubview(tableView)

        mapVC.didMove(toParent: self)

        mapBG.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mapBG, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: mapBG, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: mapBG, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: mapBG, attribute: .bottom, relatedBy: .equal, toItem: nearbyLabel, attribute: .top, multiplier: 1, constant: -20).isActive = true

        loadingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: loadingButton, attribute: .leading, relatedBy: .equal, toItem: mapBG, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loadingButton, attribute: .trailing, relatedBy: .equal, toItem: mapBG, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loadingButton, attribute: .top, relatedBy: .equal, toItem: mapVC.view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loadingButton, attribute: .bottom, relatedBy: .equal, toItem: mapBG, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

        mapVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mapVC.view, attribute: .leading, relatedBy: .equal, toItem: mapBG, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapVC.view, attribute: .trailing, relatedBy: .equal, toItem: mapBG, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapVC.view, attribute: .top, relatedBy: .equal, toItem: mapBG, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapVC.view, attribute: .bottom, relatedBy: .equal, toItem: mapBG, attribute: .bottom, multiplier: 1, constant: -60).isActive = true

        nearbyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: nearbyLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 23).isActive = true
        NSLayoutConstraint(item: nearbyLabel, attribute: .width, relatedBy: .equal, toItem: tableView, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: nearbyLabel, attribute: .centerX, relatedBy: .equal, toItem: tableView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: nearbyLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: nearbyLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mapVC.view.layer.cornerRadius = 10
        mapVC.view.clipsToBounds = true
        mapBG.layer.cornerRadius = 10
        mapBG.clipsToBounds = true
    }

}
