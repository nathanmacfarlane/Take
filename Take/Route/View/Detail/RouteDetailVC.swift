import Mapbox
import TwicketSegmentedControl
import UIKit

class RouteDetailVC: UIViewController {

    var routeViewModel: RouteViewModel!
    var bgImageView: UIImageView!
    var infoLabel: UILabel!
    var ratingValue: UILabel!
    var starsValue: UILabel!
    var pitchesValue: UILabel!
    var sportButton: TypeButton!
    var boulderButton: TypeButton!
    var trButton: TypeButton!
    var tradButton: TypeButton!
    var aidButton: TypeButton!
    var mapView: MGLMapView!
    let cvHeight: CGFloat = 75

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }

    func goEditRoute() {
        let editRouteVC = AddEditRouteVC()
        editRouteVC.route = routeViewModel.route
        self.present(editRouteVC, animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        ratingValue.text = routeViewModel.rating
        starsValue.text = routeViewModel.averageStarString
        pitchesValue.text = routeViewModel.pitchesString
        sportButton.setType(isType: routeViewModel.isSport)
        boulderButton.setType(isType: routeViewModel.isBoulder)
        trButton.setType(isType: routeViewModel.isTR)
        tradButton.setType(isType: routeViewModel.isTrad)
        aidButton.setType(isType: routeViewModel.isAid)
        infoLabel.text = routeViewModel.info
        mapView.setCenter(routeViewModel.location.coordinate, zoomLevel: 15, animated: false)
        mapView.annotations?.forEach { mapView.removeAnnotation($0) }
        let routeMarker = MGLPointAnnotation()
        routeMarker.coordinate = routeViewModel.location.coordinate
        routeMarker.title = routeViewModel.name
        routeMarker.subtitle = "\(routeViewModel.rating) \(routeViewModel.typesString)"
        mapView.addAnnotation(routeMarker)

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

        // rating header
        let ratingLabel = UILabel()
        ratingLabel.text = "RATING"
        ratingLabel.textColor = .lightGray
        ratingLabel.textAlignment = .center
        ratingLabel.font = UIFont(name: "Avenir", size: 14)

        // rating value
        ratingValue = UILabel()
        ratingValue.text = routeViewModel.rating
        ratingValue.textColor = .white
        ratingValue.textAlignment = .center
        ratingValue.font = UIFont(name: "Avenir", size: 24)

        // stars header
        let starsLabel = UILabel()
        starsLabel.text = "STARS"
        starsLabel.textColor = .lightGray
        starsLabel.textAlignment = .center
        starsLabel.font = UIFont(name: "Avenir", size: 14)

        // stars value
        starsValue = UILabel()
        starsValue.text = routeViewModel.averageStarString
        starsValue.textColor = .white
        starsValue.textAlignment = .center
        starsValue.font = UIFont(name: "Avenir", size: 24)

        // pitches header
        let pitchesLabel = UILabel()
        pitchesLabel.text = "PITCHES"
        pitchesLabel.textColor = .lightGray
        pitchesLabel.textAlignment = .center
        pitchesLabel.font = UIFont(name: "Avenir", size: 14)

        // pitches value
        pitchesValue = UILabel()
        pitchesValue.text = routeViewModel.pitchesString
        pitchesValue.textColor = .white
        pitchesValue.textAlignment = .center
        pitchesValue.font = UIFont(name: "Avenir", size: 24)

        // type buttons
        sportButton = TypeButton()
        sportButton.setTitle("S", for: .normal)
        sportButton.setType(isType: routeViewModel.isSport)
        sportButton.addBorder(width: 1)
        boulderButton = TypeButton()
        boulderButton.setTitle("B", for: .normal)
        boulderButton.setType(isType: routeViewModel.isBoulder)
        boulderButton.addBorder(width: 1)
        trButton = TypeButton()
        trButton.setTitle("TR", for: .normal)
        trButton.setType(isType: routeViewModel.isTR)
        trButton.addBorder(width: 1)
        tradButton = TypeButton()
        tradButton.setTitle("T", for: .normal)
        tradButton.setType(isType: routeViewModel.isTrad)
        tradButton.addBorder(width: 1)
        aidButton = TypeButton()
        aidButton.setTitle("A", for: .normal)
        aidButton.setType(isType: routeViewModel.isAid)
        aidButton.addBorder(width: 1)

        // segment control
        let segControl = TwicketSegmentedControl()
        segControl.setSegmentItems(["Description", "Protection"])
        segControl.isSliderShadowHidden = true
        segControl.sliderBackgroundColor = UIColor(named: "BlueDark") ?? .lightGray
        segControl.backgroundColor = .clear
        segControl.delegate = self

        // info label
        infoLabel = UILabel()
        infoLabel.text = routeViewModel.info
        infoLabel.numberOfLines = 0
        infoLabel.textColor = .white
        infoLabel.font = UIFont(name: "Avenir-Oblique", size: 15)

        // mapbox map
        let url = URL(string: "mapbox://styles/mapbox/dark-v9")
        mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.delegate = self
        mapView.setCenter(routeViewModel.location.coordinate, zoomLevel: 15, animated: false)
        mapView.layer.cornerRadius = 5
        mapView.clipsToBounds = true
        mapView.logoView.isHidden = true
        mapView.attributionButton.isHidden = true
        mapView.showsUserLocation = true
        let routeMarker = MGLPointAnnotation()
        routeMarker.coordinate = routeViewModel.location.coordinate
        routeMarker.title = routeViewModel.name
        routeMarker.subtitle = "\(routeViewModel.rating) \(routeViewModel.typesString)"
        mapView.addAnnotation(routeMarker)

        // add to subview
        view.addSubview(bgImageView)
        view.addSubview(gradientView)
        view.addSubview(ratingLabel)
        view.addSubview(ratingValue)
        view.addSubview(starsLabel)
        view.addSubview(starsValue)
        view.addSubview(pitchesLabel)
        view.addSubview(pitchesValue)
        view.addSubview(sportButton)
        view.addSubview(boulderButton)
        view.addSubview(trButton)
        view.addSubview(tradButton)
        view.addSubview(aidButton)
        view.addSubview(segControl)
        view.addSubview(infoLabel)
        view.addSubview(mapView)

        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: ratingLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: ratingLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: ratingLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: ratingLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true

        ratingValue.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: ratingValue, attribute: .leading, relatedBy: .equal, toItem: ratingLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: ratingValue, attribute: .trailing, relatedBy: .equal, toItem: ratingLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: ratingValue, attribute: .top, relatedBy: .equal, toItem: ratingLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: ratingValue, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        starsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: starsLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: starsLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: starsLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: starsLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true

        starsValue.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: starsValue, attribute: .leading, relatedBy: .equal, toItem: starsLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: starsValue, attribute: .trailing, relatedBy: .equal, toItem: starsLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: starsValue, attribute: .top, relatedBy: .equal, toItem: starsLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: starsValue, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        pitchesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: pitchesLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: pitchesLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: pitchesLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: pitchesLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true

        pitchesValue.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: pitchesValue, attribute: .leading, relatedBy: .equal, toItem: pitchesLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: pitchesValue, attribute: .trailing, relatedBy: .equal, toItem: pitchesLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: pitchesValue, attribute: .top, relatedBy: .equal, toItem: pitchesLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: pitchesValue, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        let buttonPadding: CGFloat = 8.0

        sportButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: sportButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sportButton, attribute: .leading, relatedBy: .equal, toItem: trButton, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sportButton, attribute: .trailing, relatedBy: .equal, toItem: tradButton, attribute: .leading, multiplier: 1, constant: -buttonPadding).isActive = true
        NSLayoutConstraint(item: sportButton, attribute: .top, relatedBy: .equal, toItem: ratingValue, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: sportButton, attribute: .width, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sportButton, attribute: .height, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true

        boulderButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: boulderButton, attribute: .trailing, relatedBy: .equal, toItem: trButton, attribute: .leading, multiplier: 1, constant: -buttonPadding).isActive = true
        NSLayoutConstraint(item: boulderButton, attribute: .top, relatedBy: .equal, toItem: ratingValue, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: boulderButton, attribute: .width, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: boulderButton, attribute: .height, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true

        trButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: trButton, attribute: .trailing, relatedBy: .equal, toItem: sportButton, attribute: .leading, multiplier: 1, constant: -buttonPadding).isActive = true
        NSLayoutConstraint(item: trButton, attribute: .leading, relatedBy: .equal, toItem: boulderButton, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: trButton, attribute: .top, relatedBy: .equal, toItem: ratingValue, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: trButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 10, constant: 0).isActive = true
        NSLayoutConstraint(item: trButton, attribute: .height, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 10, constant: 0).isActive = true

        tradButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tradButton, attribute: .trailing, relatedBy: .equal, toItem: aidButton, attribute: .leading, multiplier: 1, constant: -buttonPadding).isActive = true
        NSLayoutConstraint(item: tradButton, attribute: .leading, relatedBy: .equal, toItem: sportButton, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradButton, attribute: .top, relatedBy: .equal, toItem: ratingValue, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: tradButton, attribute: .width, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradButton, attribute: .height, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true

        aidButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: aidButton, attribute: .leading, relatedBy: .equal, toItem: tradButton, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: aidButton, attribute: .top, relatedBy: .equal, toItem: ratingValue, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: aidButton, attribute: .width, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: aidButton, attribute: .height, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true

        segControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: segControl, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: segControl, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -40).isActive = true
        NSLayoutConstraint(item: segControl, attribute: .top, relatedBy: .equal, toItem: sportButton, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: segControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true

        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: infoLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: infoLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -25).isActive = true
        NSLayoutConstraint(item: infoLabel, attribute: .top, relatedBy: .equal, toItem: segControl, attribute: .bottom, multiplier: 1, constant: 10).isActive = true

        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: infoLabel, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -20).isActive = true
    }

}
