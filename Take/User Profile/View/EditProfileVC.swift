import Foundation
import UIKit
import FirebaseAuth

class EditProfileVC: UIViewController {
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    @objc
    private func goLogout(sender: UIButton!) {
        try? Auth.auth().signOut()
        self.present(LoginVC(), animated: true, completion: nil)
    }
    
    func initViews() {
        
        let logoutButton = UIButton()
        logoutButton.addTarget(self, action: #selector(goLogout), for:  UIControl.Event.allTouchEvents)
        logoutButton.setTitle("Edit Profile", for: .normal)
        logoutButton.setTitleColor( .black, for: .normal)
        logoutButton.backgroundColor = UISettings.shared.colorScheme.accent
        logoutButton.layer.cornerRadius = 8
        
        view.addSubview(logoutButton)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: logoutButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: logoutButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: logoutButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 4, constant: 0).isActive = true
        NSLayoutConstraint(item: logoutButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20).isActive = true
    
    }
    
}
