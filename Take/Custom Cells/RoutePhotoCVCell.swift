import UIKit

class RoutePhotoCVCell: UICollectionViewCell {
    var imageView: UIImageView!

    func initImage(image: UIImage) {
        imageView = UIImageView()
        imageView.image = image
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
        NSLayoutConstraint(item: usernameLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: usernameLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -5).isActive = true
        NSLayoutConstraint(item: usernameLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: usernameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.layer.cornerRadius = 5.0
        self.imageView.addBorder(color: .lightGray, width: 1)
    }
}
