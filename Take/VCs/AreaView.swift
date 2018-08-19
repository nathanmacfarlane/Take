//
//  AreaView.swift
//  Take
//
//  Created by Family on 5/27/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit
import Charts

class AreaView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - IBOutlets
    @IBOutlet weak var routeNameLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    var donutChartCV: DonutChart!
    
    // MARK: - Variables
    var routeArea: RouteArea!
    var rows: [TitleRow] = [TitleRow(name: "Description", color: UIColor(hexString: "#5DDE9E"), expanded: false), TitleRow(name: "Routes", color: UIColor(hexString: "#88DBFA"), expanded: false), TitleRow(name: "Images", color: UIColor(hexString: "#A3A0FB"), expanded: false), TitleRow(name: "Directions", color: UIColor(hexString: "#DE9898"), expanded: false), TitleRow(name: "Type", color: UIColor(hexString: "#D391C4"), expanded: false), TitleRow(name: "Difficulty", color: UIColor(hexString: "#E2C977"), expanded: false), TitleRow(name: "Popularity", color: UIColor(hexString: "#5DDE9E"), expanded: false)]
    var rowHeight: CGFloat = 61
    
    // MARK: - Structs
    struct TitleRow {
        var name: String
        var color: UIColor
        var expanded: Bool
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchFBRoute(byProperty: "area", withValue: routeArea.name) { (routes) in
            var trad = 0
            var topRope = 0
            var sport = 0
            var boulder = 0
            for route in routes {
                if let types = route.types {
                    if types.contains("TR") {
                        topRope += 1
                    }
                    if types.contains("Sport") {
                        sport += 1
                    }
                    if types.contains("Trad") {
                        trad += 1
                    }
                    if types.contains("Boulder") {
                        boulder += 1
                    }
                }
            }
            self.donutChartCV.updateChartData(trad: trad, boulder: boulder, topRope: topRope, sport: sport, count: routes.count)
        }
        
        self.routeNameLabel.text = routeArea.name
    }
    
    // MARK: - UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rows[indexPath.row].expanded ? 120 : rowHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.beginUpdates()
        var new = rows[indexPath.row]
        new.expanded = !new.expanded
        rows[indexPath.row] = new
        tableView.endUpdates()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! AreaExpandableCell
        cell.titleLabel.text = rows[indexPath.row].name
        cell.titleLabel.textColor = rows[indexPath.row].color
        cell.bgView.roundView(portion: 2)
        cell.selectionStyle = .none
//        cell.backgroundColor = UIColor(hexString: "#2F2F2F")
        return cell
    }
    
    // MARK: - Navigation
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DonutChart" {
            self.donutChartCV = segue.destination as! DonutChart
        }
    }
    
}
