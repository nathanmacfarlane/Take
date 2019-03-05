import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Presentr
import UIKit

class RouteAddArVC: UIViewController, RouteArEditProtocol, UITextViewDelegate {

    // injections
    var route: Route?

    var rockLabel: UILabel!
    var centerArButton: ArButton!
    var leftArButton: ArButton!
    var rightArButton: ArButton!
    var commentBg: UILabel!
    var commentField: UITextView!

    var cancelButton: UIButton!
    var saveButton: UIButton!

    var selectedButton: ArButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hex: "#202226")

        cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 20)
        cancelButton.addTarget(self, action: #selector(goCancel), for: .touchUpInside)

        saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 20)
        saveButton.addTarget(self, action: #selector(goSave), for: .touchUpInside)

        rockLabel = UILabel()
        rockLabel.text = "ROCK"
        rockLabel.textAlignment = .center
        rockLabel.font = UIFont(name: "Avenir-Black", size: 40)
        rockLabel.textColor = .black

        centerArButton = ArButton()
        centerArButton.addTarget(self, action: #selector(selectImage(sender:)), for: .touchUpInside)

        leftArButton = ArButton()
        leftArButton.addTarget(self, action: #selector(selectImage(sender:)), for: .touchUpInside)

        rightArButton = ArButton()
        rightArButton.addTarget(self, action: #selector(selectImage(sender:)), for: .touchUpInside)

        let promptLabel = UILabel()
        promptLabel.textColor = UIColor(hex: "#BEBEBE")
        promptLabel.font = UIFont(name: "Avenir-Book", size: 18)
        promptLabel.numberOfLines = 0
        let str = "If possible, please upload 3 photos from different positions around the rock (roughly 10 feet apart). This improves the accuracy for future climbers."
        if let font = UIFont(name: "Avenir-Book", size: 18), let color = UIColor(named: "PinkAccentDark"), let start = str.index(of: "(") {
            let myMutableString = NSMutableAttributedString(string: str, attributes: [.font: font])
            myMutableString.addAttribute(.foregroundColor, value: color, range: NSRange(location: start.encodedOffset, length: "(roughly 10 feet apart)".count))
            promptLabel.attributedText = myMutableString
        }

        commentBg = UILabel()
        commentBg.backgroundColor = .white

        commentField = UITextView()
        commentField.textColor = .black
        commentField.backgroundColor = .clear
        commentField.font = UIFont(name: "Avenir-Book", size: 14)
        commentField.delegate = self
        commentField.returnKeyType = .done

        view.addSubview(saveButton)
        view.addSubview(cancelButton)
        view.addSubview(rockLabel)
        view.addSubview(centerArButton)
        view.addSubview(leftArButton)
        view.addSubview(rightArButton)
        view.addSubview(promptLabel)
        view.addSubview(commentBg)
        view.addSubview(commentField)

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: cancelButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: cancelButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: cancelButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: cancelButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true

        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: saveButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true

        rockLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: rockLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: rockLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: rockLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: rockLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true

        centerArButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: centerArButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: centerArButton, attribute: .bottom, relatedBy: .equal, toItem: promptLabel, attribute: .top, multiplier: 1, constant: -30).isActive = true
        NSLayoutConstraint(item: centerArButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35).isActive = true
        NSLayoutConstraint(item: centerArButton, attribute: .width, relatedBy: .equal, toItem: centerArButton, attribute: .height, multiplier: 1, constant: 0).isActive = true

        leftArButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: leftArButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 0.45, constant: 0).isActive = true
        NSLayoutConstraint(item: leftArButton, attribute: .centerY, relatedBy: .equal, toItem: centerArButton, attribute: .centerY, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: leftArButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35).isActive = true
        NSLayoutConstraint(item: leftArButton, attribute: .width, relatedBy: .equal, toItem: leftArButton, attribute: .height, multiplier: 1, constant: 0).isActive = true

        rightArButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: rightArButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.5, constant: 0).isActive = true
        NSLayoutConstraint(item: rightArButton, attribute: .centerY, relatedBy: .equal, toItem: centerArButton, attribute: .centerY, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: rightArButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35).isActive = true
        NSLayoutConstraint(item: rightArButton, attribute: .width, relatedBy: .equal, toItem: rightArButton, attribute: .height, multiplier: 1, constant: 0).isActive = true

        commentBg.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: commentBg, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: commentBg, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -25).isActive = true
        NSLayoutConstraint(item: commentBg, attribute: .bottom, relatedBy: .equal, toItem: rockLabel, attribute: .top, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: commentBg, attribute: .top, relatedBy: .equal, toItem: cancelButton, attribute: .bottom, multiplier: 1, constant: 20).isActive = true

        commentField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: commentField, attribute: .leading, relatedBy: .equal, toItem: commentBg, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: commentField, attribute: .trailing, relatedBy: .equal, toItem: commentBg, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: commentField, attribute: .bottom, relatedBy: .equal, toItem: commentBg, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: commentField, attribute: .top, relatedBy: .equal, toItem: commentBg, attribute: .top, multiplier: 1, constant: 10).isActive = true

        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: promptLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: promptLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -25).isActive = true
        NSLayoutConstraint(item: promptLabel, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -25).isActive = true
    }

    func finishedEditingAr(image: UIImage?, diagram: UIImage?) {
        guard let selectedButton = self.selectedButton else { return }
        selectedButton.setImages(image: image, diagramImage: diagram)
        selectedButton.imageView?.layer.cornerRadius = 5
    }

    func canceledEditingAr() {

    }

    @objc
    func goCancel() {
        dismiss(animated: true, completion: nil)
    }

    @objc
    func goSave() {

        if leftArButton.diagramImageView.image != nil {
            saveDiagramToFB(arButton: leftArButton)
        }

        if centerArButton.diagramImageView.image != nil {
            saveDiagramToFB(arButton: centerArButton)
        }

        if rightArButton.diagramImageView.image != nil {
            saveDiagramToFB(arButton: rightArButton)
        }

        dismiss(animated: true, completion: nil)

    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
            return true
        }
        textView.resignFirstResponder()
        return false
    }

    func saveDiagramToFB(arButton: ArButton) {

        guard let route = route, let userId = Auth.auth().currentUser?.uid else { return }
        let imageRef = Storage.storage().reference().child("Routes/\(route.id)")
        guard let bgImage = arButton.imageView?.image,
            let dgImage = arButton.diagramImageView.image,
            let bgData = bgImage.jpegData(compressionQuality: 0.1) as NSData?,
            let dgData = dgImage.pngData() as NSData? else { return }

        let imageId = UUID().uuidString

        var bgUrl: String = ""
        var dgUrl: String = ""

        _ = imageRef.child("\(imageId)-bgImage.png").putData(bgData as Data, metadata: nil) { metadata, _ in
            guard metadata != nil else { return }
            imageRef.child("\(imageId)-bgImage.png").downloadURL { url, _ in
                guard let downloadURL = url else { return }
                bgUrl = "\(downloadURL)"
                if !dgUrl.isEmpty {
                    let arDiagram = ARDiagram(id: UUID().uuidString, userId: userId, dateString: "\(Date().timeIntervalSince1970)", message: self.commentField.text, dgImageUrl: dgUrl, bgImageUrl: bgUrl, routeId: route.id)
                    FirestoreService.shared.fs.save(object: arDiagram, to: "arDiagrams", with: arDiagram.id) {
                        route.arDiagrams.append(arDiagram.id)
                        FirestoreService.shared.fs.collection("routes").document(route.id).setData([ "arDiagrams": route.arDiagrams ], merge: true)
                    }
                }
            }
        }

        _ = imageRef.child("\(imageId)-dgImage.png").putData(dgData as Data, metadata: nil) { metadata, _ in
            guard metadata != nil else { return }
            imageRef.child("\(imageId)-dgImage.png").downloadURL { url, _ in
                guard let downloadURL = url else { return }
                dgUrl = "\(downloadURL)"
                if !bgUrl.isEmpty {
                    let arDiagram = ARDiagram(id: UUID().uuidString, userId: userId, dateString: "\(Date().timeIntervalSince1970)", message: self.commentField.text, dgImageUrl: dgUrl, bgImageUrl: bgUrl, routeId: route.id)
                    FirestoreService.shared.fs.save(object: arDiagram, to: "arDiagrams", with: arDiagram.id) {
                        route.arDiagrams.append(arDiagram.id)
                        FirestoreService.shared.fs.collection("routes").document(route.id).setData([ "arDiagrams": route.arDiagrams ], merge: true)
                    }
                }
            }
        }

    }

    @objc
    func selectImage(sender: ArButton) {
        selectedButton = sender
        let presenter = Presentr(presentationType: .fullScreen)
        let takeAPhoto = RouteArEditVC()
        takeAPhoto.delegate = self
        customPresentViewController(presenter, viewController: takeAPhoto, animated: true)
    }

    override func viewDidLayoutSubviews() {
        let lineView = LineView(frame: view.bounds, from: rockLabel.getOutsidePoint(side: .bottom, padding: 10), to: centerArButton.getOutsidePoint(side: .top, padding: 10))
        view.addSubview(lineView)
        let lineView2 = LineView(frame: view.bounds, from: rockLabel.getOutsidePoint(side: .bottom, padding: 10), to: leftArButton.getOutsidePoint(side: .top, padding: 10))
        view.addSubview(lineView2)
        let lineView3 = LineView(frame: view.bounds, from: rockLabel.getOutsidePoint(side: .bottom, padding: 10), to: rightArButton.getOutsidePoint(side: .top, padding: 10))
        commentBg.layer.cornerRadius = 10
        commentBg.clipsToBounds = true
        view.addSubview(lineView3)
        view.bringSubviewToFront(cancelButton)
        view.bringSubviewToFront(saveButton)
        view.bringSubviewToFront(leftArButton)
        view.bringSubviewToFront(centerArButton)
        view.bringSubviewToFront(rightArButton)
        view.bringSubviewToFront(commentField)
    }

}

class LineView: UIView {

    var from: CGPoint?
    var to: CGPoint?
    var strokeColor = UIColor(named: "PinkAccentDark")

    init(frame: CGRect, from: CGPoint, to: CGPoint, with strokeColor: UIColor? = nil) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        self.from = from
        self.to = to
        if let sc = strokeColor {
            self.strokeColor = sc
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext(), let from = from, let to = to {
            if let cgC = strokeColor?.cgColor {
                context.setStrokeColor(cgC)
            }
            context.setLineWidth(2)
            context.beginPath()
            context.move(to: from)
            context.addLine(to: to)
            context.strokePath()
        }
    }
}
