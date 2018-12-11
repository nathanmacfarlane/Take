import UIKit

class RouteTVC: UITableViewCell {

    var routeViewModel: RouteViewModel!

    var nameLabel: UILabel!
    var difficultyLabel: UILabel!
    var typesLabel: UILabel!
    var indicator: UIActivityIndicatorView!
    var firstImageView: UIImageView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor(named: "BluePrimaryDark")

        nameLabel = UILabel()
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: "Avenir-Black", size: 20)

        difficultyLabel = UILabel()
        difficultyLabel.textColor = .white
        difficultyLabel.font = UIFont(name: "Avenir", size: 17)

        typesLabel = UILabel()
        typesLabel.textColor = .white
        typesLabel.font = UIFont(name: "Avenir", size: 17)

        indicator = UIActivityIndicatorView(style: .white)
        indicator.startAnimating()

        firstImageView = UIImageView()
        self.firstImageView.contentMode = .scaleAspectFill

        self.addSubview(nameLabel)
        self.addSubview(difficultyLabel)
        self.addSubview(typesLabel)
        self.addSubview(firstImageView)
        self.addSubview(indicator)

        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        let difficultyLabelWidthConst = NSLayoutConstraint(item: difficultyLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0)
        let difficultyLabelCenterXConst = NSLayoutConstraint(item: difficultyLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let difficultyLabelCenterYConst = NSLayoutConstraint(item: difficultyLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([difficultyLabelWidthConst, difficultyLabelCenterXConst, difficultyLabelCenterYConst])

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        let nameLabelLeadingConst = NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: difficultyLabel, attribute: .leading, multiplier: 1, constant: 0)
        let nameLabelTrailingConst = NSLayoutConstraint(item: nameLabel, attribute: .trailing, relatedBy: .equal, toItem: difficultyLabel, attribute: .trailing, multiplier: 1, constant: 0)
        let nameLabelBottomConst = NSLayoutConstraint(item: nameLabel, attribute: .bottom, relatedBy: .equal, toItem: difficultyLabel, attribute: .top, multiplier: 1, constant: 5)
        NSLayoutConstraint.activate([nameLabelLeadingConst, nameLabelTrailingConst, nameLabelBottomConst])

        typesLabel.translatesAutoresizingMaskIntoConstraints = false
        let typesLabelLeadingConst = NSLayoutConstraint(item: typesLabel, attribute: .leading, relatedBy: .equal, toItem: difficultyLabel, attribute: .leading, multiplier: 1, constant: 0)
        let typesLabelTrailingConst = NSLayoutConstraint(item: typesLabel, attribute: .trailing, relatedBy: .equal, toItem: difficultyLabel, attribute: .trailing, multiplier: 1, constant: 0)
        let typesLabelTopConst = NSLayoutConstraint(item: typesLabel, attribute: .top, relatedBy: .equal, toItem: difficultyLabel, attribute: .bottom, multiplier: 1, constant: -5)
        NSLayoutConstraint.activate([typesLabelLeadingConst, typesLabelTrailingConst, typesLabelTopConst])

        indicator.translatesAutoresizingMaskIntoConstraints = false
        let indicatorCenterX = NSLayoutConstraint(item: indicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 0.5, constant: 0)
        let indicatorCenterY = NSLayoutConstraint(item: indicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([indicatorCenterX, indicatorCenterY])

        firstImageView.translatesAutoresizingMaskIntoConstraints = false
        let imageLeftConst = NSLayoutConstraint(item: firstImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let imageRightConst = NSLayoutConstraint(item: firstImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: -10)
        let imageTopConst = NSLayoutConstraint(item: firstImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let imageBottomConst = NSLayoutConstraint(item: firstImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([imageLeftConst, imageRightConst, imageTopConst, imageBottomConst])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
