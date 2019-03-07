import Firebase
import FirebaseAuth
import Foundation
import Presentr
import UIKit

class MatchResultsVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var matchCrit: MatchCriteria?
    var dmTableView: UITableView!
    var climbers: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Results"
        view.backgroundColor = UIColor(named: "BluePrimaryDark")
        getMatches()
        initViews()
    }
    
    func getMatches() {
        let db = Firestore.firestore()
        let ref = db.collection("users")
        let query = ref.whereField("age", isGreaterThanOrEqualTo: 23)
        
        db.query(collection: "users", by: "age", with: 23, of: User.self) {
            users in
            self.climbers = users
            print(self.climbers)
            
        }
        print(self.climbers)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: DmTVC = self.dmTableView.dequeueReusableCell(withIdentifier: "DmCellTV") as? DmTVC else { print("yooooooo"); return DmTVC() }
        let db = Firestore.firestore()
        db.query(collection: "users", by: "age", with: 23, of: User.self) { users in
            guard let user = users.first else {return}
            cell.nameLabel.text = user.username // placeholder for username
            let userViewModel = UserViewModel(user: user)
            userViewModel.getProfilePhoto { image in
                DispatchQueue.main.async {
                    cell.profPic.setBackgroundImage(image, for: .normal)
                }
            }
        }
        cell.messageLabel.text = "I am a climber"
        
        return cell
    }
   
    @objc func backToProf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func initViews() {
        let backButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backToProf))
        self.navigationItem.leftBarButtonItem = backButton
        
        self.dmTableView = UITableView()
        dmTableView.register(DmTVC.self, forCellReuseIdentifier: "DmCellTV")
        dmTableView.dataSource = self
        dmTableView.delegate = self
        dmTableView.separatorStyle = .none
        dmTableView.backgroundColor = UIColor(named: "BluePrimaryDark")
        
        view.addSubview(dmTableView)
        
        dmTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: dmTableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dmTableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dmTableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dmTableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
}
