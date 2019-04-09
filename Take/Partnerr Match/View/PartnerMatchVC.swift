import Firebase
import FirebaseAuth
import Foundation
import GMStepper
import MultiSlider
import UIKit


class PartnerMatchVC: UIViewController {
    
    let ageSlider = MultiSlider()
    var trStepper: GMStepper!
    var rightSliderLabel = UITextField()
    var leftSliderLabel = UITextField()
    var matchCriteria: MatchCriteria?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UISettings.shared.colorScheme.backgroundPrimary
        matchCriteria = MatchCriteria(ageL: 0, ageH: 0, sportGrade: 0,
                                          trGrade: 0, tradGrade: 0, boulderGrade: 0,
                                          sportLetter: "", trLetter: "", tradLetter: "")
        initViews()
    }
    
    @objc func backToProf() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc
    func openMatchResults() {
        matchCriteria?.ageLow = (ageSlider.value[0] - 1)
        matchCriteria?.ageHigh = (ageSlider.value[1] + 1)
        let mr = MatchResultsVC()
        guard let user = self.user else { return }
        mr.user = user
        mr.matchCrit = self.matchCriteria
        let nav = UINavigationController(rootViewController: mr)
        nav.navigationBar.barTintColor = UIColor(named: "BluePrimaryDark")
        nav.navigationBar.tintColor = UIColor(named: "PinkAccent")
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor(named: "Placeholder") ?? .white,
            .font: UIFont(name: "Avenir-Black", size: 26) ?? .systemFont(ofSize: 26)
        ]
        present(nav, animated: true, completion: nil)
    }
    
    func initViews() {
        let backButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backToProf))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "Partner Match"
        
        guard let user = self.user else { return }
        
        var lower: CGFloat
        if user.age < 21 {
            lower = 18
        } else {
            lower = CGFloat(user.age - 3)
        }
        ageSlider.minimumValue = 18
        ageSlider.maximumValue = 40
        ageSlider.trackWidth = 5
        ageSlider.tintColor = UIColor(named: "PinkAccent")
        ageSlider.value = [lower, CGFloat(user.age + 3)]
        ageSlider.orientation = .horizontal
        ageSlider.outerTrackColor = UIColor(named: "Placeholder")
        ageSlider.valueLabelPosition = .top
        ageSlider.valueLabels[0].textColor = UISettings.shared.colorScheme.complimentary
        ageSlider.valueLabels[1].textColor = UISettings.shared.colorScheme.complimentary
        ageSlider.valueLabels[0].font = UIFont(name: "Avenir", size: 16)
        ageSlider.valueLabels[1].font = UIFont(name: "Avenir", size: 16)
        ageSlider.thumbCount = 2
        ageSlider.snapStepSize = 1
        
        let ageLabel = UILabel()
        ageLabel.text = "Age"
        ageLabel.font = UIFont(name: "Avenir-Heavy", size: 22)
        ageLabel.textAlignment = .center
        ageLabel.textColor = UISettings.shared.colorScheme.textSecondary
        
        let sendButton = UIButton()
        sendButton.setTitle("Send It!", for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.backgroundColor = UIColor(named: "PinkAccent")
        sendButton.layer.cornerRadius = 8
        sendButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 20)
        sendButton.addTarget(self, action: #selector(openMatchResults), for: UIControl.Event.touchUpInside)
        
        let trLabel = UILabel()
        trLabel.text = "Top Rope Difficulty"
        trLabel.textColor = UISettings.shared.colorScheme.textSecondary
        trLabel.font = UIFont(name: "Avenir-Black", size: 16)
        
        trStepper = GMStepper()
        trStepper.minimumValue = 0
        trStepper.maximumValue = 15
        trStepper.stepValue = 1.0
        if let trGrade = self.user?.trGrade {
            trStepper.value = Double(trGrade)
        }
        trStepper.items = Array(0...15).map { "5.\($0)" }
        trStepper.buttonsBackgroundColor = UIColor(hex: "#888888")
        trStepper.labelBackgroundColor = UIColor(hex: "#4B4D50")
        
        view.addSubview(ageLabel)
        view.addSubview(ageSlider)
        view.addSubview(sendButton)
        view.addSubview(trStepper)
        view.addSubview(trLabel)
        
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: ageLabel, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: ageLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: ageLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: ageLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        
        ageSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: ageSlider, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: ageSlider, attribute: .top, relatedBy: .equal, toItem: ageLabel, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: ageSlider, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 3/4, constant: 0).isActive = true
        NSLayoutConstraint(item: ageSlider, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        trStepper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: trStepper, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: trStepper, attribute: .top, relatedBy: .equal, toItem: ageSlider, attribute: .bottom, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: trStepper, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 3/4, constant: 0).isActive = true
        NSLayoutConstraint(item: trStepper, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        trLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: trLabel, attribute: .leading , relatedBy: .equal, toItem: trStepper, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: trLabel, attribute: .bottom, relatedBy: .equal, toItem: trStepper, attribute: .top, multiplier: 1, constant: -2).isActive = true
        NSLayoutConstraint(item: trLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1/2, constant: 0).isActive = true
        NSLayoutConstraint(item: trLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: sendButton, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sendButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -15).isActive = true
        NSLayoutConstraint(item: sendButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: sendButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50).isActive = true
    }
}
