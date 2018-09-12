//
//  DifficultyChart.swift
//  Take
//
//  Created by Nathan Macfarlane on 9/3/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit

class DifficultyChart: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var bar0: UILabel!
    @IBOutlet private weak var bar1: UILabel!
    @IBOutlet private weak var bar2: UILabel!
    @IBOutlet private weak var bar3: UILabel!
    @IBOutlet private weak var bar4: UILabel!
    @IBOutlet private weak var bar5: UILabel!
    @IBOutlet private weak var bar6: UILabel!
    @IBOutlet private weak var bar7: UILabel!
    @IBOutlet private weak var bar8: UILabel!
    @IBOutlet private weak var bar9: UILabel!
    @IBOutlet private weak var bar10: UILabel!
    @IBOutlet private weak var bar11: UILabel!
    @IBOutlet private weak var bar12: UILabel!
    @IBOutlet private weak var bar13: UILabel!
    @IBOutlet private weak var bar14: UILabel!
    @IBOutlet private weak var bar15: UILabel!

    @IBOutlet private weak var barLabel0: UILabel!
    @IBOutlet private weak var barLabel1: UILabel!
    @IBOutlet private weak var barLabel2: UILabel!
    @IBOutlet private weak var barLabel3: UILabel!
    @IBOutlet private weak var barLabel4: UILabel!
    @IBOutlet private weak var barLabel5: UILabel!
    @IBOutlet private weak var barLabel6: UILabel!
    @IBOutlet private weak var barLabel7: UILabel!
    @IBOutlet private weak var barLabel8: UILabel!
    @IBOutlet private weak var barLabel9: UILabel!
    @IBOutlet private weak var barLabel10: UILabel!
    @IBOutlet private weak var barLabel11: UILabel!
    @IBOutlet private weak var barLabel12: UILabel!
    @IBOutlet private weak var barLabel13: UILabel!
    @IBOutlet private weak var barLabel14: UILabel!
    @IBOutlet private weak var barLabel15: UILabel!

    // MARK: - Variables
    var routes: [Route] = []
    var valuesMap: [Int: Int] = [:]
    var bars: [UILabel] = []
    var barLabels: [UILabel] = []
    var originalY: CGFloat = 0
    var maxVal: Int = 0
    var barHeight: Int = 0
    var ratio: Int = 0

    // MARK: - View Load/Unload
    override func viewDidLoad() {
        super.viewDidLoad()

        originalY = bar0.frame.origin.y
        barHeight = 175

        self.xAxisVisbility(alpha: 0.0)

        self.bars = [bar0, bar1, bar2, bar3, bar4, bar5, bar6, bar7, bar8, bar9, bar10, bar11, bar12, bar13, bar14, bar15]
        self.barLabels = [barLabel0, barLabel1, barLabel2, barLabel3, barLabel4, barLabel5, barLabel6, barLabel7, barLabel8, barLabel9, barLabel10, barLabel11, barLabel12, barLabel13, barLabel14, barLabel15]

    }

    private func xAxisVisbility(alpha: CGFloat) {
        for barLabel in self.barLabels {
            barLabel.alpha = alpha
        }
    }

    func setupChart() {

        self.resetPositions()
        self.valuesMap = [:]

        for barLabel in barLabels {
            barLabel.alpha = 0.0
        }

        for route in routes {
            guard let ratingString = route.rating else { continue }
            let rating = Rating(desc: ratingString)
            guard let intDiff = rating.intDiff else { continue }
            valuesMap[intDiff] = (valuesMap[intDiff] ?? 0) + 1
            guard let val = valuesMap[intDiff] else { continue }
            if val > maxVal {
                maxVal = val
            }
        }
        if maxVal == 0 { return }
        ratio = barHeight / maxVal
    }

    private func resetPositions() {
        self.xAxisVisbility(alpha: 0.0)
        for bar in bars {
            var newFrame = bar.frame
            newFrame.origin.y = originalY
            newFrame.size.height = 0
            bar.frame = newFrame
        }
    }

    private func resizeBar(val: Int, index: Int) {
        let newBarHeight = CGFloat(val * ratio)
        var newFrame = self.bars[index].frame
        newFrame.size.height = newBarHeight
        newFrame.origin.y -= newBarHeight

        UIView.animate(withDuration: 0.5,
                       animations: {
            self.bars[index].frame = newFrame
            self.bars[index].roundView(portion: 2)
        }, completion: { _ in
            self.bars[index].roundView(portion: 2)
            UIView.animate(withDuration: 0.5) {
                self.xAxisVisbility(alpha: 1.0)
            }
        })
    }

    func reload() {
        self.resetPositions()
        for i in 0...15 {
            guard let val = valuesMap[i] else { continue }
            self.resizeBar(val: val, index: i)
        }
    }

}
