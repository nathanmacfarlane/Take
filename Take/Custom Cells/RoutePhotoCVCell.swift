import UIKit

class RoutePhotoCVCell: UICollectionViewCell {
    var imageView: UIImageView!

    func initImage() {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        self.backgroundColor = .clear

        addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }

    func initUserNameLabel(username: String) {
        let usernameLabel = UILabel()
        usernameLabel.text = username
        usernameLabel.textColor = .white
        usernameLabel.font = UIFont(name: "Avenir", size: 14)
        usernameLabel.textAlignment = .left

        addSubview(usernameLabel)

        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: usernameLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: usernameLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: usernameLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: usernameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
    }

    func initMessageLabel(message: String) {

        let bg = UILabel()
        bg.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        bg.clipsToBounds = true

        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont(name: "Avenir", size: 14)
        messageLabel.textAlignment = .left

        addSubview(bg)
        addSubview(messageLabel)

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: messageLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: messageLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: messageLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: messageLabel, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true

        bg.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: bg, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bg, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bg, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bg, attribute: .top, relatedBy: .equal, toItem: messageLabel, attribute: .top, multiplier: 1, constant: -10).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5.0
        self.addBorder(color: .lightGray, width: 1)
    }
}
