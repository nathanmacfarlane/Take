import UIKit

class RouteAddArVC: UIViewController {

    var rockLabel: UILabel!
    var centerArButton: UIButton!
    var leftArButton: UIButton!
    var rightArButton: UIButton!
    var cancelButton: UIButton!
    var saveButton: UIButton!

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
        rockLabel.font = UIFont(name: "Avenir-Black", size: 80)
        rockLabel.textColor = .black

        centerArButton = UIButton()
        centerArButton.setImage(UIImage(named: "icon_ar"), for: .normal)
        centerArButton.addTarget(self, action: #selector(selectImage(sender:)), for: .touchUpInside)

        leftArButton = UIButton()
        leftArButton.setImage(UIImage(named: "icon_ar"), for: .normal)
        leftArButton.addTarget(self, action: #selector(selectImage(sender:)), for: .touchUpInside)

        rightArButton = UIButton()
        rightArButton.setImage(UIImage(named: "icon_ar"), for: .normal)
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
        let promptLabel2 = UILabel()
        promptLabel2.textColor = UIColor(hex: "#BEBEBE")
        promptLabel2.font = UIFont(name: "Avenir-Book", size: 18)
        promptLabel2.numberOfLines = 0
        promptLabel2.text = "To begin, move to the corresponding location and tap on AR icon above."

        view.addSubview(saveButton)
        view.addSubview(cancelButton)
        view.addSubview(rockLabel)
        view.addSubview(centerArButton)
        view.addSubview(leftArButton)
        view.addSubview(rightArButton)
        view.addSubview(promptLabel)
        view.addSubview(promptLabel2)

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
        NSLayoutConstraint(item: rockLabel, attribute: .top, relatedBy: .equal, toItem: cancelButton, attribute: .bottom, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: rockLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70).isActive = true

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

        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: promptLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: promptLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -25).isActive = true
        NSLayoutConstraint(item: promptLabel, attribute: .bottom, relatedBy: .equal, toItem: promptLabel2, attribute: .top, multiplier: 1, constant: -10).isActive = true

        promptLabel2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: promptLabel2, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: promptLabel2, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -25).isActive = true
        NSLayoutConstraint(item: promptLabel2, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -80).isActive = true
    }

    @objc
    func goCancel() {
        dismiss(animated: true, completion: nil)
    }

    @objc
    func goSave() {
        // TODO: - impliment firebase actions and then dismiss
    }

    @objc
    func selectImage(sender: UIButton) {
        ImagePickerManager().pickImage(self) { image in
            sender.setImage(image, for: .normal)
            sender.imageView?.layer.cornerRadius = 5
        }
    }

    override func viewDidLayoutSubviews() {
        let lineView = LineView(frame: view.bounds, from: rockLabel.getOutsidePoint(side: .bottom, padding: 10), to: centerArButton.getOutsidePoint(side: .top, padding: 10))
        view.addSubview(lineView)
        let lineView2 = LineView(frame: view.bounds, from: rockLabel.getOutsidePoint(side: .bottom, padding: 10), to: leftArButton.getOutsidePoint(side: .top, padding: 10))
        view.addSubview(lineView2)
        let lineView3 = LineView(frame: view.bounds, from: rockLabel.getOutsidePoint(side: .bottom, padding: 10), to: rightArButton.getOutsidePoint(side: .top, padding: 10))
        view.addSubview(lineView3)
        view.bringSubviewToFront(cancelButton)
        view.bringSubviewToFront(saveButton)
        view.bringSubviewToFront(leftArButton)
        view.bringSubviewToFront(centerArButton)
        view.bringSubviewToFront(rightArButton)
    }

}

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;

    override init(){
        super.init()
    }

    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;

        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }

        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        viewController.present(alert, animated: true, completion: nil)
    }
    func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.viewController!.present(picker, animated: true, completion: nil)
        }
    }
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

      // For Swift 4.2
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          picker.dismiss(animated: true, completion: nil)
          guard let image = info[.originalImage] as? UIImage else {
              fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
          }
          pickImageCallback?(image)
      }

    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
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
