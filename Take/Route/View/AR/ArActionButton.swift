import UIKit

class ArActionButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    convenience init(color: UIColor?, title: String) {
        self.init()
        backgroundColor = color
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont(name: "Avenir-Book", size: 18)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        clipsToBounds = true
    }

}
