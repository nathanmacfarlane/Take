import Firebase
import FirebaseAuth
import Foundation
import MultiSlider
import UIKit


class PartnerMatchVC: UIViewController {
    
    let ageSlider = MultiSlider()
    var rightSliderLabel = UITextField()
    var leftSliderLabel = UITextField()
    var matchCriteria: MatchCriteria?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BluePrimaryDark")
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
        
        ageSlider.minimumValue = 18
        ageSlider.maximumValue = 40
        ageSlider.trackWidth = 5
        ageSlider.tintColor = UIColor(named: "PinkAccent")
        ageSlider.value = [18, 40]
        ageSlider.orientation = .horizontal
        ageSlider.outerTrackColor = UIColor(named: "Placeholder")
        ageSlider.valueLabelPosition = .top
        ageSlider.valueLabels[0].textColor = .white
        ageSlider.valueLabels[1].textColor = .white
        ageSlider.valueLabels[0].font = UIFont(name: "Avenir", size: 16)
        ageSlider.valueLabels[1].font = UIFont(name: "Avenir", size: 16)
        ageSlider.thumbCount = 2
        ageSlider.snapStepSize = 1
        
        let ageLabel = UILabel()
        ageLabel.text = "Age"
        ageLabel.font = UIFont(name: "Avenir-Heavy", size: 22)
        ageLabel.textAlignment = .center
        ageLabel.textColor = .white
        
        let sendButton = UIButton()
        sendButton.setTitle("Send It!", for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.backgroundColor = UIColor(named: "PinkAccent")
        sendButton.layer.cornerRadius = 8
        sendButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 20)
        sendButton.addTarget(self, action: #selector(openMatchResults), for: UIControl.Event.touchUpInside)
        
        view.addSubview(ageLabel)
        view.addSubview(ageSlider)
        view.addSubview(sendButton)
        
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: ageLabel, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: ageLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: ageLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: ageLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        
        ageSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: ageSlider, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: ageSlider, attribute: .top, relatedBy: .equal, toItem: ageLabel, attribute: .bottom, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: ageSlider, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 3/4, constant: 0).isActive = true
        NSLayoutConstraint(item: ageSlider, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: sendButton, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sendButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -15).isActive = true
        NSLayoutConstraint(item: sendButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: sendButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50).isActive = true
    }
}
