import Foundation
import UIKit

class PlanEditRouteTVC: RouteTVC {
    var toggler: UISwitch!

    var delegate: ToggledEditRouteDelegate?
    var mpRoute: MPRoute!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        toggler = UISwitch()
        toggler.addTarget(self, action: #selector(toggledEdit), for: .valueChanged)
        toggler.onTintColor = UISettings.shared.colorScheme.accent

        addSubview(toggler)

        toggler.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: toggler, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: toggler, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: toggler, attribute: .trailing, relatedBy: .equal, toItem: nameLabel, attribute: .leading, multiplier: 1, constant: -10).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @objc
    func toggledEdit() {
        delegate?.toggledEditRoute(routeId: mpRoute.id, isOn: toggler.isOn)
    }
}

protocol ToggledEditRouteDelegate: class {
    func toggledEditRoute(routeId: Int, isOn: Bool)
}
