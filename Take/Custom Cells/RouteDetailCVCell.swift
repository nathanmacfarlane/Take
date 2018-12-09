import UIKit

class RouteDetailCVCell: UICollectionViewCell {

    var imageView: UIImageView!

    func initImage(image: UIImage) {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        imageView.roundView(portion: 2)
        imageView.addBorder(color: .white, width: 1.0)
        self.addSubview(imageView)
    }
}
