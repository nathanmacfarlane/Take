import Firebase
import FirebaseAuth
import Foundation
import Presentr
import UIKit
class DirectMessVC: UIViewController {
    
    var dummyButton: TypeButton!
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    
    
    func initViews() {
        dummyButton = TypeButton()
        dummyButton.setTitle("TR", for: .normal)
        dummyButton.addBorder(width: 1)
        dummyButton.backgroundColor = UIColor(hex: "#0E4343")
        
        view.addSubview(dummyButton)
        
        dummyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: dummyButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dummyButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: dummyButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: dummyButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true
        
    }
}
