import Foundation
import FirebaseAuth
import GMStepper
import UIKit

class EditProfileVC: UIViewController {
    var user: User?
    var gradeStepper: GMStepper!
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "BluePrimaryDark")
        super.viewDidLoad()
        initViews()
    }
    
    @objc
    private func goLogout(sender: UIButton!) {
        try? Auth.auth().signOut()
        self.present(LoginVC(), animated: true, completion: nil)
    }
    
    @objc func backToProf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    var seg: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Top Rope", "Sport", "Trad", "Boulder"])
        sc.tintColor = UISettings.shared.colorScheme.textSecondary
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleSegmentChanges), for: .valueChanged)
        return sc
    }()
    
    @objc
    func handleSegmentChanges() {
        
        
    }
    
    func initViews() {
        
        let backButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backToProf))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "Edit Profile"
        
        let logoutButton = UIButton()
        logoutButton.addTarget(self, action: #selector(goLogout), for: UIControl.Event.allTouchEvents)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor( .black, for: .normal)
        logoutButton.backgroundColor = UISettings.shared.colorScheme.accent
        logoutButton.layer.cornerRadius = 8
        
        gradeStepper = GMStepper()
        gradeStepper.minimumValue = 0
        gradeStepper.maximumValue = 15
        gradeStepper.stepValue = 1.0
        gradeStepper.buttonsBackgroundColor = UIColor(hex: "#888888")
        gradeStepper.labelBackgroundColor = UIColor(hex: "#4B4D50")
        
        let gradeLabel = UILabel()
        gradeLabel.text = "Select Grades"
        gradeLabel.font = UIFont(name: "Avenir-Heavy", size: 22)
        gradeLabel.textAlignment = .center
        gradeLabel.textColor = UISettings.shared.colorScheme.textSecondary
        
        view.addSubview(logoutButton)
        view.addSubview(gradeStepper)
        view.addSubview(seg)
        view.addSubview(gradeLabel)
        
        
        
        gradeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: gradeLabel, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: gradeLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: gradeLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: gradeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        
        seg.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: seg, attribute: .leading , relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: seg, attribute: .top, relatedBy: .equal, toItem: gradeLabel, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: seg, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: seg, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50).isActive = true
        
        gradeStepper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: gradeStepper, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: gradeStepper, attribute: .top, relatedBy: .equal, toItem: seg, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: gradeStepper, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 3/4, constant: 0).isActive = true
        NSLayoutConstraint(item: gradeStepper, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: logoutButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: logoutButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -15).isActive = true
        NSLayoutConstraint(item: logoutButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1/4, constant: 0).isActive = true
        NSLayoutConstraint(item: logoutButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
    
    }
    
}
