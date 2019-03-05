import UIKit

class ArButton: UIButton {

    var diagramImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        myInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        myInit()
    }

    func myInit() {
        setImage(UIImage(named: "icon_ar"), for: .normal)
        imageView?.contentMode = .scaleAspectFill

        diagramImageView = UIImageView()
        diagramImageView.contentMode = .scaleAspectFill
        diagramImageView.clipsToBounds = true
        clipsToBounds = true

        addSubview(diagramImageView)

        diagramImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: diagramImageView, attribute: .leading, relatedBy: .equal, toItem: self.imageView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: diagramImageView, attribute: .trailing, relatedBy: .equal, toItem: self.imageView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: diagramImageView, attribute: .top, relatedBy: .equal, toItem: self.imageView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: diagramImageView, attribute: .bottom, relatedBy: .equal, toItem: self.imageView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }

    func setImages(image: UIImage?, diagramImage: UIImage?) {
        setImage(image, for: .normal)
        diagramImageView.image = diagramImage
    }
}
