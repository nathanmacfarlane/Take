import Foundation
import UIKit

class PlanDetailRouteTVC: RouteTVC {
    var numLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        numLabel = LabelAvenir(size: 35, type: .Black, color: nameLabel.textColor)

        addSubview(numLabel)

        numLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: numLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: numLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: numLabel, attribute: .trailing, relatedBy: .equal, toItem: nameLabel, attribute: .leading, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: numLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
