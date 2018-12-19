import Foundation
import UIKit

class RouteListTVC: UITableViewCell {

    var nameLabel: UILabel!
    var difficultyLabel: UILabel!
    var typesLabel: UILabel!
    var ownerPhoto: UIImageView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor(named: "BluePrimaryDark")

        ownerPhoto = UIImageView()
        ownerPhoto.contentMode = .scaleAspectFill
        ownerPhoto.addBorder(color: .white, width: 1)
        ownerPhoto.clipsToBounds = true

        nameLabel = UILabel()
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: "Avenir-Black", size: 20)

        difficultyLabel = UILabel()
        difficultyLabel.textColor = .white
        difficultyLabel.textAlignment = .right
        difficultyLabel.font = UIFont(name: "Avenir", size: 17)

        typesLabel = UILabel()
        typesLabel.textColor = .white
        typesLabel.font = UIFont(name: "Avenir", size: 17)

        self.addSubview(ownerPhoto)
        self.addSubview(nameLabel)
        self.addSubview(difficultyLabel)
        self.addSubview(typesLabel)

        ownerPhoto.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: ownerPhoto, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: ownerPhoto, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: ownerPhoto, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: ownerPhoto, attribute: .width, relatedBy: .equal, toItem: ownerPhoto, attribute: .height, multiplier: 1, constant: 0).isActive = true

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: ownerPhoto, attribute: .trailing, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.5, constant: 0).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1 / 3, constant: 0).isActive = true

        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: difficultyLabel, attribute: .leading, relatedBy: .equal, toItem: nameLabel, attribute: .trailing, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: difficultyLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: difficultyLabel, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: difficultyLabel, attribute: .bottom, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

        typesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: typesLabel, attribute: .leading, relatedBy: .equal, toItem: nameLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: typesLabel, attribute: .trailing, relatedBy: .equal, toItem: difficultyLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: typesLabel, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: typesLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        ownerPhoto.layer.cornerRadius = ownerPhoto.frame.width / 2
//        let margins = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
//        self.frame = frame.inset(by: margins)
    }
}
