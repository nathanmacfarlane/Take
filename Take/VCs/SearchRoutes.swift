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

    // MARK: - IBOutlets
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var mySearchBar: UISearchBar!
    @IBOutlet weak var mySearchCV: UIView!
    @IBOutlet weak var hideCVButton: UIButton!
    
    // MARK: - Variables
    private var myCV: SearchContainerView!
    let locationManager = CLLocationManager()
    var routeResults : [Route] = []
    var userCurrentLocation : CLLocation?
    var filteredResults : Int = 0
    var selectedRoute : Route!
    var selectedImage : UIImage!
    var routesRoot : DatabaseReference?
    var firstImages : [String: UIImage] = [:]
    
    // View load/unload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isStatusBarHidden = true
        self.myTableView.backgroundColor = UIColor.clear
        self.myTableView.separatorStyle = .none
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async() {
                self.performSegue(withIdentifier: "goToLogin", sender: nil)
                print("not logged in")
            }
        } else {
            print("welcome: \(String(describing: Auth.auth().currentUser?.uid))")
        }
        
        routesRoot = Database.database().reference(withPath: "routes")
        routesRoot?.keepSynced(true)
        
        setupLocations()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        filterRoutes()
//        self.myTableView.reloadData()
        
    }
    
    // MARK: - Actions
    @IBAction func tappedFilter(_ sender: Any) {
        toggleCV()
        self.hideCVButton.isHidden = false
    }
    @IBAction func tappedHideCVButton(_ sender: Any) {
        filterRoutes()
        self.myTableView.reloadData()
        toggleCV()
        self.hideCVButton.isHidden = true
    }
    
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
    func filterRoutes() {
        filterByName(self.mySearchBar.text!)
        var tempRoutes : [Route] = []
        
        for route in routeResults {
            if !(myCV.topRope && route.isTR() || myCV.sport && route.isSport() || myCV.trad && route.isTrad() || myCV.boulder && route.isBoulder()) {
                continue
            }
            if route.difficulty == nil || route.difficulty!.intDiff < myCV.minDiff || route.difficulty!.intDiff > myCV.maxDiff {
                continue
            }
            if route.pitches == nil || route.pitches! > myCV.pitches {
                continue
            }
            if route.averageStar() == 0 || Int(route.averageStar()) < Int(myCV.stars) {
                continue
            }
            if myCV.distance == 50 {
                tempRoutes.append(route)
                continue
            }
            if route.location == nil || userCurrentLocation == nil || Int(((route.location?.distance(from: userCurrentLocation!))!)/1609.34) > myCV.distance {
                continue
            }
            tempRoutes.append(route)
        }
        filteredResults = self.routeResults.count - tempRoutes.count
        routeResults = tempRoutes
    }
    func toggleCV() {
        var pos : CGRect!
        if self.mySearchCV.frame.minX < 0 {
            pos = CGRect(x: 0, y: 0, width: 223, height: 618)
        } else {
            pos = CGRect(x: -223, y: 0, width: 223, height: 618)
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.mySearchCV.frame = pos
        }, completion: nil)
    }
    
    fileprivate func filterByName(_ searchText: String) {
        routeResults = []
//        for route in allRoutes {
//            if routeResults.contains(route) {
//                break
//            }
//            if route.name.contains(searchText) && !routeResults.contains(route) {
//                routeResults.append(route)
//            } else if route.localDesc != nil {
//                for desc in route.localDesc! {
//                    if desc.contains(searchText) && !routeResults.contains(route) {
//                        routeResults.append(route)
//                    }
//                }
//            }
//        }
    }
    
    // MARK: - LocationManager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        userCurrentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
    }
    
    // MARK: - SearchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.routeResults = []
        // search for route by name
        searchFBRoute(byProperty: "name", withValue: searchBar.text!) { (routes) in
            self.addToRoutes(newRoutes: routes)
            // search for route by area
            searchFBRoute(byProperty: "area", withValue: searchBar.text!) { (otherRoutes) in
                self.addToRoutes(newRoutes: otherRoutes)
                // reverse engeineer location
                forwardGeocoding(address: searchBar.text!) { (coordinate) in
                    // search MP API for routes by coordinate
                    routesByArea(coord: coordinate, maxDistance: 50, maxResults: 500, completion: { (routes) in
                        for route in routes {
                            // search for route in Firebase by id
                            searchFBRoute(byProperty: "id", withValue: route.id, completion: { (moreRoutes) in
                                // add firebase data first because it's more updated that mountain project
                                self.addToRoutes(newRoutes: moreRoutes)
                                self.addToRoutes(newRoutes: routes)
                            })
                        }
                    })
                }
            }
        }
        self.mySearchBar.resignFirstResponder()
    }
    func addToRoutes(newRoutes: [Route]) {
        let prevCount = self.routeResults.count
        //if it doesn't already exist, add to array
        for route in newRoutes {
            if !self.routeResults.contains(route) {
                self.routeResults.append(route)
                //download first image
                route.getFirstImageFromFirebase { (firstImage) in
                    self.firstImages["\(route.id)"] = firstImage
                    DispatchQueue.main.async {
                        self.myTableView.reloadData()
                    }
                }
            }
        }
        //if images were added, sort and reload table view
        if self.routeResults.count != prevCount {
            self.routeResults.sort(by: { $0.name < $1.name })
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
        }
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRoute = routeResults[indexPath.row]
        selectedImage = (tableView.cellForRow(at: indexPath) as! SearchResultCell).theImageView.image
        self.performSegue(withIdentifier: "goToDetail", sender: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeResults.count + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != routeResults.count {
            return 90
        }
        return 33
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != routeResults.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SearchResultCell
            
            // labels
            cell.nameLabel.text = routeResults[indexPath.row].name
            cell.nameLabel.textColor = UIColor.white
            cell.difficultyLabel.text = routeResults[indexPath.row].difficulty?.description ?? "N/A"
            cell.difficultyLabel.textColor = UIColor.white
            cell.typesLabel.text = routeResults[indexPath.row].types
            cell.typesLabel.textColor = UIColor.white
            
            // images
            if let firstImage = firstImages["\(routeResults[indexPath.row].id)"] {
                //there is an image loaded - could be an actual image or the noImages.png
                cell.theImageView.image = firstImage
            } else {
                //there is an image loading
                cell.theImageView.image = UIImage(named: "imageLoading.png")
            }
            cell.theImageView.roundImage(portion: 2)
            cell.theImageView.addBorder(color: .white, width: 1)
            if let area = routeResults[indexPath.row].area {
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
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FooterCell")!
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = "\(filteredResults) Filtered Results"
        cell.textLabel?.font = UIFont(name: "Avenir", size: 15)
        cell.textLabel?.textColor = UIColor.black
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
            dc.theRoute = selectedRoute
            dc.mainImg  = selectedImage
        }
        if segue.identifier == "goToArea" {
            let dc:AreaView = segue.destination as! AreaView
            dc.areaName = sender as! String
        }
        
    }

}
