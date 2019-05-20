import Photos
import SwiftyDraw
import UIImageColors
import UIKit

class RouteArEditVC: UIViewController, PHPhotoLibraryChangeObserver, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var collectionView: UICollectionView!
    var allPhotos: PHFetchResult<PHAsset>!

    // swifty draw stuff
    var bgImageView: UIImageView!
    var canvasView: SwiftyDrawView!

    // colors to pass
    var backgroundColor: UIColor?
    var primaryColor: UIColor?
    var secondaryColor: UIColor?
    var detailColor: UIColor?

    // injections
    var bgImage: UIImage {
        get {
            return bgImageView.image ?? UIImage()
        }
        set {
            newValue.getColors { colors in
                self.canvasView.brush.color = colors.secondary
                self.backgroundColor = colors.background
                self.primaryColor = colors.primary
                self.secondaryColor = colors.secondary
                self.detailColor = colors.detail
            }
            bgImageView.image = newValue
            canvasView.clear()
        }
    }
    var delegate: RouteArEditProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BluePrimaryDark")

        PHPhotoLibrary.shared().register(self)

        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.fetchLimit = 20
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)

        initViews()

        getImageFromCameraRoll(index: 0) { image in
            DispatchQueue.main.async {
                self.bgImageView.image = image
                if let image = image {
                    self.bgImage = image
                }
            }
        }
        bgImageView.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        bgImageView.clipsToBounds = true
        canvasView.clipsToBounds = true
        canvasView.contentMode = .scaleAspectFill

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        getImageFromCameraRoll(index: indexPath.row) { image in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self.bgImage = image
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 75)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoutePhotoCVCell", for: indexPath) as? RoutePhotosCVC {
            getImageFromCameraRoll(index: indexPath.row) { image in
                DispatchQueue.main.async {
                    cell.bgImageView.image = image
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }

    func getImageFromCameraRoll(index: Int, completion: @escaping (_ image: UIImage?) -> Void) {
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        PHImageManager.default().requestImage(for: allPhotos.object(at: index) as PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.aspectFill, options: requestOptions) { image, _ in
            if let image = image {
                completion(image)
            }
        }
    }

    func photoLibraryDidChange(_ changeInstance: PHChange) {

    }

    func initViews() {

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.scrollDirection = .horizontal

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.register(RoutePhotosCVC.self, forCellWithReuseIdentifier: "RoutePhotoCVCell")
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false

        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 75).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

        // swifty draw stuff

        canvasView = SwiftyDrawView()
        canvasView.delegate = self
        canvasView.brush.width = 8

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        canvasView.addGestureRecognizer(longPressGesture)

        bgImageView = UIImageView()

        view.addSubview(bgImageView)
        view.addSubview(canvasView)

        canvasView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: canvasView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: canvasView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: canvasView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: canvasView, attribute: .bottom, relatedBy: .equal, toItem: bgImageView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: bgImageView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bgImageView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bgImageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bgImageView, attribute: .bottom, relatedBy: .equal, toItem: collectionView, attribute: .top, multiplier: 1, constant: -20).isActive = true
    }

}
