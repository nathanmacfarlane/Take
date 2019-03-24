import Foundation
import UIKit

class HypeArTVC: HypeCommentTVC {
    var dgImageView: UIImageView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        dgImageView = UIImageView()
        dgImageView.contentMode = .scaleAspectFill
        dgImageView.clipsToBounds = true
        dgImageView.layer.masksToBounds = true

        self.addSubview(dgImageView)

        dgImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: dgImageView, attribute: .leading, relatedBy: .equal, toItem: self.commentImageView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dgImageView, attribute: .trailing, relatedBy: .equal, toItem: self.commentImageView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dgImageView, attribute: .top, relatedBy: .equal, toItem: self.commentImageView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dgImageView, attribute: .bottom, relatedBy: .equal, toItem: self.commentImageView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
