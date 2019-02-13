import UIKit

class RouteView: UIImageView {

    var arImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }

    func initViews() {
        arImageView = UIImageView()

        addSubview(arImageView)

        arImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: arImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: arImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: arImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: arImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }

}
