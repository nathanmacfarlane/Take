//
//  FirstViewController.swift
//  Take
//
//  Created by Family on 4/26/18.
//  Copyright © 2018 N8. All rights reserved.
//

import CoreLocation
import FirebaseAuth
import FirebaseDatabase
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
        } else {
            //            print("welcome: \(String(describing: Auth.auth().currentUser?.uid))")
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

        self.myActivityIndicator.isHidden = false
        self.myActivityIndicator.startAnimating()

        self.results.clear()
        self.resultsMashed.removeAll()
        self.myTableView.reloadData()

        var count = 0
        self.mySearchBar.resignFirstResponder()
        guard let searchText = searchBar.text else { return }
        searchFBRoute(byProperty: "name", withValue: searchText) { routes in
            self.results.routes.append(contentsOf: routes)
            self.resultsMashed.append(contentsOf: routes)
            self.myTableView.reloadData()
            count = self.manageSpinner(count: count)
        }
        searchFBRoute(byProperty: "keyword", withValue: searchText) { routes in
            self.results.routes.append(contentsOf: routes)
            self.resultsMashed.append(contentsOf: routes)
            self.myTableView.reloadData()
            count = self.manageSpinner(count: count)
        }
        searchFBRouteAreas(byProperty: "name", withValue: searchText) { areas in
            self.resultsMashed.append(contentsOf: areas)
            self.myTableView.reloadData()
            count = self.manageSpinner(count: count)
        }
        searchFBRouteAreas(byProperty: "keyword", withValue: searchText) { areas in
            self.resultsMashed.append(contentsOf: areas)
            self.myTableView.reloadData()
            count = self.manageSpinner(count: count)
        }
        searchFBRouteWalls(byProperty: "name", withValue: searchText) { walls in
            self.resultsMashed.append(contentsOf: walls)
            self.myTableView.reloadData()
            count = self.manageSpinner(count: count)
        }
        searchFBRouteWalls(byProperty: "keyword", withValue: searchText) { walls in
            self.resultsMashed.append(contentsOf: walls)
            self.myTableView.reloadData()
            count = self.manageSpinner(count: count)
        }
        searchFBRouteCities(byProperty: "name", withValue: searchText) { cities in
            self.resultsMashed.append(contentsOf: cities)
            self.myTableView.reloadData()
            count = self.manageSpinner(count: count)
        }
        searchFBRouteCities(byProperty: "keyword", withValue: searchText) { cities in
            self.resultsMashed.append(contentsOf: cities)
            self.myTableView.reloadData()
            count = self.manageSpinner(count: count)
        }
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
        case is RouteArea:
            guard let theRouteArea = anyItem as? RouteArea else { return UITableViewCell() }
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
    func getAreaCell(area: RouteArea) -> AreaCell {
        guard let cell = self.myTableView.dequeueReusableCell(withIdentifier: "AreaCell") as? AreaCell else { return AreaCell() }
        cell.backgroundColor = .clear
        cell.setAreaLabel(with: area.name)
        area.getCoverPhoto { coverImage in
            DispatchQueue.main.async {
                cell.setBgImage(with: coverImage)
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
        cell.setLabels(name: route.name, types: route.difficulty?.description ?? "N/A", difficulty: route.types ?? "N/A")

        DispatchQueue.global(qos: .background).async {
            route.fbLoadFirstImage(size: "Thumbnail") { firstImage in
                guard let noImages = UIImage(named: "noImages.png") else { return }
                DispatchQueue.main.async {
                    cell.setImage(with: firstImage ?? noImages)
                }
            }
        }

//        // images
//        if let firstImage = firstImages["\(route.id)"] {
//            //there is an image loaded - could be an actual image or the noImages.png
//            cell.setImage(with: firstImage)
//        } else {
//            //there is an image loading
//            cell.setImage(with: UIImage(named: "imageLoading.png") ?? UIImage())
//        }
        if let area = route.area {
            cell.setLocationImage(with: UIImage(named: "bg.jpg") ?? UIImage())
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

//    func filterRoutes() {
//        self.filteredRoutes = []
//        for route in routeResults {
//            if !(myCV.topRope && route.isTR() || myCV.sport && route.isSport() || myCV.trad && route.isTrad() || myCV.boulder && route.isBoulder()) {
//                print("\(route.toString()) didn't pass type")
//                continue
//            }
//            if route.difficulty == nil || route.difficulty!.intDiff < myCV.minDiff || route.difficulty!.intDiff > myCV.maxDiff {
//                print("\(route.toString()) didn't pass difficult")
//                continue
//            }
//            if route.pitches ?? 0 > myCV.pitches {
//                print("\(route.toString()) didn't pass pitches")
//                continue
//            }
//            if route.star != nil && route.star! < myCV.stars {
//                print("\(route.toString()) didn't pass stars")
//                continue
//            }
//            if myCV.distance == 50 {
//                self.filteredRoutes.append(route)
//                continue
//            }
//            if route.location == nil || userCurrentLocation == nil || Int(((route.location?.distance(from: userCurrentLocation!))!)/1609.34) > myCV.distance {
//                print("\(route.toString()) didn't pass locations")
//                continue
//            }
//            self.filteredRoutes.append(route)
//        }
//        self.routesRangeLabel.text = "Routes \(startIndex == 0 ? 1 : startIndex+1)-\(startIndex+self.NUMCELLS < self.filteredRoutes.count ? startIndex+10 : self.filteredRoutes.count) of \(self.self.filteredRoutes.count)"
//    }

//func addToRoutes(newRoutes: [Route], priority: Int) {
//    let prevCount = self.filteredRoutes.count
//    //if it doesn't already exist, add to array
//    for route in newRoutes {
//        if !self.routeResults.contains(route) {
//            self.routeResults.append(route)
//            self.filteredRoutes.append(route)
//            //download first image
//            route.getFirstImageFromFirebase { (firstImage) in
//                self.firstImages["\(route.id)"] = firstImage
//                DispatchQueue.main.async {
//                    if self.myActivityIndicator.isAnimating {
//                        self.myActivityIndicator.isHidden = true
//                        self.myActivityIndicator.stopAnimating()
//                        self.routesRangeLabel.text = "Routes 1-\(self.startIndex+self.NUM_CELLS < self.filteredRoutes.count ? self.startIndex+self.NUM_CELLS : self.filteredRoutes.count) of \(self.filteredRoutes.count)"
//                    }
//                    self.myTableView.reloadData()
//                }
//            }
//        }
//    }
//    //if images were added, sort and reload table view
//    if self.filteredRoutes.count != prevCount {
//        self.filteredRoutes.sort(by: { $0.name < $1.name })
//        DispatchQueue.main.async {
//            self.myTableView.reloadData()
//        }
//    }
//}

//    @IBAction func clickedNext(_ sender: UIButton) {
//        startIndex = startIndex+NUM_CELLS > filteredRoutes.count ? filteredRoutes.count - startIndex : startIndex + NUM_CELLS
//        self.updateRange()
//    }
//    @IBAction func clickedLast(_ sender: UIButton) {
//        if self.filteredRoutes.count % NUM_CELLS == 0 {
//            startIndex = self.filteredRoutes.count-NUM_CELLS
//        } else {
//            startIndex = (self.filteredRoutes.count/NUM_CELLS)*NUM_CELLS
//        }
//        self.updateRange()
//    }
//    func updateRange() {
//        self.routesRangeLabel.text = "Routes \(startIndex == 0 ? 1 : startIndex+1)-\(startIndex+NUM_CELLS < self.filteredRoutes.count ? startIndex+NUM_CELLS : self.filteredRoutes.count) of \(self.self.filteredRoutes.count)"
////        self.myTableView.scrollToTop {
//            self.myTableView.reloadData()
////        }
//    }

//    @IBAction func clickedFirst(_ sender: UIButton) {
//        startIndex = 0
//        self.updateRange()
//    }
//    @IBAction func clickedPrevious(_ sender: UIButton) {
//        startIndex = startIndex-NUM_CELLS <= 0 ? 0 : startIndex-NUM_CELLS
//        self.updateRange()
//    }

//    func getPaginationCell() -> ViewNextPageCell {
//        let cell = self.myTableView.dequeueReusableCell(withIdentifier: "ViewNextPageCell") as! ViewNextPageCell
//        cell.backgroundColor = UIColor.clear
//        cell.firstButton.alpha = startIndex == 0 ? 0 : 1
//        cell.previousButton.alpha = startIndex == 0 ? 0 : 1
//        cell.nextButton.alpha = startIndex >= self.filteredRoutes.count-NUM_CELLS ? 0 : 1
//        cell.lastButton.alpha = startIndex >= self.filteredRoutes.count-NUM_CELLS ? 0 : 1
//        cell.firstButton.roundButton(portion: 5)
//        cell.previousButton.roundButton(portion: 5)
//        cell.nextButton.roundButton(portion: 5)
//        cell.lastButton.roundButton(portion: 5)
//        return cell
//
//    }

/*
 // search for route by name
 searchFBRoute(byProperty: "name", withValue: searchBar.text!) { (routes) in
 //            print("addiong from FB by name")
 self.addToRoutes(newRoutes: routes, priority: 1)
 // search for route by area
 searchFBRoute(byProperty: "area", withValue: searchBar.text!) { (otherRoutes) in
 //                print("addiong from FB by area")
 self.addToRoutes(newRoutes: otherRoutes, priority: 0)
 // reverse engeineer location
 forwardGeocoding(address: searchBar.text!) { (coordinate) in
 // search MP API for routes by coordinate
 routesByArea(coord: coordinate, maxDistance: 50, maxResults: self.MAXRESULTS, completion: { (routesArea) in
 var count = 0
 for route in routesArea {
 // search for route in Firebase by id
 searchFBRoute(byProperty: "id", withValue: route.id, completion: { (moreRoutes) in
 // add firebase data first because it's more updated that mountain project
 //                                print("addiong from FB by id")
 self.addToRoutes(newRoutes: moreRoutes, priority: 1)
 count += 1
 if count == routesArea.count {
 //                                    print("addiong from MP")
 self.addToRoutes(newRoutes: routesArea, priority: 0)
 }
 })
 }
 })
 }
 }
 }

 */

//func toggleCV() {
//    var pos : CGRect!
//    if self.mySearchCV.frame.minX < 0 {
//        pos = CGRect(x: 0, y: 0, width: 223, height: 618)
//    } else {
//        pos = CGRect(x: -223, y: 0, width: 223, height: 618)
//    }
//    UIView.animate(withDuration: 0.3, animations: {
//        self.mySearchCV.frame = pos
//    }, completion: nil)
//}
