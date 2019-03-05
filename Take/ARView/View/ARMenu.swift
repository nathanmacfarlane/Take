import CodableFirebase
import FirebaseFirestore
import Geofirestore
import MapKit
import UIKit

class ARMenu: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    var loadingButton: UIButton!
    var nearbyLabel: UILabel!

    let meters = 100.0
    var routeViewModels: [RouteViewModel] = []
    var mapVC: MapVC!
    var mapBG: UIView!

    var totalCount = 0
    var loadedCount = 0
    var geoQueryFinished = false

    var diagrams: [Route: [ArImage]] = [:]
    var routesMap: [String: Int] = [:]

    var routeIdToDiagramCount: [String: Int] = [:]

    var circleQuery: GFSCircleQuery?
    var handle: GFSQueryHandle?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        geoQueryFinished = false
        totalCount = 0
        loadedCount = 0
        diagrams = [:]
        routesMap = [:]
        routeViewModels = []
        tableView.reloadData()
        mapVC.mapView.removeAllAnnotations()

        queryRoutes()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hex: "#202226")

        initViews()

    }

    func queryRoutes() {
        let geoFirestoreRef = FirestoreService.shared.fs.collection("route-geos")
        let geoFirestore = GeoFirestore(collectionRef: geoFirestoreRef)

        guard let location = LocationService.shared.location else { return }

        circleQuery = geoFirestore.query(withCenter: location, radius: meters)
        handle = circleQuery?.observe(.documentEntered) { key, _ in
            guard let routeId = key else { return }

            FirestoreService.shared.fs.query(collection: "arDiagrams", by: "routeId", with: routeId, of: ARDiagram.self) { diagrams in
                self.totalCount += diagrams.count
                let justTheRoute = self.routeViewModels.filter { $0.id == routeId }
                if justTheRoute.isEmpty && !diagrams.isEmpty {
                    self.routeIdToDiagramCount[routeId] = diagrams.count
                    FirestoreService.shared.fs.query(collection: "routes", by: "id", with: routeId, of: Route.self, and: 1) { route in
                        guard let route = route.first else { return }
                        let rvm = RouteViewModel(route: route)
                        self.routeViewModels.append(rvm)
                        self.nearbyLabel.text = "Nearby AR Diagrams"
                        self.tableView.insertRows(at: [IndexPath(row: self.routeViewModels.count - 1, section: 0)], with: .middle)
                        self.routesMap[route.id] = self.routeViewModels.count - 1

                        for diagram in diagrams {
                            self.addImage(route: route, dgUrl: diagram.dgImageUrl, bgUrl: diagram.bgImageUrl)
                        }

                        DispatchQueue.main.async {
                            let anno = MKPointAnnotation()
                            anno.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                            anno.title = rvm.name
                            anno.subtitle = "\(rvm.rating) \(rvm.typesString)"
                            self.mapVC.mapView.addAnnotation(anno)
                            self.mapVC.mapView.showAnnotations(self.mapVC.mapView.annotations, animated: true)
                        }

                    }
                }
            }
        }

        _ = circleQuery?.observeReady {
            self.geoQueryFinished = true
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let handle = handle {
            circleQuery?.removeObserver(withHandle: handle)
        }
    }

    func addImage(route: Route, dgUrl: String, bgUrl: String) {
        var dgImage: UIImage?
        var bgImage: UIImage?
        ImageCache.shared.getImage(for: bgUrl) { image in
            bgImage = image
            self.handleImages(route: route, dgImage: dgImage, bgImage: bgImage)
        }
        ImageCache.shared.getImage(for: dgUrl) { image in
            dgImage = image
            self.handleImages(route: route, dgImage: dgImage, bgImage: bgImage)
        }
    }

    func handleImages(route: Route, dgImage: UIImage?, bgImage: UIImage?) {
        if dgImage != nil && bgImage != nil {
            if self.diagrams[route] != nil {
                self.diagrams[route]?.append(ArImage(dgImage: dgImage, bgImage: bgImage))
            } else {
                self.diagrams[route] = [ArImage(dgImage: dgImage, bgImage: bgImage)]
            }
            DispatchQueue.main.async {
                if let index = self.routesMap[route.id], let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? ARLoadingTVC, let total = cell.totalCount {
                    cell.currentCount += 1
                    cell.progressBar.setProgress(cell.currentCount / total, animated: true)
                }
                self.loadedCount += 1
                if self.geoQueryFinished && self.loadedCount == self.totalCount {
                    self.loadingButton.setTitle("View AR", for: .normal)
                    self.loadingButton.addTarget(self, action: #selector(self.goToAr), for: .touchUpInside)
                }
            }
        }
    }

    @objc
    func goToAr() {
        let arView = ARViewVC()
        arView.diagrams = diagrams
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
        cell.numberDiagramsLabel.text = "\(routeIdToDiagramCount[routeViewModels[indexPath.row].id] ?? 0)"
        cell.totalCount = Float(routeIdToDiagramCount[routeViewModels[indexPath.row].id] ?? 0)
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

        nearbyLabel = UILabel()
        nearbyLabel.text = ""
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
