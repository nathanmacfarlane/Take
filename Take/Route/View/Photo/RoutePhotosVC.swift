import Blueprints
import FirebaseAuth
import FirebaseFirestore
//import Lightbox
import UIKit

class RoutePhotosVC: UIViewController {

    // MARK: - Injections
    var routeViewModel: RouteViewModel!

    // MARK: - Outlets
    var myImagesCV: UICollectionView!

    struct ARImageComment {
        var image: ARImageUrls
        var comment: String?
    }

    // MARK: - Variables
    var images: [ARImageComment] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initViews()

        for item in self.routeViewModel.route.routeArUrls {
            if item.value.isEmpty { continue }
            let image = ARImageUrls(dgImage: item.value[1], bgImage: item.value[0])
            let arImageContent = ARImageComment(image: image, comment: nil)
            images.append(arImageContent)
        }

        DispatchQueue.global(qos: .background).async {
            for commentId in self.routeViewModel.route.comments {
                FirestoreService.shared.fs.query(collection: "comments", by: "id", with: commentId, of: Comment.self) { comments in
                    guard let comment = comments.first, let imgUrl = CommentViewModel(comment: comment).imageUrl else { return }
                    let image = ARImageUrls(bgImage: imgUrl)
                    let arImageContent = ARImageComment(image: image, comment: comment.message)
                    DispatchQueue.main.async {
                        self.images.append(arImageContent)
                        if self.images.count == self.routeViewModel.route.comments.count + self.routeViewModel.route.routeArUrls.count {
                            self.myImagesCV.reloadData()
                        }
                    }
                }
            }
        }

    }

    func updatedImages(message: String, images: [UIImage]) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        for image in images {
            var comment = Comment(id: UUID().uuidString, userId: userId, dateString: "\(Date().timeIntervalSince1970)", message: message, imageUrl: nil, routeId: routeViewModel.id)
            image.saveToFb(route: routeViewModel.route) { url in
                comment.imageUrl = url?.absoluteString
                FirestoreService.shared.fs.save(object: comment, to: "comments", with: comment.id, completion: nil)
                self.routeViewModel.route.comments.append(comment.id)
                FirestoreService.shared.fs.save(object: self.routeViewModel.route, to: "routes", with: self.routeViewModel.id, completion: nil)
                let arImageComment = ARImageComment(image: ARImageUrls(bgImage: url?.absoluteString), comment: message)
                self.images.append(arImageComment)
                self.myImagesCV.insertItems(at: [IndexPath(item: self.images.count - 1, section: 0)])
            }
        }

    }

    func initViews() {
        self.view.backgroundColor = UIColor(named: "BluePrimaryDark")
        self.title = routeViewModel.name

        let waterfallLayout = VerticalBlueprintLayout(
            itemsPerRow: 2,
            itemSize: CGSize(width: view.frame.width / 3, height: view.frame.width / 1.5),
            minimumInteritemSpacing: 10,
            minimumLineSpacing: 10,
            sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10))

        myImagesCV = UICollectionView(frame: .zero, collectionViewLayout: waterfallLayout)
        myImagesCV.register(RoutePhotosCVC.self, forCellWithReuseIdentifier: "RoutePhotoCVCell")
        myImagesCV.delegate = self
        myImagesCV.dataSource = self
        myImagesCV.backgroundColor = .clear
        myImagesCV.showsHorizontalScrollIndicator = false

        view.addSubview(myImagesCV)

        myImagesCV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: myImagesCV, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: myImagesCV, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: myImagesCV, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: myImagesCV, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

    }

}
