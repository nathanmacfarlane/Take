import FirebaseFirestore
import Geofirestore
import TwicketSegmentedControl
import UIKit

class AreaDetailVC: UIViewController, TwicketSegmentedControlDelegate {

    var areaViewModel: AreaViewModel!

    var mapVC: MapVC!
    var mapBG: UIView!
    var cityStateLabel: UILabel!
    var infoSeg: TwicketSegmentedControl!
    var infoTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UISettings.shared.colorScheme.backgroundPrimary

        initViews()

        areaViewModel.cityAndState { city, state in
            DispatchQueue.main.async {
                self.cityStateLabel.text = "\(city), \(state)"
            }
        }
    }

    func didSelect(_ segmentIndex: Int) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.infoTextView.alpha = 0.0
        }, completion: { _ in
            self.infoTextView.text = segmentIndex == 0 ? self.areaViewModel.area.description : self.areaViewModel.area.directions
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.view.layoutIfNeeded()
            }, completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.infoTextView.alpha = 1.0
                }
            })
        })
    }

    func initViews() {
        cityStateLabel = UILabel()
        cityStateLabel.backgroundColor = .clear
        cityStateLabel.textAlignment = .center
        cityStateLabel.font = UIFont(name: "Avenir-Medium", size: 20)
        cityStateLabel.textColor = UISettings.shared.colorScheme.textPrimary

        mapBG = UIView()
        mapBG.backgroundColor = UISettings.shared.mode == .dark ? UISettings.shared.colorScheme.backgroundDarker : UIColor(hex: "#C9C9C9")
        mapVC = MapVC()

        infoSeg = TwicketSegmentedControl()
        infoSeg.setSegmentItems(["Description", "Directions"])
        infoSeg.isSliderShadowHidden = true
        infoSeg.sliderBackgroundColor = UISettings.shared.colorScheme.backgroundDarker
        infoSeg.backgroundColor = .clear
        infoSeg.delegate = self

        infoTextView = UITextView()
        infoTextView.isEditable = false
        infoTextView.backgroundColor = .clear
        infoTextView.text = areaViewModel.area.description
        infoTextView.textColor = UISettings.shared.colorScheme.textPrimary
        infoTextView.font = UIFont(name: "Avenir-Oblique", size: 15)

        view.addSubview(mapBG)
        view.addSubview(cityStateLabel)
        addChild(mapVC)
        view.addSubview(mapVC.view)
        view.addSubview(infoSeg)
        view.addSubview(infoTextView)
        mapVC.didMove(toParent: self)

        mapBG.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mapBG, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: mapBG, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: mapBG, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: mapBG, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250).isActive = true

        cityStateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: cityStateLabel, attribute: .leading, relatedBy: .equal, toItem: mapBG, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: cityStateLabel, attribute: .trailing, relatedBy: .equal, toItem: mapBG, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: cityStateLabel, attribute: .top, relatedBy: .equal, toItem: mapBG, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: cityStateLabel, attribute: .bottom, relatedBy: .equal, toItem: mapVC.view, attribute: .top, multiplier: 1, constant: 0).isActive = true

        mapVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mapVC.view, attribute: .leading, relatedBy: .equal, toItem: mapBG, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapVC.view, attribute: .trailing, relatedBy: .equal, toItem: mapBG, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapVC.view, attribute: .top, relatedBy: .equal, toItem: mapBG, attribute: .top, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: mapVC.view, attribute: .bottom, relatedBy: .equal, toItem: mapBG, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

        infoSeg.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: infoSeg, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: infoSeg, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -40).isActive = true
        NSLayoutConstraint(item: infoSeg, attribute: .top, relatedBy: .equal, toItem: mapBG, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: infoSeg, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true

        infoTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: infoTextView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: infoTextView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -25).isActive = true
        NSLayoutConstraint(item: infoTextView, attribute: .top, relatedBy: .equal, toItem: infoSeg, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: infoTextView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -20).isActive = true
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mapVC.view.layer.cornerRadius = 10
        mapVC.view.clipsToBounds = true
        mapBG.layer.cornerRadius = 10
        mapBG.clipsToBounds = true
    }
}
