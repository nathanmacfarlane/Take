import UIKit

class RoutePhotosCVC: UICollectionViewCell {
    var bgImageView: UIImageView!
    var dgImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        // bgImage view
        bgImageView = UIImageView()
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.backgroundColor = UIColor(hex: "#111114")
        self.backgroundColor = .clear
        addSubview(bgImageView)
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: bgImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bgImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bgImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bgImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

        // bgImage view
        dgImageView = UIImageView()
        dgImageView.contentMode = .scaleAspectFill
        dgImageView.backgroundColor = .clear
        self.backgroundColor = .clear
        addSubview(dgImageView)
        dgImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: dgImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dgImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dgImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dgImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5.0
        bgImageView.clipsToBounds = true
        dgImageView.clipsToBounds = true
        self.clipsToBounds = true
        self.addBorder(color: .white, width: 1)
    }
}
