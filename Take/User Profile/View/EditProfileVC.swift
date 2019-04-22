import Foundation
import UIKit
import FirebaseAuth

class EditProfileVC: UIViewController {
    var user: User?
    
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
        
        view.addSubview(logoutButton)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: logoutButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: logoutButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: logoutButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1/4, constant: 0).isActive = true
        NSLayoutConstraint(item: logoutButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
    
    }
    
}
