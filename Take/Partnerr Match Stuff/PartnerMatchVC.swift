import Firebase
import FirebaseAuth
import Foundation
import UIKit

class PartnerMatchVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BluePrimaryDark")
        
        initViews()
    }
    
    @objc func backToProf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func initViews() {
        let backButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backToProf))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "Partner Match"
        
        let ageLabel = UILabel()
        ageLabel.text = "Select Age"
        ageLabel.font = UIFont(name: "Avenir-Heavy", size: 22)
        ageLabel.textAlignment = .center
        ageLabel.textColor = UIColor(named: "Placeholde")
        
        view.addSubview(ageLabel)
        
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: ageLabel, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: ageLabel, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1/5, constant: 0).isActive = true
        NSLayoutConstraint(item: ageLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: ageLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).isActive = true
    }
}
