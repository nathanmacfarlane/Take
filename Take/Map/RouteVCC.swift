import Alamofire
import Cosmos
import Foundation
import VerticalCardSwiper

struct Dir: Codable {
    let geocoded_waypoints: [WayPoints]
    let routes: [DirRoute]
}

struct DirRoute: Codable {
    let overview_polyline: Overview
    let legs: [Leg]
}

struct Leg: Codable {
    let distance: Distance
}

struct Distance: Codable {
    let value: Int
}

struct Overview: Codable {
    let points: String
}

struct WayPoints: Codable {
    let place_id: String
    let geocoder_status: String
    let types: [String]
}

class RouteVCC: CardCell {

    var mapView: GMSMapView!

    var routeName1: UILabel!
    var routeRating1: UILabel!
    var routeStars1: CosmosView!

    var routeName2: UILabel!
    var routeRating2: UILabel!
    var routeStars2: CosmosView!

    var routeName3: UILabel!
    var routeRating3: UILabel!
    var routeStars3: CosmosView!

    var distanceLabel: UILabel!

    var index: Int?

    var markers: [GMSMarker] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    func getCosmos() -> CosmosView {
        let cosmos = CosmosView()
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
        return cosmos
    }

    func initViews() {

        layer.cornerRadius = 15
        clipsToBounds = true

        routeName1 = UILabel()
        routeName1.font = UIFont(name: "Avenir-Black", size: 25)

        routeRating1 = UILabel()
        routeRating1.font = UIFont(name: "Avenir-Next", size: 17)

        routeStars1 = getCosmos()

        routeName2 = UILabel()
        routeName2.font = UIFont(name: "Avenir-Black", size: 25)

        routeRating2 = UILabel()
        routeRating2.font = UIFont(name: "Avenir-Next", size: 17)

        routeStars2 = getCosmos()

        routeName3 = UILabel()
        routeName3.font = UIFont(name: "Avenir-Black", size: 25)

        routeRating3 = UILabel()
        routeRating3.font = UIFont(name: "Avenir-Next", size: 17)

        routeStars3 = getCosmos()

        distanceLabel = UILabel()
        distanceLabel.font = UIFont(name: "Avenir-Black", size: 25)
        distanceLabel.textAlignment = .right

        mapView = GMSMapView()
        mapView.isMyLocationEnabled = true
        mapView.isUserInteractionEnabled = false
        mapView.layer.cornerRadius = 15
        mapView.clipsToBounds = true

        addSubview(routeName1)
        addSubview(routeRating1)
        addSubview(routeStars1)
        addSubview(routeName2)
        addSubview(routeRating2)
        addSubview(routeStars2)
        addSubview(routeName3)
        addSubview(routeRating3)
        addSubview(routeStars3)
        addSubview(distanceLabel)
        addSubview(mapView)

        routeName1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: routeName1, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: routeName1, attribute: .trailing, relatedBy: .equal, toItem: distanceLabel, attribute: .leading, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: routeName1, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: routeName1, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 28).isActive = true

        routeRating1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: routeRating1, attribute: .leading, relatedBy: .equal, toItem: routeStars1, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: routeRating1, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: routeRating1, attribute: .top, relatedBy: .equal, toItem: routeName1, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: routeRating1, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        routeStars1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: routeStars1, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 90).isActive = true
        NSLayoutConstraint(item: routeStars1, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: routeStars1, attribute: .centerY, relatedBy: .equal, toItem: routeRating1, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: routeStars1, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        routeName2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: routeName2, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: routeName2, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: routeName2, attribute: .top, relatedBy: .equal, toItem: routeRating1, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: routeName2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 28).isActive = true

        routeRating2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: routeRating2, attribute: .leading, relatedBy: .equal, toItem: routeStars2, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: routeRating2, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: routeRating2, attribute: .top, relatedBy: .equal, toItem: routeName2, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: routeRating2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        routeStars2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: routeStars2, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 90).isActive = true
        NSLayoutConstraint(item: routeStars2, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: routeStars2, attribute: .centerY, relatedBy: .equal, toItem: routeRating2, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: routeStars2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        routeName3.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: routeName3, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: routeName3, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: routeName3, attribute: .top, relatedBy: .equal, toItem: routeRating2, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: routeName3, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 28).isActive = true

        routeRating3.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: routeRating3, attribute: .leading, relatedBy: .equal, toItem: routeStars3, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: routeRating3, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: routeRating3, attribute: .top, relatedBy: .equal, toItem: routeName3, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: routeRating3, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        routeStars3.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: routeStars3, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 90).isActive = true
        NSLayoutConstraint(item: routeStars3, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: routeStars3, attribute: .centerY, relatedBy: .equal, toItem: routeRating3, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: routeStars3, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: distanceLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        NSLayoutConstraint(item: distanceLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: distanceLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: distanceLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: routeRating3, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
    }
}
