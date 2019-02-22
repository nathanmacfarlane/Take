import Firebase
import FirebaseAuth
import Foundation
import UIKit

class PartnerMatchVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    @objc func backToProf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func initViews() {
        let backButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backToProf))
        
        self.navigationItem.leftBarButtonItem = backButton
    }
}
