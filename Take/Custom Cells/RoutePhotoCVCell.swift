import UIKit

class RoutePhotoCVCell: UICollectionViewCell {
    var imageView: UIImageView!
    func initImage(image: UIImage) {
        imageView = UIImageView(frame: self.frame)
        addSubview(imageView)
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}
