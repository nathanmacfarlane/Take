import Foundation
import UIKit

class MapAreaView: UIViewController {

    var area: Area?
    var delegate: SelectedAreaProtocol?

    var areaLabel: UILabel!
    var routesLabel: UILabel!
    var arrowButton: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        initViews()

        if let area = area {
            let areaViewModel = AreaViewModel(area: area)
            areaLabel.text = areaViewModel.name
            FirestoreService.shared.fs.query(collection: "routes", by: "area", with: area.id, of: Route.self) { routes in
                DispatchQueue.main.async {
                    self.routesLabel.text = "\(routes.count) Route\(routes.count == 1 ? "" : "s")"
                }
            }
        }
    }

    @objc
    func tappedAreaButton() {
        guard let area = self.area else { return }
        self.dismiss(animated: true) {
            self.delegate?.selectedArea(area: area)
        }
    }

    func initViews() {
        areaLabel = LabelAvenir(size: 36, type: .Black, color: #colorLiteral(red: 0.2470588235, green: 0.2470588235, blue: 0.2509803922, alpha: 1))

        routesLabel = LabelAvenir(size: 23, type: .Black, color: #colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1))
        routesLabel.text = "Loading Routes..."

        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedAreaButton))

        arrowButton = UIImageView()
        arrowButton.image = UIImage(named: "icon_next_bubble")
        arrowButton.isUserInteractionEnabled = true
        arrowButton.addGestureRecognizer(tap)

        view.addSubview(areaLabel)
        view.addSubview(routesLabel)
        view.addSubview(arrowButton)

        areaLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: areaLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: areaLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: areaLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: areaLabel, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true

        routesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: routesLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: routesLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: routesLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: routesLabel, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -20).isActive = true

        arrowButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: arrowButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: arrowButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: arrowButton, attribute: .width, relatedBy: .equal, toItem: arrowButton, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: arrowButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -40).isActive = true
    }
}

protocol SelectedAreaProtocol: class {
    func selectedArea(area: Area)
}
