import Alamofire
import GoogleMaps
import Presentr
import UIKit
import VerticalCardSwiper

class PlanTripVC2: UIViewController, VerticalCardSwiperDatasource, VerticalCardSwiperDelegate, PlanEditDelegate {

    // injections
    var suggestedRoutes: [MPRoute] = []
    var allRoutes: [String] = []
    var userClimbs: (Int, Int?) = (0, nil)

    // variables
    var easy: [MPRoute] = []
    var medium: [MPRoute] = []
    var hard: [MPRoute] = []

    let colors: [(UIColor, UIColor)] = [(#colorLiteral(red: 0.6509803922, green: 0.7529411765, blue: 0.8509803922, alpha: 1), #colorLiteral(red: 0.1960784314, green: 0.2823529412, blue: 0.3647058824, alpha: 1)), (#colorLiteral(red: 0.937254902, green: 0.7490196078, blue: 0.7490196078, alpha: 1), #colorLiteral(red: 0.7294117647, green: 0.5607843137, blue: 0.7098039216, alpha: 1)), (#colorLiteral(red: 0.6509803922, green: 0.8509803922, blue: 0.7568627451, alpha: 1), #colorLiteral(red: 0.2039215686, green: 0.3215686275, blue: 0.2666666667, alpha: 1))]

    var easyOn: [Int: Bool] = [:]
    var mediumOn: [Int: Bool] = [:]
    var hardOn: [Int: Bool] = [:]

    var allSuggestions: [DayPlan] = []

    // ui
    private var cardSwiper: VerticalCardSwiper!

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()

        sortAndReload(suggestions: self.generatePermutations())

        for e in easy { easyOn[e.id] = true }
        for m in medium { mediumOn[m.id] = true }
        for h in hard { hardOn[h.id] = true }
    }

    func sortAndReload(suggestions: [DayPlan]) {
        self.allSuggestions = suggestions
        let sugg = suggestions.sorted {
            let sugg1R1Stars = $0.easy.stars ?? 0
            let sugg1R2Stars = $0.medium.stars ?? 0
            let sugg1R3Stars = $0.hard.stars ?? 0

            let sugg2R1Stars = $1.easy.stars ?? 0
            let sugg2R2Stars = $1.medium.stars ?? 0
            let sugg2R3Stars = $1.hard.stars ?? 0

            let sugg1Total = sugg1R1Stars + sugg1R2Stars + sugg1R3Stars
            let sugg2Total = sugg2R1Stars + sugg2R2Stars + sugg2R3Stars

            return sugg1Total > sugg2Total
        }

        DispatchQueue.main.async {
            self.cardSwiper.reloadData()
            self.title = sugg.isEmpty ? "" : "1/\(sugg.count)"
        }
    }

    func generatePermutations() -> [DayPlan] {
        let split = suggestedRoutes.sorted(by: ratingSorterForMPRoutes).splitIntoParts(3)

        if split.count < 3 {
            return []
        }

        easy = split[0].sorted(by: sorterForMPRoutes)
        medium = split[1].sorted(by: sorterForMPRoutes)
        hard = split[2].sorted(by: sorterForMPRoutes)

        return givenEasyMediumHard(easy: easy, medium: medium, hard: hard)
    }

    func givenEasyMediumHard(easy: [MPRoute], medium: [MPRoute], hard: [MPRoute]) -> [DayPlan] {
        var allSuggestions: [DayPlan] = []

        var i = 0
        while i < easy.count && i < medium.count && i < hard.count {
            allSuggestions.append(DayPlan(easy: easy[i], medium: medium[i], hard: hard[i], distance: nil))
            i += 1
        }
        return allSuggestions
    }

    func toggledRoutes(easyOn: [Int: Bool], mediumOn: [Int: Bool], hardOn: [Int: Bool]) {
        self.easyOn = easyOn
        self.mediumOn = mediumOn
        self.hardOn = hardOn
        easy = suggestedRoutes.filter { easyOn[$0.id] == true }.sorted(by: sorterForMPRoutes)
        medium = suggestedRoutes.filter { mediumOn[$0.id] == true }.sorted(by: sorterForMPRoutes)
        hard = suggestedRoutes.filter { hardOn[$0.id] == true }.sorted(by: sorterForMPRoutes)

        let emh = givenEasyMediumHard(easy: easy, medium: medium, hard: hard)
        sortAndReload(suggestions: emh)
    }

    @objc
    func hitEdit() {
        let presentr = Presentr(presentationType: .popup)
        presentr.backgroundOpacity = 0.5
        presentr.backgroundColor = .white
        let planTripEditVC = PlanTripEditVC()

        planTripEditVC.allRoutes = suggestedRoutes

        planTripEditVC.easyOn = easyOn
        planTripEditVC.mediumOn = mediumOn
        planTripEditVC.hardOn = hardOn

        planTripEditVC.delegate = self
        customPresentViewController(presentr, viewController: planTripEditVC, animated: true)
    }

    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {

        if let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "RouteVCC", for: index) as? RouteVCC {
            cardCell.mapView.clear()
            let sugg = allSuggestions[index]
            cardCell.routeName1.text = sugg.easy.name
            cardCell.routeName2.text = sugg.medium.name
            cardCell.routeName3.text = sugg.hard.name

            cardCell.routeRating1.text = sugg.easy.rating
            cardCell.routeRating2.text = sugg.medium.rating
            cardCell.routeRating3.text = sugg.hard.rating

            cardCell.routeStars1.rating = sugg.easy.stars ?? 0
            cardCell.routeStars2.rating = sugg.medium.stars ?? 0
            cardCell.routeStars3.rating = sugg.hard.stars ?? 0

            let l1 = CLLocation(latitude: sugg.easy.latitude, longitude: sugg.easy.longitude)
            let l2 = CLLocation(latitude: sugg.medium.latitude, longitude: sugg.medium.longitude)
            let l3 = CLLocation(latitude: sugg.hard.latitude, longitude: sugg.hard.longitude)
            cardCell.mapView.centerMap(l1: l1, l2: l2, l3: l3)
            cardCell.markers.append(cardCell.mapView.addMarker(route: sugg.easy))
            cardCell.markers.append(cardCell.mapView.addMarker(route: sugg.medium))
            cardCell.markers.append(cardCell.mapView.addMarker(route: sugg.hard))
            cardCell.setGradientBackground(colorTop: colors[index % colors.count].0, colorBottom: colors[index % colors.count].1)
            cardCell.index = index
            cardCell.distanceLabel.text = ""
            cardCell.mapView.drawPath(easy: sugg.easy, medium: sugg.medium, hard: sugg.hard) { plan in
                guard let distanceMiles = plan.distanceMiles else { return }
                self.allSuggestions[index].distance = distanceMiles
                cardCell.distanceLabel.text = "\(distanceMiles.rounded(toPlaces: 2)) mi"
            }
            return cardCell
        }
        return CardCell()
    }

