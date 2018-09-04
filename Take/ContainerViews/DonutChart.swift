//
//  DonutChart.swift
//  Take
//
//  Created by Nathan Macfarlane on 8/11/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Charts
import UIKit

class DonutChart: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - IBOutlets
    @IBOutlet private weak var chart: PieChartView!
    @IBOutlet private weak var typesTableView: UITableView!

    // MARK: - Variables
    var routeTypes: [ChartType] = []
    var routes: [Route] = []

    // structs
    struct ChartType {
        var color: UIColor
        var type: String
        var number: Int
    }

    func setupChart() {
        var trad = 0
        var boulder = 0
        var topRope = 0
        var sport = 0
        for route in self.routes {
            if route.types.contains("TR") {
                topRope += 1
            }
            if route.types.contains("Trad") {
                trad += 1
            }
            if route.types.contains("Boulder") {
                boulder += 1
            }
            if route.types.contains("Sport") {
                sport += 1
            }
        }
        let total = trad + boulder + topRope + sport
        self.updateChartData(trad: trad, boulder: boulder, topRope: topRope, sport: sport, count: total)
    }

    // MARK: - Other Functions
    private func updateChartData(trad: Int, boulder: Int, topRope: Int, sport: Int, count: Int) {

        self.routeTypes = []

        let red = UIColor(red: 191 / 256, green: 105 / 256, blue: 98 / 256, alpha: 1.0)
        let blue = UIColor(red: 139 / 256, green: 191 / 256, blue: 191 / 256, alpha: 1.0)
        let purple = UIColor(red: 191 / 256, green: 162 / 256, blue: 188 / 256, alpha: 1.0)
        let green = UIColor(red: 135 / 256, green: 191 / 256, blue: 160 / 256, alpha: 1.0)

        var track: [String] = []
        var money: [Double] = []
        if trad > 0 {
            track.append("Trad")
            money.append(Double(trad))
            self.routeTypes.append(ChartType(color: red, type: "Trad", number: trad))
        }
        if topRope > 0 {
            track.append("Top Rope")
            money.append(Double(topRope))
            self.routeTypes.append(ChartType(color: blue, type: "Top Rope", number: topRope))
        }
        if sport > 0 {
            track.append("Sport")
            money.append(Double(sport))
            self.routeTypes.append(ChartType(color: purple, type: "Sport", number: sport))
        }
        if boulder > 0 {
            track.append("Boulder")
            money.append(Double(boulder))
            self.routeTypes.append(ChartType(color: green, type: "Boulder", number: boulder))
        }
        self.typesTableView.reloadData()

        let entries: [PieChartDataEntry] = money.enumerated().map {
            let entry = PieChartDataEntry()
            entry.y = $1
            entry.label = track[$0]
            return entry
        }

        // 3. chart setup
        let set = PieChartDataSet( values: entries, label: "")
        set.drawValuesEnabled = false
        set.colors = [red, blue, purple, green]
        let data = PieChartData(dataSet: set)

        chart.data = data
        chart.holeColor = .clear

        chart.hideCenterText()
        chart.disableHighlight()
        chart.disableLegend()
        chart.hideDescriptionLabel()
        chart.hideSliceValues()

        chart.holeRadiusPercent = 0.4

        self.animateChart()

    }

    func animateChart() {
        self.chart.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routeTypes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tempCell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        guard let cell = tempCell as? ChartTypesCell else { return UITableViewCell() }
        cell.setLabels(title: "\(self.routeTypes[indexPath.row].type):", count: "\(self.routeTypes[indexPath.row].number)")
        cell.setCircleIconColor(with: self.routeTypes[indexPath.row].color)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 26
    }

}
