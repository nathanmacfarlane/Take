import Foundation
import NVActivityIndicatorView
import UIKit

class MarkerCallout: UIView {

    var routeKey: String?
    var titleLabel: UILabel!
    var ratingLabel: UILabel!
    var typesLabel: UILabel!
    var indicator: NVActivityIndicatorView!

    var route: Route?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    convenience init(size: CGSize, routeKey: String?) {
        self.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.routeKey = routeKey
        initViews()
    }

    func stopLoading() {
        indicator.stopAnimating()
        titleLabel.isHidden = false
        ratingLabel.isHidden = false
        typesLabel.isHidden = false
    }

    func startLoading() {
        titleLabel.isHidden = true
        ratingLabel.isHidden = true
        typesLabel.isHidden = true
        indicator.startAnimating()
    }

    func initViews() {
        backgroundColor = .white

        layer.cornerRadius = 10
        clipsToBounds = true

        titleLabel = LabelAvenir(size: 20, type: .Medium)

        ratingLabel = LabelAvenir(size: 16, type: .Medium)

        typesLabel = LabelAvenir(size: 16, type: .Medium)

        indicator = NVActivityIndicatorView(frame: frame, type: .ballBeat, color: UISettings.shared.colorScheme.accent, padding: 0)
        startLoading()

        addSubview(titleLabel)
        addSubview(ratingLabel)
        addSubview(typesLabel)
        addSubview(indicator)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1 / 3, constant: 0).isActive = true

        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: ratingLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: ratingLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: ratingLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: ratingLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1 / 3, constant: 0).isActive = true

        typesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: typesLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: typesLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: typesLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: typesLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1 / 3, constant: 0).isActive = true

        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: indicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: indicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: indicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: indicator, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
    }

    func loadRoute(completion: @escaping (_ route: Route) -> Void) {
//        if let key = routeKey {
//            FirestoreService.shared.fs.query(collection: "routes", by: "id", with: key, of: Route.self) { routes in
//                guard let route = routes.first else { return }
//                self.route = route
//                completion(route)
//            }
//        }
        if let key = routeKey {
            if Int(key) != nil {
                MPService.shared.getRoutes(ids: [key]) { routes in
                    if let route = routes.first {
                        let route = Route(mpRoute: route)
                        self.route = route
                        completion(route)
                        return
                    }
                }
            } else {
                FirestoreService.shared.fs.query(collection: "routes", by: "id", with: key, of: Route.self) { routes in
                    guard let route = routes.first else { return }
                    self.route = route
                    completion(route)
                }
            }
        }
    }
}
