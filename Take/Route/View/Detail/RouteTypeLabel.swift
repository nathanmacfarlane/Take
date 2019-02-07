import UIKit

class RouteTypeLabel: UILabel {

    var yInset: CGFloat = 5.0
    var xInset: CGFloat = 10.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        textAlignment = .center
        backgroundColor = UIColor(hex: "#4A4E53")
        textColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 5
        clipsToBounds = true
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + xInset + xInset, height: size.height + yInset + yInset)
    }

}
