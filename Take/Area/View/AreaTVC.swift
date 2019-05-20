import UIKit

class AreaTVC: UITableViewCell {

    var nameLabel: UILabel!
    var difficultyLabel: UILabel!
    var typesLabel: UILabel!
    var indicator: UIActivityIndicatorView!
    var firstImageView: UIImageView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear

        nameLabel = LabelAvenir(size: 20, type: .Black, color: UISettings.shared.colorScheme.textPrimary)
        difficultyLabel = LabelAvenir(size: 17, color: UISettings.shared.colorScheme.textPrimary)
        typesLabel = LabelAvenir(size: 17, color: UISettings.shared.colorScheme.textPrimary)

        indicator = UIActivityIndicatorView(style: .white)
        indicator.startAnimating()

        firstImageView = UIImageView()
        firstImageView.contentMode = .scaleAspectFill
        firstImageView.clipsToBounds = true

        let bgView = UILabel()
        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true
        bgView.backgroundColor = UISettings.shared.mode == .dark ? .black : UIColor(hex: "#C9C9C9")

        addSubview(bgView)
        addSubview(nameLabel)
        addSubview(difficultyLabel)
        addSubview(typesLabel)
        addSubview(firstImageView)
        addSubview(indicator)

        bgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: bgView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bgView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bgView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: bgView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10).isActive = true

        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        let difficultyLabelWidthConst = NSLayoutConstraint(item: difficultyLabel, attribute: .width, relatedBy: .equal, toItem: bgView, attribute: .width, multiplier: 0.5, constant: 0)
        let difficultyLabelCenterXConst = NSLayoutConstraint(item: difficultyLabel, attribute: .left, relatedBy: .equal, toItem: bgView, attribute: .centerX, multiplier: 1, constant: 0)
        let difficultyLabelCenterYConst = NSLayoutConstraint(item: difficultyLabel, attribute: .centerY, relatedBy: .equal, toItem: bgView, attribute: .centerY, multiplier: 1, constant: 0)
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
        let indicatorCenterX = NSLayoutConstraint(item: indicator, attribute: .centerX, relatedBy: .equal, toItem: bgView, attribute: .centerX, multiplier: 0.5, constant: 0)
        let indicatorCenterY = NSLayoutConstraint(item: indicator, attribute: .centerY, relatedBy: .equal, toItem: bgView, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([indicatorCenterX, indicatorCenterY])

        firstImageView.translatesAutoresizingMaskIntoConstraints = false
        let imageLeftConst = NSLayoutConstraint(item: firstImageView, attribute: .leading, relatedBy: .equal, toItem: bgView, attribute: .leading, multiplier: 1, constant: 0)
        let imageRightConst = NSLayoutConstraint(item: firstImageView, attribute: .trailing, relatedBy: .equal, toItem: bgView, attribute: .centerX, multiplier: 1, constant: -10)
        let imageTopConst = NSLayoutConstraint(item: firstImageView, attribute: .top, relatedBy: .equal, toItem: bgView, attribute: .top, multiplier: 1, constant: 0)
        let imageBottomConst = NSLayoutConstraint(item: firstImageView, attribute: .bottom, relatedBy: .equal, toItem: bgView, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([imageLeftConst, imageRightConst, imageTopConst, imageBottomConst])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
