import Blueprints
import UIKit

class RoutePhotosVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var bgImageView: UIImageView!
    var route: Route!
    var imageKeys: [String] = []
    var images: [String: UIImage] = [:]
//    var diagramKeys: [String] = []
//    var diagrams: [String: [UIImage]] = [:]

    var myImagesCV: UICollectionView!
//    var myDiagramsCV: UICollectionView!
    var imagesCVConst: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initViews()

        DispatchQueue.global(qos: .background).async {
//            self.route.fsLoadAR { diagrams in
//                self.diagrams = diagrams
//                for diagram in self.diagrams {
//                    self.diagramKeys.append(diagram.key)
//                }
//                DispatchQueue.main.async {
//                    self.myDiagramsCV.reloadData()
//                }
//            }

            self.route.fsLoadImages { images in
                self.images = images
                for image in self.images {
                    self.imageKeys.append(image.key)
                }
                DispatchQueue.main.async {
                    if let firstImage = images.first {
                        self.bgImageView.image = firstImage.value
                    }
                    self.myImagesCV.reloadData()
                }
            }
        }

    }

    // MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageKeys.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == myImagesCV, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoutePhotoCVCell", for: indexPath) as? RoutePhotoCVCell {
            if let cellImage = self.images[self.imageKeys[indexPath.row]] {
                cell.initImage(image: cellImage)
            }
            return cell
        }
        return UICollectionViewCell()
    }

    func initViews() {
        self.view.backgroundColor = UIColor(named: "BluePrimary")
        self.title = route.name

        // bg image
        self.bgImageView = UIImageView(frame: self.view.frame)
        self.bgImageView.contentMode = .scaleAspectFill
        self.bgImageView.clipsToBounds = true
        let effect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.frame = self.view.frame
        self.bgImageView.addSubview(effectView)
        let gradientView = UIView(frame: self.view.frame)
        let gradient = CAGradientLayer()
        gradient.frame = gradientView.frame
        gradient.colors = [UIColor(named: "BluePrimaryDark")?.cgColor as Any, UIColor.clear.cgColor]
        gradientView.layer.insertSublayer(gradient, at: 0)

        let waterfallLayout = VerticalWaterfallBlueprintLayout(
            itemsPerRow: 2,
            itemSize: CGSize(width: view.frame.width / 3, height: view.frame.width / 4),
            minimumInteritemSpacing: 10,
            minimumLineSpacing: 10,
            sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10))

        myImagesCV = UICollectionView(frame: .zero, collectionViewLayout: waterfallLayout)
        myImagesCV.register(RoutePhotoCVCell.self, forCellWithReuseIdentifier: "RoutePhotoCVCell")
        myImagesCV.delegate = self
        myImagesCV.dataSource = self
        myImagesCV.backgroundColor = .clear
        myImagesCV.showsHorizontalScrollIndicator = false

        // add to subview
        view.addSubview(bgImageView)
        view.addSubview(gradientView)
        view.addSubview(myImagesCV)

        myImagesCV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: myImagesCV, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: myImagesCV, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: myImagesCV, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: myImagesCV, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

    }

}
