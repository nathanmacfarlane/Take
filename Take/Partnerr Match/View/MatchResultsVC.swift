import CodableFirebase
import Firebase
import FirebaseAuth
import FirebaseFirestore
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
        
        let query = ref.whereField("age", isGreaterThan: self.matchCrit?.ageLow).whereField("age", isLessThan: self.matchCrit?.ageHigh)
        query.getDocuments { snapshot, err in
            guard err == nil, let snap = snapshot else { print("nooooo"); return }
//            print(snap)
            guard let data = snapshot?.documents else {
                print("Document data was empty.")
                return
            }
            print(data)
            for d in data {
                let decoder = FirebaseDecoder()
                guard let result = try? decoder.decode(User.self, from: d.data() as Any) else { return }
                self.climbers.append(result)
                self.dmTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.climbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: DmTVC = self.dmTableView.dequeueReusableCell(withIdentifier: "DmCellTV") as? DmTVC else { print("error"); return DmTVC() }
        print("here")
        print(self.climbers)
        cell.nameLabel.text = climbers[indexPath.row].username
        cell.messageLabel.text = climbers[indexPath.row].bio
        let userViewModel = UserViewModel(user: self.climbers[indexPath.row])
        userViewModel.getProfilePhoto { image in
            DispatchQueue.main.async {
                cell.profPic.setBackgroundImage(image, for: .normal)
            }
        
        }
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
