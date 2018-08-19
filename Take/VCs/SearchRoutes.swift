//
//  FirstViewController.swift
//  Take
//
//  Created by Family on 4/26/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseDatabase
import FirebaseAuth

class SearchRoutes: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate {

    // Private Models
    struct SearchResults {
        var walls: [String]!
        var areas: [String]!
        var cities: [String]!
        var routes: [Route]!
        
        mutating func clear() {
            self.walls.removeAll()
            self.areas.removeAll()
            self.routes.removeAll()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var mySearchBar: UISearchBar!
    @IBOutlet weak var mySearchCV: UIView!
    @IBOutlet weak var routesRangeLabel: UILabel!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Variables
    private var myCV: SearchContainerView!
    let locationManager = CLLocationManager()
    var userCurrentLocation : CLLocation?
//    var selectedRoute : Route!
    var selectedImage : UIImage!
    var routesRoot : DatabaseReference?
    var firstImages : [String: UIImage] = [:]
    var startIndex = 0
    let NUM_CELLS = 10
    let MAX_RESULTS = 20
    
    var results : SearchResults!
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
            DispatchQueue.main.async() {
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
        searchFBRoute(byProperty: "name", withValue: searchBar.text!) { (routes) in
            self.results.routes.append(contentsOf: routes)
            self.resultsMashed.append(contentsOf: routes)
            self.myTableView.reloadData()
            count = self.manageSpinner(count: count)
        }
        searchFBRoute(byProperty: "keyword", withValue: searchBar.text!) { (routes) in
            self.results.routes.append(contentsOf: routes)
            self.resultsMashed.append(contentsOf: routes)
            self.myTableView.reloadData()
            count = self.manageSpinner(count: count)
        }
        searchFBRouteAreas(byProperty: "name", withValue: searchBar.text!) { (areas) in
            self.resultsMashed.append(contentsOf: areas)
            self.myTableView.reloadData()
            count = self.manageSpinner(count: count)
        }
        searchFBRouteAreas(byProperty: "keyword", withValue: searchBar.text!) { (areas) in
            self.resultsMashed.append(contentsOf: areas)
            self.myTableView.reloadData()
            count = self.manageSpinner(count: count)
        }
        searchFBRouteWalls(byProperty: "name", withValue: searchBar.text!) { (walls) in
            self.resultsMashed.append(contentsOf: walls)
            self.myTableView.reloadData()
            count = self.manageSpinner(count: count)
        }
        searchFBRouteWalls(byProperty: "keyword", withValue: searchBar.text!) { (walls) in
            self.resultsMashed.append(contentsOf: walls)
            self.myTableView.reloadData()
            count = self.manageSpinner(count: count)
        }
        searchFBRouteCities(byProperty: "name", withValue: searchBar.text!) { (cities) in
            self.resultsMashed.append(contentsOf: cities)
            self.myTableView.reloadData()
            count = self.manageSpinner(count: count)
        }
        searchFBRouteCities(byProperty: "keyword", withValue: searchBar.text!) { (cities) in
            self.resultsMashed.append(contentsOf: cities)
            self.myTableView.reloadData()
            count = self.manageSpinner(count: count)
        }

        self.mySearchBar.resignFirstResponder()
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
            self.performSegue(withIdentifier: "goToDetail", sender: anyItem as! Route)
        case is Wall:
            print("selected wall")
        case is RouteArea:
            self.performSegue(withIdentifier: "goToArea", sender: anyItem as! RouteArea)
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
//        if startIndex > self.filteredRoutes.count-NUM_CELLS {
//            return (self.filteredRoutes.count-startIndex) + 1
//        } else {
//            return self.filteredRoutes.count <= NUM_CELLS ? self.filteredRoutes.count + 1 : NUM_CELLS+1
//        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let anyItem = self.resultsMashed[indexPath.row]
        switch self.resultsMashed[indexPath.row] {
        case is Route:
            return getRouteCell(route: anyItem as! Route)
        case is Wall:
            return getWallCell(wall: anyItem as! Wall)
        case is RouteArea:
            return getAreaCell(area: anyItem as! RouteArea)
        case is City:
            return getCityCell(city: anyItem as! City)
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WallCell") as! WallCell
            cell.wallLabel.text = "NOT IMPLEMENTED YET"
            return cell
        }
    }
    func getCityCell(city: City) -> CityCell {
        let cell = self.myTableView.dequeueReusableCell(withIdentifier: "CityCell") as! CityCell
        cell.bgView.layer.cornerRadius = 10
        cell.bgView.clipsToBounds = true
        cell.backgroundColor = .clear
        cell.cityLabel.text = city.name
        city.getCoverPhoto { (coverImage) in
            DispatchQueue.main.async() {
                cell.bgImage.image = coverImage
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    func getAreaCell(area: RouteArea) -> AreaCell {
        let cell = self.myTableView.dequeueReusableCell(withIdentifier: "AreaCell") as! AreaCell
        cell.bgView.layer.cornerRadius = 10
        cell.bgView.clipsToBounds = true
        cell.backgroundColor = .clear
        cell.areaLabel.text = area.name
        area.getCoverPhoto { (coverImage) in
            DispatchQueue.main.async() {
                cell.bgImage.image = coverImage
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    func getWallCell(wall: Wall) -> WallCell {
        let cell = self.myTableView.dequeueReusableCell(withIdentifier: "WallCell") as! WallCell
        cell.wallLabel.text = wall.name
        cell.bgView.layer.cornerRadius = 10
        cell.bgView.clipsToBounds = true
        cell.backgroundColor = .clear
        wall.getCoverPhoto { (coverImage) in
            DispatchQueue.main.async() {
                cell.bgImage.image = coverImage
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    func getRouteCell(route: Route) -> RouteCell {
        let cell = self.myTableView.dequeueReusableCell(withIdentifier: "Cell") as! RouteCell
        
        // labels
        cell.nameLabel.text = route.name
        cell.nameLabel.textColor = UIColor.white
        cell.difficultyLabel.text = route.difficulty?.description ?? "N/A"
        cell.difficultyLabel.textColor = UIColor.white
        cell.typesLabel.text = route.types
        cell.typesLabel.textColor = UIColor.white
        
        // images
        if let firstImage = firstImages["\(route.id)"] {
            //there is an image loaded - could be an actual image or the noImages.png
            cell.theImageView.image = firstImage
        } else {
            //there is an image loading
            cell.theImageView.image = UIImage(named: "imageLoading.png")
        }
        cell.theImageView.roundImage(portion: 2)
        cell.theImageView.addBorder(color: .white, width: 1)
        if let area = route.area {
            cell.locationImageView.image = UIImage(named: "bg.jpg")
            cell.locationImageView.roundImage(portion: 2)
            cell.locationImageView.addBorder(color: .white, width: 1)
            cell.areaButton.addAbrevText(text: area)
        } else {
            cell.areaButton.setTitle("", for: .normal)
        }
        
        // background
        cell.backgroundColor = UIColor.clear
        cell.bgView.backgroundColor = UIColor.black
        cell.bgView.layer.cornerRadius = 10
        cell.bgView.clipsToBounds = true
        cell.selectionStyle = .none
        return cell
    }

    // MARK: - Navigation
    @IBAction func goLogout(_ sender: UIButton) {
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "goToLogin", sender: nil)
    }
    @IBAction func tappedArea(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToArea", sender: sender.titleLabel?.text)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? SearchContainerView, segue.identifier == "theCV" {
            self.myCV = vc
        }
        if segue.identifier == "goToDetail" {
            let dc:RouteDetail = segue.destination as! RouteDetail
            dc.theRoute = sender as! Route
//            dc.mainImg  = selectedImage
        }
        if segue.identifier == "goToArea" {
            let dc:AreaView = segue.destination as! AreaView
            dc.routeArea = sender as! RouteArea
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
//        self.routesRangeLabel.text = "Routes \(startIndex == 0 ? 1 : startIndex+1)-\(startIndex+self.NUM_CELLS < self.filteredRoutes.count ? startIndex+10 : self.filteredRoutes.count) of \(self.self.filteredRoutes.count)"
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
 routesByArea(coord: coordinate, maxDistance: 50, maxResults: self.MAX_RESULTS, completion: { (routesArea) in
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


