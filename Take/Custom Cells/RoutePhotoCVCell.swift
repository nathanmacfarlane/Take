import UIKit

class RoutePhotoCVCell: UICollectionViewCell {
    var imageView: UIImageView!
//    var usernameLabel: UILabel!
//    var dateLabel: UILabel!
//    var messageLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        // image view
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(hexString: "#111114")
        imageView.clipsToBounds = true
        self.backgroundColor = .clear
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
//        // username label
//        usernameLabel = UILabel()
//        usernameLabel.textColor = .white
//        usernameLabel.font = UIFont(name: "Avenir", size: 16)
//        usernameLabel.textAlignment = .left
//        addSubview(usernameLabel)
//        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint(item: usernameLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10).isActive = true
//        NSLayoutConstraint(item: usernameLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
//        NSLayoutConstraint(item: usernameLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10).isActive = true
//        NSLayoutConstraint(item: usernameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
//        // date label
//        dateLabel = UILabel()
//        dateLabel.textColor = .white
//        dateLabel.font = UIFont(name: "Avenir", size: 14)
//        dateLabel.textAlignment = .left
//        addSubview(dateLabel)
//        dateLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint(item: dateLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10).isActive = true
//        NSLayoutConstraint(item: dateLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
//        NSLayoutConstraint(item: dateLabel, attribute: .top, relatedBy: .equal, toItem: usernameLabel, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
//        NSLayoutConstraint(item: dateLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
//        // message label
//        let bg = UILabel()
//        bg.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        bg.clipsToBounds = true
//        messageLabel = UILabel()
//        messageLabel.textColor = .white
//        messageLabel.numberOfLines = 0
//        messageLabel.font = UIFont(name: "Avenir", size: 14)
//        messageLabel.textAlignment = .left
//        addSubview(bg)
//        addSubview(messageLabel)
//        messageLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint(item: messageLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10).isActive = true
//        NSLayoutConstraint(item: messageLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
//        NSLayoutConstraint(item: messageLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
//        NSLayoutConstraint(item: messageLabel, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
//        bg.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint(item: bg, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: bg, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: bg, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: bg, attribute: .top, relatedBy: .equal, toItem: messageLabel, attribute: .top, multiplier: 1, constant: -10).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5.0
        self.addBorder(color: .white, width: 1)
    }
}