    func didTapCard(verticalCardSwiperView: VerticalCardSwiperView, index: Int) {
        let planTripDetailVC = PlanTripDetailVC()
        planTripDetailVC.plan = allSuggestions[index]
        navigationController?.pushViewController(planTripDetailVC, animated: true)
    }

    func didScroll(verticalCardSwiperView: VerticalCardSwiperView) {
        guard let index = cardSwiper.indexesForVisibleCards.first else { return }
        title = "\(index + 1)/\(allSuggestions.count)"
    }

    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return allSuggestions.count
    }

    func sizeForItem(verticalCardSwiperView: VerticalCardSwiperView, index: Int) -> CGSize {
        return CGSize(width: verticalCardSwiperView.frame.width, height: verticalCardSwiperView.frame.height * 0.9)
    }

    func initViews() {
        view.backgroundColor = UISettings.shared.colorScheme.backgroundPrimary

        let editButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(hitEdit))
        navigationItem.rightBarButtonItem = editButton

        cardSwiper = VerticalCardSwiper(frame: .zero)
        cardSwiper.datasource = self
        cardSwiper.delegate = self
        cardSwiper.isSideSwipingEnabled = false
        cardSwiper.register(RouteVCC.self, forCellWithReuseIdentifier: "RouteVCC")

        view.addSubview(cardSwiper)

        cardSwiper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: cardSwiper, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: cardSwiper, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: cardSwiper, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: cardSwiper, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }

    func filterForMPRoutes(route: MPRoute, buffer: Int) -> Bool {
        return route.takeRating.0 == userClimbs.0 + buffer
    }

    func sorterForMPRoutes(this: MPRoute, that: MPRoute) -> Bool {
        guard let stars0 = this.stars else { return false }
        guard let stars1 = that.stars else { return true }
        return stars0 > stars1
    }

    func ratingSorterForMPRoutes(this: MPRoute, that: MPRoute) -> Bool {
        guard let r0 = this.takeRating.0 else { return false }
        guard let r1 = that.takeRating.0 else { return true }
        if r0 == r1 {
            guard let r00 = this.takeRating.1 else { return false }
            guard let r11 = that.takeRating.1 else { return true }
            return r00 < r11
        }
        return r0 < r1
    }
}
