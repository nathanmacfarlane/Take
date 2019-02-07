import Firebase
import FirebaseAuth
import Foundation
import Presentr
import UIKit
class DirectMessVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var user: User?
    var dms: [DM] = []
    
    var dmTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDms()
        initViews()
    }
    
    func getDms()   {
        let db = Firestore.firestore()
        print(self.user?.messageIds.first)
        db.query(collection: "messages", by: "messageId", with: self.user?.messageIds.first ?? "you suck", of: DM.self) {
            dm in
            self.dms = dm
            self.dmTableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: DmTVC = self.dmTableView.dequeueReusableCell(withIdentifier: "DmCellTV") as? DmTVC else { print("yooooooo"); return DmTVC() }
        cell.textLabel?.text = dms[indexPath.row].Thread.first?.message
        cell.textLabel?.textColor = .white
//        cell.nameLabel.text = "rocki"
        return cell
    }
    
    @objc
     func backToProf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func initViews() {
        
        self.navigationItem.title = "DMs"
        // table view
        self.dmTableView = UITableView()
        dmTableView.register(DmTVC.self, forCellReuseIdentifier: "DmCellTV")
        dmTableView.dataSource = self
        dmTableView.delegate = self
        dmTableView.backgroundColor = UIColor(named: "BluePrimaryDark")
        
        let backButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backToProf))
        
        self.navigationItem.leftBarButtonItem = backButton
        
        view.addSubview(dmTableView)
        
        dmTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: dmTableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dmTableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dmTableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dmTableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
}
