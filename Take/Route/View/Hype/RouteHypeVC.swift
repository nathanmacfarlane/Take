import UIKit

class RouteHypeVC: UIViewController {

    var bgImageView: UIImageView!
    var routeViewModel: RouteViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initViews()

    }

    func initViews() {
        self.view.backgroundColor = UIColor(named: "BluePrimary")

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

}