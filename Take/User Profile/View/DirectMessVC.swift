import Firebase
import FirebaseAuth
import Foundation
import Presentr
import UIKit
class DirectMessVC: UIViewController {
    var dummyButton: TypeButton!
    var dmTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    func initViews() {
        dummyButton = TypeButton()
        dummyButton.setTitle("TR", for: .normal)
        dummyButton.addBorder(width: 1)
        dummyButton.backgroundColor = UIColor(hex: "#0E4343")
        
        // table view
        self.dmTableView = UITableView()
//        dmTableView.register(RouteTVC.self, forCellReuseIdentifier: "RouteCellTV")
        dmTableView.backgroundColor = .white
        dmTableView.separatorStyle = .none
//        dmTableView.dataSource = self
//        dmTableView.delegate = self
        
        view.addSubview(dmTableView)
        
        dmTableView.translatesAutoresizingMaskIntoConstraints = false
        let tvTopConstraint = NSLayoutConstraint(item: dmTableView, attribute: .top, relatedBy: .equal, toItem: navigationItem.title, attribute: .bottom, multiplier: 1, constant: 0)
        let tvBottomConstraint = NSLayoutConstraint(item: dmTableView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -20)
        let tvLeadingConstraint = NSLayoutConstraint(item: dmTableView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 10)
        let tvTrailingConstraint = NSLayoutConstraint(item: dmTableView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -10)
        NSLayoutConstraint.activate([tvTopConstraint, tvBottomConstraint, tvLeadingConstraint, tvTrailingConstraint])
    }
}
