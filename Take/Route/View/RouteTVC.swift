import UIKit

class RouteTVC: UITableViewCell {

    var nameLabel: UILabel!
    var difficultyLabel: UILabel!
    var typesLabel: UILabel!
    var firstImageView: UIImageView!

    var widthConst: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear

        nameLabel = LabelAvenir(size: 20, type: .Black)
        difficultyLabel = LabelAvenir(size: 17)
        typesLabel = LabelAvenir(size: 17)

        firstImageView = UIImageView()
        firstImageView.contentMode = .scaleAspectFill
        firstImageView.clipsToBounds = true
        firstImageView.layer.cornerRadius = 10

        let bgView = UILabel()
        bgView.backgroundColor = UISettings.shared.mode == .dark ? .black : UIColor(hex: "#C9C9C9")
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true

        addSubview(bgView)
        addSubview(nameLabel)
        addSubview(difficultyLabel)
        addSubview(typesLabel)
        addSubview(firstImageView)

        bgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: bgView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bgView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bgView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: bgView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: difficultyLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: difficultyLabel, attribute: .leading, relatedBy: .equal, toItem: firstImageView, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: difficultyLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: difficultyLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .trailing, relatedBy: .equal, toItem: difficultyLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .bottom, relatedBy: .equal, toItem: difficultyLabel, attribute: .top, multiplier: 1, constant: 5).isActive = true

        typesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: typesLabel, attribute: .leading, relatedBy: .equal, toItem: difficultyLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: typesLabel, attribute: .trailing, relatedBy: .equal, toItem: difficultyLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: typesLabel, attribute: .top, relatedBy: .equal, toItem: difficultyLabel, attribute: .bottom, multiplier: 1, constant: -5).isActive = true

        firstImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: firstImageView, attribute: .leading, relatedBy: .equal, toItem: bgView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: firstImageView, attribute: .top, relatedBy: .equal, toItem: bgView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: firstImageView, attribute: .bottom, relatedBy: .equal, toItem: bgView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        widthConst = NSLayoutConstraint(item: firstImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        widthConst?.isActive = true
    }

    func setImage(image: UIImage?) {
        firstImageView.image = image
        widthConst?.constant = frame.width / 2
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
