import Blueprints
import FirebaseFirestore
import SDWebImage
import UIKit

class RoutePhotosVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var bgImageView: UIImageView!
    var route: Route!
//    var imageKeys: [String] = []
//    var images: [String: UIImage] = [:]
    var images: [UIImage] = []
    var comments: [String: Comment] = [:]
    var commentKeys: [String] = []
//    var diagramKeys: [String] = []
//    var diagrams: [String: [UIImage]] = [:]

    var myImagesCV: UICollectionView!
//    var myDiagramsCV: UICollectionView!
    var imagesCVConst: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initViews()

        DispatchQueue.global(qos: .background).async {
            for commentId in self.route.comments {
                let db = Firestore.firestore()
                db.query(type: Comment.self, by: "id", with: commentId) { comments in
                    if let comment = comments.first {
                        if !comment.imageUrls.isEmpty {
                            self.comments[commentId] = comment
                            self.commentKeys.append(commentId)
                            DispatchQueue.main.async {
                                self.myImagesCV.reloadData()
                            }
                        }

//                        for imageUrl in comment.imageUrls {
//                            guard let theURL = URL(string: imageUrl.value) else { continue }
//                            URLSession.shared.dataTask(with: theURL) { data, _, _ in
//                                guard let theData = data, let theImage = UIImage(data: theData) else { return }
//                                self.images.append(theImage)
//                                DispatchQueue.main.async {
//                                    self.myImagesCV.reloadData()
//                                }
//                            }
//                            .resume()
//                        }

                    }
                }
            }
        }

    }

    // MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return imageKeys.count
        return commentKeys.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == myImagesCV, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoutePhotoCVCell", for: indexPath) as? RoutePhotoCVCell,
            let comment = comments[commentKeys[indexPath.row]] {
//            if let cellImage = self.images[self.imageKeys[indexPath.row]] {
//                cell.initImage(image: cellImage)
//            }
//            cell.initImage(image: self.images[indexPath.row])
            cell.initImage()
            if let imageUrl = comment.imageUrls.first?.value {
                cell.imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "SLO.jpg"))
            }
            Firestore.firestore().query(type: User.self, by: "id", with: comment.userId) { users in
                if let user = users.first {
                    DispatchQueue.main.async {
                        cell.initUserNameLabel(username: "@\(user.username)")
                    }
                }
            }
            if let message = comment.message {
                cell.initMessageLabel(message: message)
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
            itemSize: CGSize(width: view.frame.width / 3, height: view.frame.width / 1.5),
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
