import UIKit

class PlanTripPreviewVC: UIViewController {

    // injections
    var routes: [String] = []
    var location: CLLocation!
    // variables
    var tickList: MPTickList?
    var suggestedRoutes: [MPRoute] = []
    // outlets
    var cityLabel: UILabel!
    var stateLabel: UILabel!
    var totalCountLabel: UILabel!
    var forYouCountLabel: UILabel!
    // delegate
    var delegate: PlanRouteDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()

        totalCountLabel.text = "\(routes.count)"

        MPService.shared.getTicks(email: "nathanmmacfarlane@gmail.com", startPos: 0) { ticks in
            self.tickList = ticks
            let avg = MPService.shared.stringToRating(rating: ticks.average)
            guard let avgGrade = avg.0 else { return }

            MPService.shared.getRoutes(ids: self.routes) { mpRoutes in
                self.suggestedRoutes = mpRoutes.filter {
                    let rating = MPService.shared.stringToRating(rating: ($0.rating ?? ""))
                    guard let grade = rating.0 else { return false }
                    return abs(avgGrade - grade) <= 1
                }
                DispatchQueue.main.async {
                    self.forYouCountLabel.text = "\(self.suggestedRoutes.count)"
                }
            }

        }

        location.cityAndState { city, state, _ in
            if let city = city {
                self.cityLabel.text = city
            }
            if let state = state {
                self.stateLabel.text = state
            }
        }
    }

    @objc
    func hitCheckItOut() {
        self.dismiss(animated: true) {
            self.delegate?.hitPreviewCheckItOut(allRoutes: self.routes, suggestedRoutes: self.suggestedRoutes)
        }
    }

    func initViews() {
        view.backgroundColor = .white

        cityLabel = UILabel()
        cityLabel.font = UIFont(name: "Avenir-Black", size: 25)
        cityLabel.textColor = .black
        cityLabel.textAlignment = .center

        stateLabel = UILabel()
        stateLabel.font = UIFont(name: "Avenir-Black", size: 18)
        stateLabel.textColor = .gray
        stateLabel.textAlignment = .center

        totalCountLabel = UILabel()
        totalCountLabel.font = UIFont(name: "Avenir-Black", size: 35)
        totalCountLabel.textColor = .white
        totalCountLabel.textAlignment = .center
        totalCountLabel.backgroundColor = Dark().backgroundLighter

        let totalLabel = UILabel()
        totalLabel.text = "Routes"
        totalLabel.font = UIFont(name: "Avenir-Black", size: 20)
        totalLabel.textAlignment = .center
        totalLabel.textColor = Dark().backgroundLighter

        forYouCountLabel = UILabel()
        forYouCountLabel.font = UIFont(name: "Avenir-Black", size: 35)
        forYouCountLabel.textColor = .white
        forYouCountLabel.textAlignment = .center
        forYouCountLabel.backgroundColor = Dark().backgroundDarker

        let forYouLabel = UILabel()
        forYouLabel.text = "For You"
        forYouLabel.font = UIFont(name: "Avenir-Black", size: 20)
        forYouLabel.textAlignment = .center
        forYouLabel.textColor = Dark().backgroundDarker

        let checkItOutButton = UIButton()
        checkItOutButton.addTarget(self, action: #selector(hitCheckItOut), for: .touchUpInside)
        checkItOutButton.setTitle("Check it Out", for: .normal)
        checkItOutButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 30)
        checkItOutButton.setTitleColor(.black, for: .normal)

        view.addSubview(cityLabel)
        view.addSubview(stateLabel)
        view.addSubview(totalCountLabel)
        view.addSubview(totalLabel)
        view.addSubview(forYouCountLabel)
        view.addSubview(forYouLabel)
        view.addSubview(checkItOutButton)

        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: cityLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: cityLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: cityLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 25  ).isActive = true
        NSLayoutConstraint(item: cityLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35).isActive = true

        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: stateLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: stateLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: stateLabel, attribute: .top, relatedBy: .equal, toItem: cityLabel, attribute: .bottom, multiplier: 1, constant: 5  ).isActive = true
        NSLayoutConstraint(item: stateLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35).isActive = true

        totalCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: totalCountLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1 / 3, constant: -10).isActive = true
        NSLayoutConstraint(item: totalCountLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: totalCountLabel, attribute: .top, relatedBy: .equal, toItem: stateLabel, attribute: .bottom, multiplier: 1, constant: 25  ).isActive = true
        NSLayoutConstraint(item: totalCountLabel, attribute: .width, relatedBy: .equal, toItem: totalCountLabel, attribute: .height, multiplier: 1, constant: 0).isActive = true

        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: totalLabel, attribute: .leading, relatedBy: .equal, toItem: totalCountLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalLabel, attribute: .trailing, relatedBy: .equal, toItem: totalCountLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalLabel, attribute: .top, relatedBy: .equal, toItem: totalCountLabel, attribute: .bottom, multiplier: 1, constant: 10  ).isActive = true
        NSLayoutConstraint(item: totalLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true

        forYouCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: forYouCountLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 2 / 3, constant: 10).isActive = true
        NSLayoutConstraint(item: forYouCountLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: forYouCountLabel, attribute: .top, relatedBy: .equal, toItem: stateLabel, attribute: .bottom, multiplier: 1, constant: 25  ).isActive = true
        NSLayoutConstraint(item: forYouCountLabel, attribute: .width, relatedBy: .equal, toItem: forYouCountLabel, attribute: .height, multiplier: 1, constant: 0).isActive = true

        forYouLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: forYouLabel, attribute: .leading, relatedBy: .equal, toItem: forYouCountLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: forYouLabel, attribute: .trailing, relatedBy: .equal, toItem: forYouCountLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: forYouLabel, attribute: .top, relatedBy: .equal, toItem: forYouCountLabel, attribute: .bottom, multiplier: 1, constant: 10  ).isActive = true
        NSLayoutConstraint(item: forYouLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true

        checkItOutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: checkItOutButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: checkItOutButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: checkItOutButton, attribute: .top, relatedBy: .equal, toItem: forYouLabel, attribute: .bottom, multiplier: 1, constant: 20  ).isActive = true
        NSLayoutConstraint(item: checkItOutButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
    }

    override func viewDidLayoutSubviews() {
        forYouCountLabel.layer.cornerRadius = forYouCountLabel.frame.width / 2
        forYouCountLabel.clipsToBounds = true
        totalCountLabel.layer.cornerRadius = totalCountLabel.frame.width / 2
        totalCountLabel.clipsToBounds = true
    }

}
