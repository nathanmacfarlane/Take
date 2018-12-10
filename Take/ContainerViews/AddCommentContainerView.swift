import Firebase
import FirebaseAuth
import FirebaseFirestore
import UIKit

class AddCommentContainerView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Injections
    var routeViewModel: RouteViewModel!

    // MARK: - Outlets
    var imageView: UIImageView!
    var messageView: UITextView!
    var saveButton: UIButton!
    var tapRec: UITapGestureRecognizer!
    var imagePicker: UIImagePickerController!

    // MARK: - Delegates
    weak var delegate: CommentDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        initViews()
    }

    func initViews() {
        view.backgroundColor = UIColor(named: "BluePrimary")

        tapRec = UITapGestureRecognizer()

        saveButton = UIButton()
        saveButton.setTitle("Upload Photo", for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Avenir", size: 14)
        saveButton.addTarget(self, action: #selector(saveComment), for: .touchUpInside)
        saveButton.backgroundColor = UIColor(named: "BluePrimaryDark")
        view.addSubview(saveButton)

        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        tapRec.addTarget(self, action: #selector(addImage))
        imageView.addGestureRecognizer(tapRec)
        view.addSubview(imageView)

        messageView = UITextView()
        view.addSubview(messageView)
        messageView.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        messageView.textColor = .white
        messageView.becomeFirstResponder()

        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: saveButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .trailing, relatedBy: .equal, toItem: imageView, attribute: .leading, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .top, relatedBy: .equal, toItem: messageView, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -10).isActive = true

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 1.0, constant: 0).isActive = true

        messageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: messageView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: messageView, attribute: .trailing, relatedBy: .equal, toItem: imageView, attribute: .leading, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: messageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: messageView, attribute: .bottom, relatedBy: .equal, toItem: saveButton, attribute: .top, multiplier: 1, constant: -10).isActive = true

        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.addBorder(color: .white, width: 1)

        view.layer.cornerRadius = 5
        view.clipsToBounds = true

        messageView.layer.cornerRadius = 5
        messageView.clipsToBounds = true

        saveButton.layer.cornerRadius = 5
        saveButton.clipsToBounds = true
    }

    // MARK: - Image Picker
    @objc
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            self.imageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @objc
    func saveComment() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        var comment = Comment(id: UUID().uuidString, userId: userId, dateString: Date().instanceString(), message: self.messageView.text, imageUrl: nil)
        guard let image = imageView.image else { return }
        self.delegate?.toggleCommentView()
        self.delegate?.addNewComment(comment: comment, photo: image)
        imageView.image?.saveToFb(route: routeViewModel.route) { url in
            comment.setImageUrl(imageUrl: url?.absoluteString)
            Firestore.firestore().save(object: comment, to: "comments", with: comment.getId(), completion: nil)
            self.routeViewModel.route.comments.append(comment.getId())
            Firestore.firestore().save(object: self.routeViewModel.route, to: "routes", with: self.routeViewModel.id, completion: nil)
            self.imageView.image = UIImage()
            self.messageView.text = ""
        }
    }

    @objc
    func addImage() {
        present(imagePicker, animated: true, completion: nil)
    }
}
