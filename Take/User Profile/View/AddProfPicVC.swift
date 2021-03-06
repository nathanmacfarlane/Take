//import Blueprints
import Photos
import UIKit

class AddProfPicVC: UIViewController, PHPhotoLibraryChangeObserver, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    var saveButton: UIButton!
    var commentField: UITextView!
    var commentFieldBg: UILabel!
    var collectionView: UICollectionView!
    var keyboardConstraint: NSLayoutConstraint?
    var imgWidth = 100
    var imgHeight = 150
    
    var selected = Set<Int>()
    
    var allPhotos: PHFetchResult<PHAsset>!
    
    var user: User?
    var userId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.fetchLimit = 100
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        
        initViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardConstraint?.constant = -1 * (keyboardSize.height + 60)
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
    
    @objc
    func tappedBg() {
        dismiss(animated: true, completion: nil)
    }
    
    func initViews() {
        view.backgroundColor = .clear
        
        view.isUserInteractionEnabled = true
        let tapBgGesture = UITapGestureRecognizer(target: self, action: #selector(tappedBg))
        tapBgGesture.delegate = self
        view.addGestureRecognizer(tapBgGesture)
        
        saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = UIColor(hex: "#4D4D50")
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 17)
        saveButton.addTarget(self, action: #selector(hitSave), for: .touchUpInside)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RoutePhotosCVC.self, forCellWithReuseIdentifier: "RoutePhotoCVCell")
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false 
        
        view.addSubview(saveButton)
        view.addSubview(collectionView)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: saveButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 115).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 45).isActive = true
        
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: saveButton, attribute: .bottom, multiplier: 1, constant: 50).isActive = true
//        keyboardConstraint = NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -240)
//        keyboardConstraint?.isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        if selected.contains(indexPath.row) {
            selected.remove(indexPath.row)
            cell.addBorder(color: .white, width: 1)
        } else {
            selected.insert(indexPath.row)
            cell.addBorder(color: .white, width: 5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        return CGSize(width: width/3.5, height: height/3.5)
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
    
    func photoLibraryDidChange(_ changeInstance: PHChange) { }
    
    @objc
    func hitSave() {
        guard let user = self.user, let userId = self.userId else { return }
        var u = user
        for i in selected {
            guard let cell = collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? RoutePhotosCVC, let image = cell.bgImageView.image else { continue }
            
            image.saveProfPicToFb(user: user) { url in
                u.profilePhotoUrl = url?.absoluteString
                FirestoreService.shared.fs.save(object: u, to: "users", with: user.id, completion: nil)
                self.user?.profilePhotoUrl = u.profilePhotoUrl
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        saveButton.layer.cornerRadius = 12
        saveButton.clipsToBounds = true
    }
    
}
