import UIKit

class RouteNowVC: UIViewController {

    var bgImageView: UIImageView!
    var routeViewModel: RouteViewModel!

    var currentWeather: CurrentWeather!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initViews()

        routeViewModel.getCurrentWeather { weatherViewModel in
            print("temp: \(weatherViewModel.temperatureString)")
        }

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

        currentWeather = CurrentWeather()
        currentWeather.backgroundColor = UIColor(named: "PinkAccent")
        currentWeather.layer.cornerRadius = 15
        currentWeather.clipsToBounds = true

        // add to subview
        view.addSubview(bgImageView)
        view.addSubview(gradientView)
        view.addSubview(currentWeather)

        currentWeather.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: currentWeather, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: currentWeather, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: currentWeather, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: currentWeather, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 130).isActive = true
    }

}
