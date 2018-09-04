//
//  DifficultyChart.swift
//  Take
//
//  Created by Nathan Macfarlane on 9/3/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Charts
import UIKit

class DifficultyChart: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var barChartView: BarChartView!

    // MARK: - Variables
    var routes: [Route] = []
//    var difficulties: [String] = []
    var valuesMap: [Int: Int] = [:]
//    let stringFormatter = formatter

    // MARK: - View Load/Unload
    override func viewDidLoad() {
        super.viewDidLoad()

        barChartView.chartDescription?.text = ""
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.enabled = false
        barChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        barChartView.data?.setValueTextColor(NSUIColor.white)
        barChartView.xAxis.labelTextColor = .white
    }

    func reanimate() {
        self.barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }

    func reload() {

        var min: Int?
        var max: Int?
        for route in routes {
            guard let ratingString = route.rating else { continue }
            let rating = Rating(desc: ratingString)
            guard let intDiff = rating.intDiff else { continue }
            if intDiff < min ?? intDiff + 1 {
                min = intDiff
            }
            if intDiff > max ?? intDiff - 1 {
                max = intDiff
            }
        }

        for i in (min ?? 0)...(max ?? 15) {
            valuesMap[i] = 0
        }

        for route in routes {
            guard let ratingString = route.rating else { continue }
            let rating = Rating(desc: ratingString)
            guard let intDiff = rating.intDiff else { continue }
            valuesMap[intDiff] = (valuesMap[intDiff] ?? 0) + 1
        }

        var daysEntries: [BarChartDataEntry] = []
        for i in 0...15 {
            guard let val = valuesMap[i] else { continue }
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(val))
            daysEntries.append(dataEntry)
        }

        let data = BarChartData()
        let ds1 = BarChartDataSet(values: daysEntries, label: "")
        ds1.colors = [ChartColorTemplates.colorFromString("#589ED3")]
        self.barChartView.xAxis.axisRange = Double(valuesMap.keys.count)
        data.addDataSet(ds1)

        self.barChartView.data = data
    }

}
