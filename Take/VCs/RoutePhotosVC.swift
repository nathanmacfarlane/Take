import Blueprints
import FirebaseFirestore
import SDWebImage
import UIKit

class RoutePhotosVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CommentDelegate, UIScrollViewDelegate {

    // MARK: - Injections
    var route: Route!

    // MARK: - Outlets
    var bgImageView: UIImageView!
    var myImagesCV: UICollectionView!
    var commentCV: AddCommentContainerView!

    // MARK: - Variables
    var comments: [String: Comment] = [:]
    var commentKeys: [String] = []
    var images: [String: UIImage] = [:]
    var imagesCVConst: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!
    var isAddingComment: Bool = false

    // MARK: - Protocols
    weak var delegate: CommentDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initViews()

        DispatchQueue.global(qos: .background).async {
            for commentId in self.route.comments {
                let db = Firestore.firestore()
                db.query(type: Comment.self, by: "id", with: commentId) { comments in
                    if let comment = comments.first {
                        if let imgUrl = comment.imageUrl, let theUrl = URL(string: imgUrl) {
                            self.comments[commentId] = comment
                            self.images[commentId] = UIImage()

                            URLSession.shared.dataTask(with: theUrl) { data, _, _ in
                                guard let theData = data, let theImage = UIImage(data: theData) else { return }
                                self.images[commentId] = theImage
                                DispatchQueue.main.async {
                                    self.myImagesCV.reloadData()
                                }
                            }
                            .resume()

                            self.commentKeys.append(commentId)
                            DispatchQueue.main.async {
                                self.myImagesCV.reloadData()
                            }
                        }
                    }
                }
            }
        }

    }

    // MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commentKeys.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == myImagesCV, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoutePhotoCVCell", for: indexPath) as? RoutePhotoCVCell,
            let comment = comments[commentKeys[indexPath.row]] {
            cell.imageView.image = images[comment.id]
            return cell
        }
        return UICollectionViewCell()
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == myImagesCV && isAddingComment {
            toggleCommentView()
        }
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

        // add comment view
        commentCV = AddCommentContainerView()
        commentCV.route = route
        commentCV.delegate = self

        let waterfallLayout = VerticalBlueprintLayout(
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
        view.addSubview(commentCV.view)
        view.addSubview(myImagesCV)

        addChildViewController(commentCV)

        commentCV.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: commentCV.view, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: commentCV.view, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: commentCV.view, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 60).isActive = true
        heightConstraint = NSLayoutConstraint(item: commentCV.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        heightConstraint.isActive = true
        commentCV.didMove(toParentViewController: self)

        myImagesCV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: myImagesCV, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: myImagesCV, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: myImagesCV, attribute: .top, relatedBy: .equal, toItem: commentCV.view, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: myImagesCV, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

    }

    // MARK: - Comment Delegate
    func toggleCommentView() {
        isAddingComment = !isAddingComment
        self.heightConstraint.constant = isAddingComment ? 140 : 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    func addNewComment(comment: Comment, photo: UIImage) {
        comments[comment.id] = comment
        images[comment.id] = photo
        commentKeys.insert(comment.id, at: 0)
        myImagesCV.reloadData()
    }

}
