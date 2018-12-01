import Lightbox
import UIKit

class RouteNowVC: UIViewController, LightboxControllerPageDelegate, LightboxControllerDismissalDelegate {

    var bgImageView: UIImageView!
    var route: Route!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initViews()

        let button = UIButton(frame: view.frame)
        button.setTitle("start", for: .normal)
        button.addTarget(self, action: #selector(startStuff), for: .touchUpInside)
        view.addSubview(button)

    }

    @objc
    func startStuff() {
        let images = [
            LightboxImage(imageURL: URL(string: "https://cdn.arstechnica.net/2011/10/05/iphone4s_sample_apple-4e8c706-intro.jpg")!),
            LightboxImage(
                image: UIImage(named: "profile.jpg") ?? UIImage(),
                text: "This is an example of a remote image loaded from URL"
            ),
            LightboxImage(
                image: UIImage(named: "SLO.jpg") ?? UIImage(),
                text: "",
                videoURL: URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
            ),
            LightboxImage(
                image: UIImage(named: "bg.jpg") ?? UIImage(),
                text: "This is an example of a local image."
            )
        ]
        let controller = LightboxController(images: images)
        controller.pageDelegate = self
        controller.dismissalDelegate = self
        controller.dynamicBackground = true
        present(controller, animated: true, completion: nil)
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

        // add to subview
        view.addSubview(bgImageView)
        view.addSubview(gradientView)
    }

    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        print(page)
    }

    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        // ...
    }

}
