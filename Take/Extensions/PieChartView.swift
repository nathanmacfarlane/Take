//
//  PieChartView.swift
//  Take
//
//  Created by Nathan Macfarlane on 8/10/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import Charts

extension PieChartView {
    func disableHighlight() {
        self.highlightPerTapEnabled = false
    }
    func disableLegend() {
        self.legend.enabled = false
    }
    func hideCenterText() {
        self.drawCenterTextEnabled = false
    }
    func hideDescriptionLabel() {
        self.chartDescription?.text = ""
    }
    func hideSliceValues() {
        self.drawEntryLabelsEnabled = false
    }
}
