//
//  ChartTypesCell.swift
//  Take
//
//  Created by Nathan Macfarlane on 8/10/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit

class ChartTypesCell: UITableViewCell {

    @IBOutlet private weak var circleIcon: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.circleIcon.roundView(portion: 2)
        self.backgroundColor = .clear
    }

    func setCircleIconColor(with newColor: UIColor) {
        self.circleIcon.backgroundColor = newColor
    }

    func setLabels(title: String, count: String) {
        self.titleLabel.text = title
        self.countLabel.text = count
    }

}
