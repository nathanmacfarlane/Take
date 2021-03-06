import CodableFirebase
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Foundation
import Presentr
import UIKit

class MatchResultsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var matchCrit: MatchCriteria?
    var dmTableView: UITableView!
    var climbers: [User] = []
    var user: User?
    var match: User?
    var dm: DM?
    var flag = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Results"
        view.backgroundColor = UISettings.shared.colorScheme.backgroundCell
        getMatches()
        initViews()
    }
    
    func getDistance(match: User) -> Double{
        guard let user = self.user else { return 0}
        let x1 = user.location[0]
        let x2 = match.location[0]
        
        let y1 = user.location[1]
        let y2 = match.location[1]
        
        let dist = sqrt(pow((x1 - x2), 2) + pow((y1 - y2), 2))
        return dist
    }
    
    func getMatches() {
        let db = Firestore.firestore()
        let ref = db.collection("users")
        guard let mc = self.matchCrit else { return }
        guard let user = self.user else { return }
        let query = ref.whereField("age", isGreaterThan: self.matchCrit?.ageLow).whereField("age", isLessThan: self.matchCrit?.ageHigh)
        query.getDocuments { snapshot, err in
            guard err == nil, let snap = snapshot else { print("nooooo"); return }
//            print(snap)
            guard let data = snapshot?.documents else {
                print("Document data was empty.")
                return
            }
            print(mc)
            for d in data {
                let decoder = FirebaseDecoder()
                guard let result = try? decoder.decode(User.self, from: d.data() as Any) else { return }
                if abs(self.getDistance(match: result)) < 0.5 {
                    if result.id != user.id {
                        if (result.trGrade >= mc.trGradeL) && (result.trGrade <= mc.trGradeH) {
                            if (result.sportGrade >= mc.sportGradeL) && (result.sportGrade <= mc.sportGradeH) {
                                if (result.tradGrade >= mc.tradGradeL) && (result.tradGrade <= mc.tradGradeH) {
                                    if (result.boulderGrade >= mc.boulderGradeL) && (result.boulderGrade <= mc.boulderGradeH) {
                                        self.climbers.append(result)
                                        self.dmTableView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.climbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MatchTVC = self.dmTableView.dequeueReusableCell(withIdentifier: "DmCellTV") as? MatchTVC else { print("error"); return MatchTVC() }
        cell.usernameLabel.text = climbers[indexPath.row].username
        cell.tradLabel.text = "5.\(climbers[indexPath.row].tradGrade)" + climbers[indexPath.row].tradLetter
        cell.trLabel.text = "5.\(climbers[indexPath.row].trGrade)" + climbers[indexPath.row].trLetter
        cell.sportLabel.text = "5.\(climbers[indexPath.row].sportGrade)" + climbers[indexPath.row].sportLetter
        cell.boulderLabel.text = "V\(climbers[indexPath.row].boulderGrade)"
        let userViewModel = UserViewModel(user: self.climbers[indexPath.row])
        userViewModel.getProfilePhoto { image in
            DispatchQueue.main.async {
                cell.profPic.setBackgroundImage(image, for: .normal)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.match = self.climbers[indexPath.row]
        self.linkToMatchProf()
    }
    
    
    @objc
    func linkToMess() {
        let msgLogContainer = MsgLogContainerVC()
        msgLogContainer.user = self.user
        msgLogContainer.friend = self.match
        msgLogContainer.dm = self.dm
        
        let nav = UINavigationController(rootViewController: msgLogContainer)
        nav.navigationBar.barTintColor = UISettings.shared.colorScheme.backgroundPrimary
        nav.navigationBar.tintColor = UIColor(named: "PinkAccent")
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.titleTextAttributes = [
            .foregroundColor: UISettings.shared.colorScheme.textPrimary,
            .font: UIFont(name: "Avenir-Black", size: 26) ?? .systemFont(ofSize: 26)
        ]
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc
    func linkToMatchProf() {
        let matchProf = MatchProfVC()
        matchProf.user = self.user
        matchProf.match = self.match
        
        let nav = UINavigationController(rootViewController: matchProf)
        nav.navigationBar.barTintColor = UISettings.shared.colorScheme.backgroundPrimary
        nav.navigationBar.tintColor = UIColor(named: "PinkAccent")
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.titleTextAttributes = [
            .foregroundColor: UISettings.shared.colorScheme.textPrimary,
            .font: UIFont(name: "Avenir-Black", size: 26) ?? .systemFont(ofSize: 26)
        ]
        self.present(nav, animated: true, completion: nil)
    }
   
    @objc func backToProf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func initViews() {
        let backButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backToProf))
        self.navigationItem.leftBarButtonItem = backButton
        
        self.dmTableView = UITableView()
        dmTableView.register(MatchTVC.self, forCellReuseIdentifier: "DmCellTV")
        dmTableView.dataSource = self
        dmTableView.delegate = self
        dmTableView.separatorStyle = .none
        dmTableView.backgroundColor = UISettings.shared.colorScheme.backgroundCell
        
        view.addSubview(dmTableView)
        
        dmTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: dmTableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dmTableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dmTableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dmTableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
}
