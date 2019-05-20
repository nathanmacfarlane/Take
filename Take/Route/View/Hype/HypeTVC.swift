import UIKit

class HypeTVC: UITableViewCell {

    var nameLabel: UILabel!
    var eventLabel: UILabel!
    var dateLabel: UILabel!
    var bgView: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .clear

        bgView = UILabel()
        bgView.backgroundColor = UISettings.shared.mode == .dark ? UIColor(hex: "#17181A") : UIColor(hex: "#CCCED1")

        nameLabel = LabelAvenir(size: 18, type: .Book)
        dateLabel = LabelAvenir(size: 18, type: .Book, alignment: .right)
        eventLabel = LabelAvenir(size: 18, type: .Book, color: UISettings.shared.colorScheme.textSecondary)

        self.addSubview(bgView)
        self.addSubview(nameLabel)
        self.addSubview(dateLabel)
        self.addSubview(eventLabel)

        bgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: bgView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: bgView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -15).isActive = true
        NSLayoutConstraint(item: bgView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: bgView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -5).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: bgView, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .trailing, relatedBy: .equal, toItem: bgView, attribute: .centerX, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: bgView, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: dateLabel, attribute: .leading, relatedBy: .equal, toItem: bgView, attribute: .centerX, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: dateLabel, attribute: .trailing, relatedBy: .equal, toItem: bgView, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: dateLabel, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dateLabel, attribute: .bottom, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

        eventLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: eventLabel, attribute: .leading, relatedBy: .equal, toItem: nameLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: eventLabel, attribute: .trailing, relatedBy: .equal, toItem: dateLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: eventLabel, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: eventLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.layer.cornerRadius = 15
        bgView.clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
