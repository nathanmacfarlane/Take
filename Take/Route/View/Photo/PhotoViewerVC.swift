import UIKit

class PhotoViewerVC: UIViewController, UIGestureRecognizerDelegate {

    var dgImage: UIImage?
    var bgImage: UIImage?
    var message: String?

    var bgImageView: UIImageView!
    var dgImageView: UIImageView!
    var messageLabel: UILabel!

    private var startPosition: CGPoint!
    private var originalHeight: CGFloat = 0

    var heightConstraint: NSLayoutConstraint?

    var panGestureRecognizer: UIPanGestureRecognizer?
    var originalPosition: CGPoint?
    var currentPositionTouched: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()

        bgImageView.image = bgImage
        dgImageView.image = dgImage

        messageLabel.text = message

    }

    @objc
    func pannedMessage(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            startPosition = sender.location(in: self.view)
            originalHeight = heightConstraint?.constant ?? 0
        }
        if sender.state == .changed {
            let endPosition = sender.location(in: self.view)
            let difference = endPosition.y - startPosition.y
            let newHeight = originalHeight - difference
            heightConstraint?.constant = newHeight
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }

    @objc
    func tappedBg() {
        if message == nil { return }
        UIView.animate(withDuration: 0.3) {
            self.messageLabel.alpha = self.messageLabel.alpha == 0 ? 1 : 0
        }
    }

    @objc
    func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: view)

        if panGesture.state == .began {
            originalPosition = view.center
            currentPositionTouched = panGesture.location(in: view)
        } else if panGesture.state == .changed && translation.y > 0 {
            view.frame.origin = CGPoint(
                x: 0,
                y: translation.y
            )
        } else if panGesture.state == .ended {

            if translation.y >= view.frame.height / 2 {
                UIView.animate(withDuration: 0.2,
                               animations: {
                        self.view.frame.origin = CGPoint(
                            x: self.view.frame.origin.x,
                            y: self.view.frame.size.height
                        )
                }, completion: { isCompleted in
                    if isCompleted {
                        self.dismiss(animated: false, completion: nil)
                    }
                })
            } else {
                UIView.animate(withDuration: 0.2) {
                    guard let pos = self.originalPosition else { return }
                    self.view.center = pos
                }
            }
        }
    }

    func initViews() {
        let tapBg = UITapGestureRecognizer(target: self, action: #selector(tappedBg))
        tapBg.delegate = self
        view.addGestureRecognizer(tapBg)

        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        if let pan = panGestureRecognizer {
            view.addGestureRecognizer(pan)
        }

        bgImageView = UIImageView()
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.clipsToBounds = true

        dgImageView = UIImageView()
        dgImageView.contentMode = .scaleAspectFill
        dgImageView.clipsToBounds = true

        messageLabel = PaddingLabel()
        messageLabel.textColor = .black
        messageLabel.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        messageLabel.font = UIFont(name: "Avenir-Book", size: 18)
        messageLabel.numberOfLines = 0
        messageLabel.sizeToFit()
        messageLabel.isUserInteractionEnabled = true

        let panMessage = UIPanGestureRecognizer(target: self, action: #selector(pannedMessage))
        messageLabel.addGestureRecognizer(panMessage)

        view.addSubview(bgImageView)
        view.addSubview(dgImageView)
        view.addSubview(messageLabel)

        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: bgImageView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bgImageView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bgImageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bgImageView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

        dgImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: dgImageView, attribute: .leading, relatedBy: .equal, toItem: bgImageView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dgImageView, attribute: .trailing, relatedBy: .equal, toItem: bgImageView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dgImageView, attribute: .top, relatedBy: .equal, toItem: bgImageView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dgImageView, attribute: .bottom, relatedBy: .equal, toItem: bgImageView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: messageLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: messageLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: messageLabel, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        heightConstraint = NSLayoutConstraint(item: messageLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: message != nil ? 50 : 0)
        heightConstraint?.isActive = true
    }

    override func viewDidLayoutSubviews() {
        messageLabel.roundCorners(corners: [.topLeft, .topRight], radius: 15)
    }

}
