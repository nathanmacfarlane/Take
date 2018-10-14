import UIKit

class RouteDetailDiagramCVCell: UICollectionViewCell {

    var bgImageView: UIImageView!
    var diagramImageView: UIImageView!

    func initImage(bgImage: UIImage, diagramImage: UIImage) {
        bgImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.clipsToBounds = true
        bgImageView.image = bgImage
        bgImageView.roundImage(portion: 2)
        bgImageView.addBorder(color: .white, width: 1.0)

        diagramImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        diagramImageView.contentMode = .scaleAspectFill
        diagramImageView.clipsToBounds = true
        diagramImageView.image = bgImage
        diagramImageView.roundImage(portion: 2)
        diagramImageView.addBorder(color: .white, width: 1.0)

        self.addSubview(bgImageView)
        self.addSubview(diagramImageView)
    }
}
