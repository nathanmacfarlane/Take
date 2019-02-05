import UIKit

class HypeCommentTVC: HypeTVC {

    var commentImageView: UIImageView!
    var commentLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        commentImageView = UIImageView()
        commentImageView.contentMode = .scaleAspectFill
        commentImageView.clipsToBounds = true
        commentImageView.layer.masksToBounds = true

        commentLabel = UILabel()
        commentLabel.textColor = UIColor(hex: "#BFBFBF")
        commentLabel.font = UIFont(name: "Avenir-Book", size: 18)
        commentLabel.numberOfLines = 0

        self.addSubview(commentImageView)
        self.addSubview(commentLabel)

        commentImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: commentImageView, attribute: .leading, relatedBy: .equal, toItem: nameLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: commentImageView, attribute: .width, relatedBy: .equal, toItem: bgView, attribute: .width, multiplier: 1 / 4, constant: 1).isActive = true
        NSLayoutConstraint(item: commentImageView, attribute: .bottom, relatedBy: .equal, toItem: bgView, attribute: .bottom, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: commentImageView, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120).isActive = true
        NSLayoutConstraint(item: commentImageView, attribute: .top, relatedBy: .equal, toItem: eventLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true

        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: commentLabel, attribute: .leading, relatedBy: .equal, toItem: commentImageView, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: commentLabel, attribute: .trailing, relatedBy: .equal, toItem: bgView, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: commentLabel, attribute: .top, relatedBy: .equal, toItem: eventLabel, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: commentLabel, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true

        NSLayoutConstraint(item: bgView, attribute: .bottom, relatedBy: .equal, toItem: commentLabel, attribute: .bottom, multiplier: 1, constant: 20).isActive = true

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
