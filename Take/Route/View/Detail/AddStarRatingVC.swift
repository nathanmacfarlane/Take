import Cosmos
import UIKit

class AddStarRatingVC: UIViewController {

    // injections
    var routeViewModel: RouteViewModel?
    var userId: String?
    // variables
    var yConst: NSLayoutConstraint!
    var starValue: Double?
    var delegate: AddStarsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(UIColor(named: "PinkAccentDark"), for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 18)
        saveButton.alpha = 0.0
        saveButton.addTarget(self, action: #selector(hitSave), for: .touchUpInside)

        let cosmos = CosmosView()
        if let userId = userId, let star = routeViewModel?.getStar(forUser: userId) {
            cosmos.rating = star
        } else {
            cosmos.rating = 0.0
        }
        cosmos.settings.minTouchRating = 0.0
        cosmos.settings.starSize = 50
        cosmos.settings.totalStars = 4
        cosmos.settings.emptyBorderColor = .clear
        cosmos.settings.emptyBorderWidth = 0
        cosmos.settings.filledBorderWidth = 0
        cosmos.settings.filledBorderColor = .clear
        cosmos.settings.updateOnTouch = true
        cosmos.settings.starMargin = 0
        cosmos.settings.filledImage = UIImage(named: "icon_star_edit")
        cosmos.settings.emptyImage = UIImage(named: "icon_star_edit_bg")
        cosmos.settings.fillMode = .half
        cosmos.didFinishTouchingCosmos = { rating in
            self.yConst.constant = -40
            self.starValue = rating
            UIView.animate(withDuration: 0.3) {
                saveButton.alpha = 1.0
                self.view.layoutIfNeeded()
            }
        }

        view.addSubview(cosmos)
        view.addSubview(saveButton)

        cosmos.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: cosmos, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        yConst = NSLayoutConstraint(item: cosmos, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        yConst.isActive = true
        NSLayoutConstraint(item: cosmos, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 214).isActive = true
        NSLayoutConstraint(item: cosmos, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 52).isActive = true

        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: saveButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 2, constant: 0).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -20).isActive = true

    }

    @objc
    func hitSave() {
        self.delegate?.hitSave(stars: starValue ?? 0.0)
        dismiss(animated: true, completion: nil)
    }

}

protocol AddStarsDelegate: class {
    func hitSave(stars: Double)
}
