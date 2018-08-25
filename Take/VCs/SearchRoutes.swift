//
//  FirstViewController.swift
//  Take
//
//  Created by Family on 4/26/18.
//  Copyright © 2018 N8. All rights reserved.
//

import CodableFirebase
import CoreLocation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import UIKit

class SearchRoutes: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate {

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

    // MARK: - IBOutlets
    @IBOutlet private weak var myTableView: UITableView!
    @IBOutlet private weak var mySearchBar: UISearchBar!
    @IBOutlet private weak var mySearchCV: UIView!
    @IBOutlet private weak var routesRangeLabel: UILabel!
    @IBOutlet private weak var myActivityIndicator: UIActivityIndicatorView!

    // MARK: - Variables
    private var myCV: SearchContainerView = SearchContainerView()
    let locationManager: CLLocationManager = CLLocationManager()
    var userCurrentLocation: CLLocation?
    //    var selectedRoute : Route!
    var selectedImage: UIImage = UIImage()
    var routesRoot: DatabaseReference?
    var firstImages: [String: UIImage] = [:]
    var startIndex: Int = 0
    let NUMCELLS: Int = 10
    let MAXRESULTS: Int = 20

    var results: SearchResults = SearchResults()
    var resultsMashed: [Any] = []

    // View load/unload
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.isStatusBarHidden = true
        self.myTableView.backgroundColor = UIColor.clear
        self.myTableView.separatorStyle = .none
        UITabBar.appearance().barTintColor = self.view.backgroundColor

        self.myActivityIndicator.isHidden = true
        self.routesRangeLabel.text = ""

        results = SearchResults(walls: [], areas: [], cities: [], routes: [])

        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "goToLogin", sender: nil)
                print("not logged in")
            }
        }

        routesRoot = Database.database().reference(withPath: "routes")
        routesRoot?.keepSynced(true)

        setupLocations()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.myTableView.reloadData()

    }

    // MARK: - Actions

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

    // MARK: - LocationManager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        userCurrentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
    }

    // MARK: - SearchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        self.myActivityIndicator.hidesWhenStopped = true
        self.myActivityIndicator.startAnimating()

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
            self.myActivityIndicator.stopAnimating()
        }
        db.query(type: Area.self, by: "name", with: searchText) { areas in
            self.resultsMashed.append(contentsOf: areas)
            for area in areas {
                self.results.areas.append(area.name)
            }
            self.myTableView.reloadData()
            self.myActivityIndicator.stopAnimating()
        }
//        db.getRoutesBy("name", withValue: searchText) { routes in
//            self.results.routes.append(contentsOf: routes)
//            self.resultsMashed.append(contentsOf: routes)
//            self.myTableView.reloadData()
//            self.myActivityIndicator.stopAnimating()
//        }

