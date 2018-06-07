//
//  SecondViewController.swift
//  Take
//
//  Created by Family on 4/26/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ProfileView: UIViewController, UITableViewDelegate, UITableViewDataSource/*, UIChartViewDelegate */ {
    
    // MARK: - IBOutlets
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var memberSinceLabel: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var typeSegControl: UISegmentedControl!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var myChartView: UIChartView!
    
    // MARK: - Variables
    var currentUser = User(name: "Nathan Macfarlane", location: "SLO, CA", profileImage: UIImage(named: "profile.jpg"))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profilePhoto.roundImage(portion: 2)
        self.profilePhoto.addBorder(color: .white, width: 2)
        self.profilePhoto.image         = currentUser.profileImage ?? UIImage(named: "bg.jpg")
        self.nameLabel.text             = currentUser.name
        self.cityLabel.text             = currentUser.location
        self.memberSinceLabel.text      = "Member since \(currentUser.membershipDate.getMonth()), \(currentUser.membershipDate.getYearInt())"
        
        
        // **************************** for testing only!!!!!!!!!!!! ****************************
//        let stars = [Star(star: 1, id: "IDdbKJxtW9gGxaxHncMaJzTIb9j2"), Star(star: 4, id: "IDdbKJxtW9gGxaxHncMaJzTIb9j5"), Star(star: 4, id: "IDdbKJxtW9gGxaxHncMaJzTIb9j9")]
//        let ratings = [Rating(desc: "5.9+"), Rating(desc: "5.9-"), Rating(desc: "5.8+")]
//        let comments = [Comment(id: "johny_dang", text: "this is a super cool comment i love it so much yes i do, i just wanted to keep talking because i like this comment so much don't you? yah i think you do", date: Date()), Comment(id: "Nathan Macfarlane", text: "Another radical comment that is so bomb", date: Date())]
//        
//        let camel = Route(Name: "Camel", Location: CLLocation(latitude: 35.2828, longitude: -120.6596), PhotoURL: nil, Id: "1234567890", Types: "TR, Sport", Difficulty: "5.10b", Stars: stars, Pitches: 1, LocalDescrip: ["California", "Central Coast", "San Luis Obispo", "Bishops Peak", "Cracked Wall"], Info: "Start with slab but good edges, throw for the big rail, dance your way up onto said rail and reeeeeach for your next holds. Traverse out right and then sail upward into the chimney-like feature.", FeelsRating: ratings, Comments: comments, Images: nil, ARDiagrams: nil)
//       let yeti = Route(Name: "Yeti", Location: CLLocation(latitude: 35.3, longitude: -120.6596), PhotoURL: nil, Id: "1234567890", Types: "Boulder", Difficulty: "V5", Stars: stars, Pitches: 1, LocalDescrip: ["California", "Central Coast", "San Luis Obispo", "Bishops Peak", "Cracked Wall"], Info: "laskdfjalskjdflak jsdlkfja sl;kdjfl;a ksjdflakjsdflkaj sldfkjaslkdjfal;skdjfa lskjdf lasjdflaksj dfla;ksjdfl;aksjdfl;kajsldkfja lskdjfal;skjdfl;js", FeelsRating: nil, Comments: comments, Images: nil, ARDiagrams: nil)
        
        
//        var timeInterval = DateComponents()
//        timeInterval.month = 2
//        timeInterval.day = 3
//        timeInterval.hour = 4
//        timeInterval.minute = 5
//        timeInterval.second = 6
//        let futureDate = Calendar.current.date(byAdding: timeInterval, to: Date())!
        
//        self.currentUser.favorites.append(camel)
//        self.currentUser.todos.append(camel)
//        self.currentUser.ticks.append(Tick(route: camel, date: futureDate, comment: "Good Stuff"))
//        self.currentUser.ticks.append(Tick(route: yeti, date: futureDate, comment: nil))
        
        
        
//        self.myChartView.delegate = self
        let chartData = [ChartData(month: "Jan", value: 25),
                         ChartData(month: "Feb", value: 35),
                         ChartData(month: "Mar", value: 30),
                         ChartData(month: "Apr", value: 60),
                         ChartData(month: "May", value: 70),
                         ChartData(month: "Jun", value: 90),
                         ChartData(month: "Jul", value: 10),
                         ChartData(month: "Aug", value: 0),
                         ChartData(month: "Sep", value: 3)
        ]
        
        self.myChartView.fillData(data: chartData)
        
        
        // ***************************************************************************************
        
        
        
        
    }
    
    // MARK: - Segment Control
    @IBAction func segChanged(_ sender: UISegmentedControl) {
        self.listTableView.reloadData()
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let segIndex = typeSegControl.selectedSegmentIndex
            if segIndex == 0 {
                currentUser.ticks.remove(at: indexPath.row)
            } else if segIndex == 1 {
                currentUser.favorites.remove(at: indexPath.row)
            } else {
                currentUser.todos.remove(at: indexPath.row)
            }
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let segIndex = typeSegControl.selectedSegmentIndex
        if segIndex == 0 {
            return currentUser.ticks.count
        } else if segIndex == 1 {
            return currentUser.favorites.count
        } else {
            return currentUser.todos.count
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let segIndex = typeSegControl.selectedSegmentIndex
        if segIndex == 0 {
            self.performSegue(withIdentifier: "goToDetail", sender: currentUser.ticks[indexPath.row].route)
        } else if segIndex == 1 {
            self.performSegue(withIdentifier: "goToDetail", sender: currentUser.favorites[indexPath.row])
        } else {
            self.performSegue(withIdentifier: "goToDetail", sender: currentUser.todos[indexPath.row])
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        
        let segIndex = typeSegControl.selectedSegmentIndex
        if segIndex == 0 {
            cell.textLabel?.text        = currentUser.ticks[indexPath.row].route.name
            cell.detailTextLabel?.text  = currentUser.ticks[indexPath.row].comment ?? currentUser.ticks[indexPath.row].date.monthDayYear()
        } else if segIndex == 1 {
            cell.textLabel?.text        = currentUser.favorites[indexPath.row].name
            cell.detailTextLabel?.text  = currentUser.favorites[indexPath.row].localDesc?.last
        } else {
            cell.textLabel?.text        = currentUser.todos[indexPath.row].name
            cell.detailTextLabel?.text  = currentUser.todos[indexPath.row].localDesc?.last
        }
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToDetail" {
            let dc:RouteDetail = segue.destination as! RouteDetail
            dc.theRoute = sender as! Route
            // dc.mainImg  = selectedImage
        }
        
    }

}

