import Firebase
import FirebaseAuth
import Foundation
import GMStepper
import MultiSlider
import UIKit


class PartnerMatchVC: UIViewController {
    
    let ageSlider = MultiSlider()
    var trStepper: GMStepper!
    var tradStepper: GMStepper!
    var sportStepper: GMStepper!
    var bStepper: GMStepper!
    var trStepperL: GMStepper!
    var tradStepperL: GMStepper!
    var sportStepperL: GMStepper!
    var bStepperL: GMStepper!
    var rightSliderLabel = UITextField()
    var leftSliderLabel = UITextField()
    var user: User?
    var trGradeU = 15
    var trGradeL = 0
    var tradGradeU = 15
    var tradGradeL = 0
    var sportGradeL = 0
    var sportGradeU = 15
    var bGradeU = 15
    var bGradeL = 0
    
    var seg: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Top Rope", "Sport", "Trad", "Boulder"])
        sc.tintColor = UISettings.shared.colorScheme.segmentColor
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleSegmentChanges), for: .valueChanged)
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UISettings.shared.colorScheme.backgroundPrimary
        initViews()
    }
    
    @objc
    func backToProf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func handleSegmentChanges() {
        if seg.selectedSegmentIndex == 0 { // tr
            trStepper.isHidden = false
            bStepper.isHidden = true
            sportStepper.isHidden = true
            tradStepper.isHidden = true
            
            trStepperL.isHidden = false
            bStepperL.isHidden = true
            sportStepperL.isHidden = true
            tradStepperL.isHidden = true
        }
        else if seg.selectedSegmentIndex == 1 { // sport
            trStepper.isHidden = true
            bStepper.isHidden = true
            sportStepper.isHidden = false
            tradStepper.isHidden = true
            
            trStepperL.isHidden = true
            bStepperL.isHidden = true
            sportStepperL.isHidden = false
            tradStepperL.isHidden = true
        }
        else if seg.selectedSegmentIndex == 2 { // trad
            trStepper.isHidden = true
            bStepper.isHidden = true
            sportStepper.isHidden = true
            tradStepper.isHidden = false
            
            trStepperL.isHidden = true
            bStepperL.isHidden = true
            sportStepperL.isHidden = true
            tradStepperL.isHidden = false
        }
        else if seg.selectedSegmentIndex == 3 { // boulder
            trStepper.isHidden = true
            bStepper.isHidden = false
            sportStepper.isHidden = true
            tradStepper.isHidden = true
            
            trStepperL.isHidden = true
            bStepperL.isHidden = false
            sportStepperL.isHidden = true
            tradStepperL.isHidden = true
        }
        
    }

    @objc
    func openMatchResults() {
        let mr = MatchResultsVC()
        self.trGradeU = Int(self.trStepperL.value)
        self.tradGradeU = Int(self.tradStepperL.value)
        self.sportGradeU = Int(self.sportStepperL.value)
        self.bGradeU = Int(self.bStepperL.value)
        
        self.trGradeL = Int(self.trStepper.value)
        self.tradGradeL = Int(self.tradStepper.value)
        self.sportGradeL = Int(self.sportStepper.value)
        self.bGradeL = Int(self.bStepper.value)
        
        guard let user = self.user else { return }
        mr.user = user
        mr.matchCrit = MatchCriteria(ageL: (ageSlider.value[0] - 1), ageH: (ageSlider.value[1] + 1),
                                     sportGradeL: self.sportGradeL, sportGradeH: self.sportGradeU,
                                     trGradeL: self.trGradeL, trGradeH: self.trGradeU,
                                     tradGradeL: self.tradGradeL, tradGradeH: self.tradGradeU,
                                     boulderGradeH: self.bGradeU, boulderGradeL: self.bGradeL,
                                     sportLetter: "", trLetter: "", tradLetter: "")
        let nav = UINavigationController(rootViewController: mr)
        nav.navigationBar.barTintColor = UISettings.shared.colorScheme.backgroundPrimary
        nav.navigationBar.tintColor = UISettings.shared.colorScheme.accent
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.titleTextAttributes = [
            .foregroundColor: UISettings.shared.colorScheme.textPrimary,
            .font: UIFont(name: "Avenir-Black", size: 26) ?? .systemFont(ofSize: 26)
        ]
        present(nav, animated: true, completion: nil)
    }
    
    func initViews() {
        let backButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backToProf))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "Partner Match"
        seg.tintColor = UISettings.shared.colorScheme.segmentColor
        
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
        ageSlider.tintColor = UISettings.shared.colorScheme.accent
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
        ageLabel.text = "Select Age"
        ageLabel.font = UIFont(name: "Avenir-Heavy", size: 22)
        ageLabel.textAlignment = .center
        ageLabel.textColor = UISettings.shared.colorScheme.textSecondary
        
        let gradeLabel = UILabel()
        gradeLabel.text = "Select Grades"
        gradeLabel.font = UIFont(name: "Avenir-Heavy", size: 22)
        gradeLabel.textAlignment = .center
        gradeLabel.textColor = UISettings.shared.colorScheme.textSecondary
        
        let toLabel = UILabel()
        toLabel.text = "to"
        toLabel.font = UIFont(name: "Avenir-Heavy", size: 22)
        toLabel.textAlignment = .center
        toLabel.textColor = UISettings.shared.colorScheme.textSecondary
        
        let sendButton = UIButton()
        sendButton.setTitle("Send It!", for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.backgroundColor = UISettings.shared.colorScheme.accent
        sendButton.layer.cornerRadius = 8
        sendButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 20)
        sendButton.addTarget(self, action: #selector(openMatchResults), for: UIControl.Event.touchUpInside)
        
        trStepper = GMStepper()
        trStepper.minimumValue = 0
        trStepper.maximumValue = 15
        trStepper.stepValue = 1.0
        if (user.trGrade == 0) {
            trStepper.value = 0
        } else {
            trStepper.value = Double(user.trGrade - 1)
        }
        trStepper.items = Array(0...15).map { "5.\($0)" }
        trStepper.buttonsBackgroundColor = UISettings.shared.colorScheme.segmentColor
        trStepper.labelBackgroundColor = UIColor(hex: "#4B4D50")
        
        sportStepper = GMStepper()
        sportStepper.minimumValue = 0
        sportStepper.maximumValue = 15
        sportStepper.stepValue = 1.0
        if (user.sportGrade == 0) {
            sportStepper.value = 0
        } else {
            sportStepper.value = Double(user.sportGrade - 1)
        }
        sportStepper.items = Array(0...15).map { "5.\($0)" }
        sportStepper.buttonsBackgroundColor = UISettings.shared.colorScheme.segmentColor
        sportStepper.labelBackgroundColor = UIColor(hex: "#4B4D50")
        sportStepper.isHidden = true
        
        tradStepper = GMStepper()
        tradStepper.minimumValue = 0
        tradStepper.maximumValue = 15
        tradStepper.stepValue = 1.0
        if (user.tradGrade == 0) {
            tradStepper.value = 0
        } else {
            tradStepper.value = Double(user.tradGrade - 1)
        }
        tradStepper.items = Array(0...15).map { "5.\($0)" }
        tradStepper.buttonsBackgroundColor = UISettings.shared.colorScheme.segmentColor
        tradStepper.labelBackgroundColor = UIColor(hex: "#4B4D50")
        tradStepper.isHidden = true
        
        bStepper = GMStepper()
        bStepper.minimumValue = 0
        bStepper.maximumValue = 15
        bStepper.stepValue = 1.0
        if (user.boulderGrade == 0) {
            bStepper.value = 0
        } else {
            bStepper.value = Double(user.boulderGrade - 1)
        }
        bStepper.items = Array(0...15).map { "V\($0)" }
        bStepper.buttonsBackgroundColor = UISettings.shared.colorScheme.segmentColor
        bStepper.labelBackgroundColor = UIColor(hex: "#4B4D50")
        bStepper.isHidden = true
        
        trStepperL = GMStepper()
        trStepperL.minimumValue = 0
        trStepperL.maximumValue = 15
        trStepperL.stepValue = 1.0
        if (user.trGrade == 15) {
            trStepper.value = 15
        } else {
            trStepperL.value = Double(user.trGrade + 1)
        }
        trStepperL.items = Array(0...15).map { "5.\($0)" }
        trStepperL.buttonsBackgroundColor = UISettings.shared.colorScheme.segmentColor
        trStepperL.labelBackgroundColor = UIColor(hex: "#4B4D50")
        
        sportStepperL = GMStepper()
        sportStepperL.minimumValue = 0
        sportStepperL.maximumValue = 15
        sportStepperL.stepValue = 1.0
        if (user.sportGrade == 15) {
            sportStepper.value = 15
        } else {
            sportStepperL.value = Double(user.sportGrade + 1)
        }
        sportStepperL.items = Array(0...15).map { "5.\($0)" }
        sportStepperL.buttonsBackgroundColor = UISettings.shared.colorScheme.segmentColor
        sportStepperL.labelBackgroundColor = UIColor(hex: "#4B4D50")
        sportStepperL.isHidden = true
        
        tradStepperL = GMStepper()
        tradStepperL.minimumValue = 0
        tradStepperL.maximumValue = 15
        tradStepperL.stepValue = 1.0
        if (user.tradGrade == 15) {
            tradStepperL.value = 15
        } else {
            tradStepperL.value = Double(user.tradGrade + 1)
        }
        tradStepperL.items = Array(0...15).map { "5.\($0)" }
        tradStepperL.buttonsBackgroundColor = UISettings.shared.colorScheme.segmentColor
        tradStepperL.labelBackgroundColor = UIColor(hex: "#4B4D50")
        tradStepperL.isHidden = true
        
        bStepperL = GMStepper()
        bStepperL.minimumValue = 0
        bStepperL.maximumValue = 15
        bStepperL.stepValue = 1.0
        bStepperL.value = 15
        if (user.boulderGrade == 15) {
            bStepperL.value = 15
        } else {
            bStepperL.value = Double(user.boulderGrade + 1)
        }
        bStepperL.items = Array(0...15).map { "V\($0)" }
        bStepperL.buttonsBackgroundColor = UISettings.shared.colorScheme.segmentColor
        bStepperL.labelBackgroundColor = UIColor(hex: "#4B4D50")
        bStepperL.isHidden = true
        
        view.addSubview(ageLabel)
        view.addSubview(gradeLabel)
        view.addSubview(ageSlider)
        view.addSubview(sendButton)
        view.addSubview(trStepper)
        view.addSubview(sportStepper)
        view.addSubview(tradStepper)
        view.addSubview(bStepper)
        view.addSubview(seg)
        view.addSubview(toLabel)
        view.addSubview(trStepperL)
        view.addSubview(sportStepperL)
        view.addSubview(tradStepperL)
        view.addSubview(bStepperL)
        
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
        
        gradeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: gradeLabel, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: gradeLabel, attribute: .top, relatedBy: .equal, toItem: ageSlider, attribute: .bottom, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: gradeLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: gradeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        
        trStepper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: trStepper, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: trStepper, attribute: .top, relatedBy: .equal, toItem: seg, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: trStepper, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 3/4, constant: 0).isActive = true
        NSLayoutConstraint(item: trStepper, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        sportStepper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: sportStepper, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sportStepper, attribute: .top, relatedBy: .equal, toItem: seg, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: sportStepper, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 3/4, constant: 0).isActive = true
        NSLayoutConstraint(item: sportStepper, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        tradStepper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tradStepper, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradStepper, attribute: .top, relatedBy: .equal, toItem: seg, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: tradStepper, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 3/4, constant: 0).isActive = true
        NSLayoutConstraint(item: tradStepper, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        bStepper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: bStepper, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bStepper, attribute: .top, relatedBy: .equal, toItem: seg, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: bStepper, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 3/4, constant: 0).isActive = true
        NSLayoutConstraint(item: bStepper, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: toLabel, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: toLabel, attribute: .top, relatedBy: .equal, toItem: bStepper, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: toLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 3/4, constant: 0).isActive = true
        NSLayoutConstraint(item: toLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        trStepperL.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: trStepperL, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: trStepperL, attribute: .top, relatedBy: .equal, toItem: toLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: trStepperL, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 3/4, constant: 0).isActive = true
        NSLayoutConstraint(item: trStepperL, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        sportStepperL.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: sportStepperL, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sportStepperL, attribute: .top, relatedBy: .equal, toItem: toLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: sportStepperL, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 3/4, constant: 0).isActive = true
        NSLayoutConstraint(item: sportStepperL, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        tradStepperL.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tradStepperL, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradStepperL, attribute: .top, relatedBy: .equal, toItem: toLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: tradStepperL, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 3/4, constant: 0).isActive = true
        NSLayoutConstraint(item: tradStepperL, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        bStepperL.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: bStepperL, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bStepperL, attribute: .top, relatedBy: .equal, toItem: toLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: bStepperL, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 3/4, constant: 0).isActive = true
        NSLayoutConstraint(item: bStepperL, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
      
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: sendButton, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sendButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -15).isActive = true
        NSLayoutConstraint(item: sendButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: sendButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50).isActive = true
        
        seg.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: seg, attribute: .leading , relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: seg, attribute: .top, relatedBy: .equal, toItem: gradeLabel, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: seg, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: seg, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50).isActive = true
    }
}
