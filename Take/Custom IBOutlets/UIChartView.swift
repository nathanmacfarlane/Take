//
//  UIChartView.swift
//  Take
//
//  Created by Family on 5/26/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import UIKit

class UIChartView: UIView {

    // variables
    var data: [ChartData] = []

    // outlets
    private var myScrollView: UIScrollView
//    private var dateBG: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    @IBOutlet private weak var dateBG: UILabel
    private var bottomBarOffset: CGFloat = 20
    private var barWidth: Int = 50

    override func awakeFromNib() {
        super.awakeFromNib()
        myScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        myScrollView.backgroundColor = .white
        myScrollView.bounces = false
        myScrollView.showsHorizontalScrollIndicator = false
        dateBG = UILabel(frame: CGRect(x: 0, y: self.frame.height - bottomBarOffset, width: self.frame.width, height: bottomBarOffset))
        dateBG.backgroundColor = .gray
        myScrollView.addSubview(dateBG)
        self.addSubview(myScrollView)
    }

    func fillData(data: [ChartData]) {
        self.data = data
        self.loadData()
    }

    func reloadData() {
        for sub in self.myScrollView.subviews {
            sub.removeFromSuperview()
        }
        self.loadData()
    }

    private func getHeight(val: Int, maxValue: Int) -> Int {
        return val * maxValue
    }

    private func loadData() {
        var xOffset = 10
        //let maxValue = self.data.map{ $0.value }.max()

        for data in self.data {
            let label = UILabel(frame: CGRect(x: xOffset, y: Int(CGFloat(Int(self.frame.height) - data.value) - bottomBarOffset), width: barWidth, height: data.value))
            label.backgroundColor = .black
            if data.value > Int(self.frame.height / 10) {
                label.text = "\(data.value)"
                label.textAlignment = .center
                label.textColor = .white
            }
            let dateLabel = UILabel(frame: CGRect(x: xOffset, y: Int(self.frame.height - bottomBarOffset), width: barWidth, height: Int(bottomBarOffset)))
            dateLabel.textAlignment = .center
            //            dateLabel.text = "\(Array(d.month)[0])"
            dateLabel.text = data.month
            //            let dateLabel = UILabel(frame: CGRect(x: xOffset, y: Int(CGFloat(Int(self.frame.height)-d.value), width: 30, height: 20)))
            myScrollView.addSubview(dateLabel)
            myScrollView.addSubview(label)
            xOffset += barWidth + 10
        }
        self.myScrollView.contentSize = CGSize(width: xOffset, height: Int(self.frame.height))
        self.dateBG.frame.size = CGSize(width: CGFloat(xOffset), height: self.dateBG.frame.height)
        self.myScrollView.scrollToBottom(animated: true)
    }

}