//        var count = 0
//        self.mySearchBar.resignFirstResponder()
////        guard let searchText = searchBar.text else { return }
//        searchFBRoute(byProperty: "name", withValue: searchText) { routes in
//            self.results.routes.append(contentsOf: routes)
//            self.resultsMashed.append(contentsOf: routes)
//            self.myTableView.reloadData()
//            count = self.manageSpinner(count: count)
//        }
//        searchFBRoute(byProperty: "keyword", withValue: searchText) { routes in
//            self.results.routes.append(contentsOf: routes)
//            self.resultsMashed.append(contentsOf: routes)
//            self.myTableView.reloadData()
//            count = self.manageSpinner(count: count)
//        }
//        searchFBRouteAreas(byProperty: "name", withValue: searchText) { areas in
//            self.resultsMashed.append(contentsOf: areas)
//            self.myTableView.reloadData()
//            count = self.manageSpinner(count: count)
//        }
//        searchFBRouteAreas(byProperty: "keyword", withValue: searchText) { areas in
//            self.resultsMashed.append(contentsOf: areas)
//            self.myTableView.reloadData()
//            count = self.manageSpinner(count: count)
//        }
//        searchFBRouteWalls(byProperty: "name", withValue: searchText) { walls in
//            self.resultsMashed.append(contentsOf: walls)
//            self.myTableView.reloadData()
//            count = self.manageSpinner(count: count)
//        }
//        searchFBRouteWalls(byProperty: "keyword", withValue: searchText) { walls in
//            self.resultsMashed.append(contentsOf: walls)
//            self.myTableView.reloadData()
//            count = self.manageSpinner(count: count)
//        }
//        searchFBRouteCities(byProperty: "name", withValue: searchText) { cities in
//            self.resultsMashed.append(contentsOf: cities)
//            self.myTableView.reloadData()
//            count = self.manageSpinner(count: count)
//        }
//        searchFBRouteCities(byProperty: "keyword", withValue: searchText) { cities in
//            self.resultsMashed.append(contentsOf: cities)
//            self.myTableView.reloadData()
//            count = self.manageSpinner(count: count)
//        }
    }
    func manageSpinner(count: Int) -> Int {
        if count == 7 {
            self.myActivityIndicator.stopAnimating()
            self.myActivityIndicator.isHidden = true
        }
        return count + 1
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let anyItem = self.resultsMashed[indexPath.row]
        switch anyItem {
        case is Route:
            guard let theRoute = anyItem as? Route else { return }
            self.performSegue(withIdentifier: "goToDetail", sender: theRoute)
        case is Wall:
            print("selected wall")
        case is RouteArea:
            guard let theRouteArea = anyItem as? RouteArea else { return }
            self.performSegue(withIdentifier: "goToArea", sender: theRouteArea)
        case is City:
            print("selected city")
        default:
            print("not accounted for")
        }
        //        if tableView.cellForRow(at: indexPath) is RouteCell {
        //            selectedRoute = self.filteredRoutes[indexPath.row]
        //            selectedImage = (tableView.cellForRow(at: indexPath) as! RouteCell).theImageView.image
        //            self.performSegue(withIdentifier: "goToDetail", sender: nil)
        //        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultsMashed.count
        //        if self.filteredRoutes.count == 0 { return 0 }
        //        if startIndex > self.filteredRoutes.count-NUMCELLS {
        //            return (self.filteredRoutes.count-startIndex) + 1
        //        } else {
        //            return self.filteredRoutes.count <= NUMCELLS ? self.filteredRoutes.count + 1 : NUMCELLS+1
        //        }
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
        case is Wall:
            guard let theWall = anyItem as? Wall else { return UITableViewCell() }
            return getWallCell(wall: theWall)
        case is Area:
            guard let theRouteArea = anyItem as? Area else { return UITableViewCell() }
            return getAreaCell(area: theRouteArea)
        case is City:
            guard let theCity = anyItem as? City else { return UITableViewCell() }
            return getCityCell(city: theCity)
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WallCell") as? WallCell else { return UITableViewCell() }
            cell.setWallLabel(with: "NOT IMPLEMENTED YET")
            return cell
        }
    }
    func getCityCell(city: City) -> CityCell {
        guard let cell = self.myTableView.dequeueReusableCell(withIdentifier: "CityCell") as? CityCell else { return CityCell() }
        cell.backgroundColor = .clear
        cell.setCityLabel(with: city.name)
        city.getCoverPhoto { coverImage in
            DispatchQueue.main.async {
                cell.setBgImage(with: coverImage)
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    func getAreaCell(area: Area) -> AreaCell {
        guard let cell = self.myTableView.dequeueReusableCell(withIdentifier: "AreaCell") as? AreaCell else { return AreaCell() }
        cell.backgroundColor = .clear
        cell.setAreaLabel(with: area.name)
        area.getCoverPhoto { coverImage in
            if let coverImage = coverImage {
                DispatchQueue.main.async {
                    cell.setBgImage(with: coverImage)
                }
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    func getWallCell(wall: Wall) -> WallCell {
        guard let cell = self.myTableView.dequeueReusableCell(withIdentifier: "WallCell") as? WallCell else { return WallCell() }
        cell.setWallLabel(with: wall.name)
        wall.getCoverPhoto { coverImage in
            DispatchQueue.main.async {
                cell.setBgImage(with: coverImage)
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    func getRouteCell(route: Route) -> RouteCell {
        guard let cell = self.myTableView.dequeueReusableCell(withIdentifier: "Cell") as? RouteCell else { return RouteCell() }

        // labels
        cell.setLabels(name: route.name, types: route.difficulty?.description ?? "N/A", difficulty: route.typesString)

        DispatchQueue.global(qos: .background).async {
            route.fsLoadFirstImage { _, image in
                DispatchQueue.main.async {
                    if let image = image {
                        cell.setImage(with: image)
                    }
                }
            }
            route.getArea { area in
                if let area = area {
                    area.getCoverPhoto { image in
                        DispatchQueue.main.async {
                            if let image = image {
                                cell.setLocationImage(with: image)
                            }
                        }
                    }
                }
            }
        }

        if let area = route.area {
            cell.setLocationImage(with: UIImage())
            cell.setAreaAbrev(with: area)
        } else {
            cell.setAreaButtonTitle()
        }

        return cell
    }

    // MARK: - Navigation
    @IBAction private func goLogout(_ sender: UIButton) {
//        try! Auth.auth().signOut()
//        self.performSegue(withIdentifier: "goToLogin", sender: nil)
    }
    @IBAction private func tappedArea(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToArea", sender: sender.titleLabel?.text)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let vcntrl = segue.destination as? SearchContainerView, segue.identifier == "theCV" {
            self.myCV = vcntrl
        }
        if segue.identifier == "goToDetail", let dct = segue.destination as? RouteDetail, let theRoute = sender as? Route {
            dct.theRoute = theRoute
        }
        if segue.identifier == "goToArea", let dct = segue.destination as? AreaView, let theRouteArea = sender as? RouteArea {
            dct.routeArea = theRouteArea
        }

    }

}
