import UIKit

class RouteAreaView: UIView {

    var imageView: UIImageView!
    var titleButton: UIButton!
    var cityStateLabel: UILabel!
    var viewMapButton: UIButton!

    var delegate: RouteAreaViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#18191A")

        // init views
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1

        titleButton = UIButton()
        titleButton.titleLabel?.textColor = .white
        titleButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 20)
        titleButton.addTarget(self, action: #selector(hitTitleButton), for: .touchUpInside)

        cityStateLabel = UILabel()
        cityStateLabel.textColor = UIColor(hex: "#4E4E50")
        cityStateLabel.font = UIFont(name: "Avenir-Black", size: 15)

        viewMapButton = UIButton()
        viewMapButton.backgroundColor = UIColor(hex: "#D9D9D9")
        viewMapButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 20)
        viewMapButton.setTitle("View on Map", for: .normal)
        viewMapButton.setTitleColor(UIColor(hex: "#555555"), for: .normal)
        viewMapButton.addTarget(self, action: #selector(hitMapButton), for: .touchUpInside)

        addSubview(imageView)
        addSubview(titleButton)
        addSubview(cityStateLabel)
        addSubview(viewMapButton)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 2 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 1, constant: 0).isActive = true

        titleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: titleButton, attribute: .leading, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: titleButton, attribute: .bottom, relatedBy: .equal, toItem: cityStateLabel, attribute: .top, multiplier: 1, constant: -5).isActive = true
        NSLayoutConstraint(item: titleButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true

        cityStateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: cityStateLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: cityStateLabel, attribute: .leading, relatedBy: .equal, toItem: titleButton, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: cityStateLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: cityStateLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true

        viewMapButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: viewMapButton, attribute: .top, relatedBy: .equal, toItem: cityStateLabel, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: viewMapButton, attribute: .leading, relatedBy: .equal, toItem: titleButton, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: viewMapButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: viewMapButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true

    }

    @objc
    func hitTitleButton() {
        // TODO: Impliment a segue to the area view
    }

    @objc
    func hitMapButton() {
        delegate?.hitMapButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        viewMapButton.layer.cornerRadius = 9
        viewMapButton.clipsToBounds = true
    }
}

protocol RouteAreaViewDelegate: class {
    func hitMapButton()
}
