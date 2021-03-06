import Cosmos
import FirebaseAuth
import FirebaseFirestore
import Presentr
//import TwicketSegmentedControl
import UIKit

class RouteDetailVC: UIViewController, RouteAreaViewDelegate, AddStarsDelegate {

    var routeViewModel: RouteViewModel!
    var infoTextView: UITextView!
    var ratingValue: UILabel!
    var cosmos: CosmosView!
    var pitchesValue: UILabel!
    var areaView: RouteAreaView?
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
        cosmos.rating = routeViewModel.averageStar ?? 0.0
        pitchesValue.text = routeViewModel.pitchesString
        infoTextView.text = routeViewModel.info

    }

    func hitMapButton() {
        let presenter: Presentr = {
            let customPresenter = Presentr(presentationType: .popup)
            customPresenter.transitionType = .coverVertical
            customPresenter.roundCorners = true
            customPresenter.cornerRadius = 15
            customPresenter.backgroundColor = UISettings.shared.mode == .dark ? .white : .black
            customPresenter.backgroundOpacity = 0.5
            return customPresenter
        }()
        let mapVC = MapVC()
        mapVC.initialRoutes = [routeViewModel.route]
        mapVC.animateMap = true
        self.customPresentViewController(presenter, viewController: mapVC, animated: true)
    }

    func hitSave(stars: Double) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        routeViewModel.addStar(stars, forUserId: userId)
        cosmos.rating = routeViewModel.averageStar ?? 0.0
        FirestoreService.shared.fs.save(object: routeViewModel.route, to: "routes", with: routeViewModel.id, completion: nil)
    }

    @objc
    func hitStars() {
        let presenter: Presentr = {
            let customPresenter = Presentr(presentationType: .popup)
            customPresenter.transitionType = .coverVertical
            customPresenter.roundCorners = true
            customPresenter.cornerRadius = 15
            customPresenter.backgroundColor = UISettings.shared.mode == .dark ? .white : .black
            customPresenter.backgroundOpacity = 0.5
            return customPresenter
        }()
        let addStarVC = AddStarRatingVC()
        addStarVC.delegate = self
        addStarVC.routeViewModel = routeViewModel
        addStarVC.userId = Auth.auth().currentUser?.uid
        self.customPresentViewController(presenter, viewController: addStarVC, animated: true)
    }

    @objc
    func infoSegChanged(_ seg: UISegmentedControl) {
        infoTextView.text = seg.selectedSegmentIndex == 0 ? routeViewModel.info : routeViewModel.protection
    }

    func initViews() {
        self.view.backgroundColor = UISettings.shared.colorScheme.backgroundPrimary

        // rating header
        let ratingLabel = LabelAvenir(size: 14, color: UISettings.shared.colorScheme.textSecondary, alignment: .center)
        ratingLabel.text = "RATING"

        // rating value
        ratingValue = LabelAvenir(size: 24, alignment: .center)
        ratingValue.text = routeViewModel.rating

        // stars header
        let starsLabel = LabelAvenir(size: 14, color: UISettings.shared.colorScheme.textSecondary, alignment: .center)
        starsLabel.text = "STARS"

        cosmos = CosmosView()
        cosmos.rating = routeViewModel.averageStar ?? 0.0
        cosmos.settings.starSize = 25
        cosmos.settings.totalStars = 4
        cosmos.settings.emptyBorderColor = .clear
        cosmos.settings.emptyBorderWidth = 0
        cosmos.settings.filledBorderWidth = 0
        cosmos.settings.filledBorderColor = .clear
        cosmos.settings.updateOnTouch = false
        cosmos.settings.starMargin = -4
        cosmos.settings.filledImage = UISettings.shared.mode == .dark ? UIImage(named: "icon_star_selected") : UIImage(named: "icon_star")
        cosmos.settings.emptyImage = UISettings.shared.mode == .dark ? UIImage(named: "icon_star") : UIImage(named: "icon_star_selected")
        cosmos.settings.fillMode = .precise

        let starTap = UITapGestureRecognizer(target: self, action: #selector(hitStars))
        cosmos.addGestureRecognizer(starTap)

        // pitches header
        let pitchesLabel = LabelAvenir(size: 14, color: UISettings.shared.colorScheme.textSecondary, alignment: .center)
        pitchesLabel.text = "PITCHES"

        // pitches value
        pitchesValue = LabelAvenir(size: 24, color: UISettings.shared.colorScheme.textPrimary, alignment: .center)
        pitchesValue.text = routeViewModel.pitchesString

        var typesLabels: [RouteTypeLabel] = []
        for type in routeViewModel.types {
            let temp = RouteTypeLabel()
            temp.text = type.rawValue
            view.addSubview(temp)
            typesLabels.append(temp)
        }

        // area view
        if routeViewModel.route.area != nil {
            areaView = RouteAreaView()
            areaView?.delegate = self
            if let areaView = areaView {
                routeViewModel.getArea { area in
                    let areaViewModel = AreaViewModel(area: area)
                    areaView.titleButton.setTitle(areaViewModel.name, for: .normal)
                    if let url = areaViewModel.area.imageUrl {
                        ImageCache.shared.getImage(for: url) { image in
                            DispatchQueue.main.async {
                                areaView.imageView.image = image
                            }
                        }
                    }
                }
                routeViewModel.cityAndState { city, state in
                    areaView.cityStateLabel.text = "\(city), \(state)"
                }
                view.addSubview(areaView)
                areaView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint(item: areaView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
                NSLayoutConstraint(item: areaView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
                NSLayoutConstraint(item: areaView, attribute: .top, relatedBy: .equal, toItem: typesLabels.first ?? ratingValue, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
                NSLayoutConstraint(item: areaView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120).isActive = true
            }
        }

        // segment control
        let segControl = UISegmentedControl(items: ["Description", "Protection"])
        segControl.tintColor = UISettings.shared.colorScheme.accent
        segControl.selectedSegmentIndex = 0
        segControl.addTarget(self, action: #selector(infoSegChanged), for: .valueChanged)

        // info label
        infoTextView = UITextView()
        infoTextView.text = routeViewModel.info
        infoTextView.isEditable = false
        infoTextView.backgroundColor = .clear
        infoTextView.textColor = UISettings.shared.colorScheme.textPrimary
        infoTextView.font = UIFont(name: "Avenir-Oblique", size: 15)

        // add to subview
        view.addSubview(ratingLabel)
        view.addSubview(ratingValue)
        view.addSubview(starsLabel)
        view.addSubview(cosmos)
        view.addSubview(pitchesLabel)
        view.addSubview(pitchesValue)
        view.addSubview(segControl)
        view.addSubview(infoTextView)

        starsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: starsLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: starsLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: starsLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: starsLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true

        cosmos.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: cosmos, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 90).isActive = true
        NSLayoutConstraint(item: cosmos, attribute: .centerX, relatedBy: .equal, toItem: starsLabel, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: cosmos, attribute: .top, relatedBy: .equal, toItem: starsLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: cosmos, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: ratingLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: ratingLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: ratingLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: ratingLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true

        ratingValue.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: ratingValue, attribute: .leading, relatedBy: .equal, toItem: ratingLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: ratingValue, attribute: .trailing, relatedBy: .equal, toItem: ratingLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: ratingValue, attribute: .top, relatedBy: .equal, toItem: ratingLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: ratingValue, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        pitchesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: pitchesLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: pitchesLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: pitchesLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: pitchesLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true

        pitchesValue.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: pitchesValue, attribute: .leading, relatedBy: .equal, toItem: pitchesLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: pitchesValue, attribute: .trailing, relatedBy: .equal, toItem: pitchesLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: pitchesValue, attribute: .top, relatedBy: .equal, toItem: pitchesLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: pitchesValue, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        for (i, temp) in typesLabels.enumerated() {
            temp.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: temp, attribute: .leading, relatedBy: .equal, toItem: i == 0 ? infoTextView : typesLabels[i - 1], attribute: i == 0 ? .leading : .trailing, multiplier: 1, constant: 10).isActive = true
            NSLayoutConstraint(item: temp, attribute: .top, relatedBy: .equal, toItem: ratingValue, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
            NSLayoutConstraint(item: temp, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        }

        segControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: segControl, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: segControl, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -40).isActive = true
        NSLayoutConstraint(item: segControl, attribute: .top, relatedBy: .equal, toItem: areaView ?? typesLabels.first ?? ratingValue, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: segControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true

        infoTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: infoTextView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: infoTextView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -25).isActive = true
        NSLayoutConstraint(item: infoTextView, attribute: .top, relatedBy: .equal, toItem: segControl, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: infoTextView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -20).isActive = true
    }

}
