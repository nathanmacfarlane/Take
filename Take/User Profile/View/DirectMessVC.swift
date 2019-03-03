import Firebase
import FirebaseAuth
import Foundation
import Presentr
import UIKit

class DirectMessVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var user: User?
    var friends: [User] = []
    var dms: [DM] = []
    var dm: DM?
    var profImage = UIImage()
    var dmTableView: UITableView!
    var friendId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDms()
        initViews()
        
    }
    
    func getDms() {
        let db = Firestore.firestore()
        
        guard let messages = self.user?.messageIds else { return }
        for message in messages {
            db.query(collection: "messages", by: "messageId", with: message, of: DM.self) {
                dm in
                guard let mess = dm.first else { print("noooo i suck"); return }
                self.dms.append(mess)
                self.dmTableView.reloadData()
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: DmTVC = self.dmTableView.dequeueReusableCell(withIdentifier: "DmCellTV") as? DmTVC else { print("yooooooo"); return DmTVC() }
        for notMe in dms[indexPath.row].userIds where (notMe != self.user?.id) {
            friendId = notMe
        }
        let db = Firestore.firestore()
        db.query(collection: "users", by: "id", with: friendId, of: User.self) { users in
            guard let user = users.first else { print("noooo i suck"); return }
            self.friends.append(user)
            cell.nameLabel.text = user.username // placeholder for username
            let userViewModel = UserViewModel(user: user)
            userViewModel.getProfilePhoto { image in
                DispatchQueue.main.async {
                    cell.profPic.setBackgroundImage(image, for: .normal)
                }
            }
        }
        cell.messageLabel.text = dms[indexPath.row].Thread.last?.message
        self.dm = dms[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let msgLogContainer = MsgLogContainerVC()
        msgLogContainer.user = self.user
        msgLogContainer.dm = self.dms[indexPath.row]
        
        // friend array was not in the expected order... so this is the work-around
        for notMe in dms[indexPath.row].userIds where (notMe != self.user?.id) {
            friendId = notMe
        }
        for fri in self.friends {
            if(fri.id == friendId) {
                print(fri)
                msgLogContainer.friend = fri
            }
        }
        
        let nav = UINavigationController(rootViewController: msgLogContainer)
        nav.navigationBar.barTintColor = UIColor(named: "BluePrimaryDark")
        nav.navigationBar.tintColor = UIColor(named: "PinkAccent")
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor(named: "Placeholder") ?? .white,
            .font: UIFont(name: "Avenir-Black", size: 26) ?? .systemFont(ofSize: 26)
        ]
        present(nav, animated: true, completion: nil)
    
    }
    
    @objc
     func backToProf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func toNewMess() {
        let newDM = NewMessageVC()
        newDM.user = self.user
        newDM.dmList = self.dms
        let nav = UINavigationController(rootViewController: newDM)
        nav.navigationBar.barTintColor = UIColor(named: "BluePrimaryDark")
        nav.navigationBar.tintColor = UIColor(named: "PinkAccent")
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor(named: "Placeholder") ?? .white,
            .font: UIFont(name: "Avenir-Black", size: 26) ?? .systemFont(ofSize: 26)
        ]
        present(nav, animated: true, completion: nil)
    }
    
    func initViews() {
        self.navigationItem.title = "DMs"
        // table view
        self.dmTableView = UITableView()
        dmTableView.register(DmTVC.self, forCellReuseIdentifier: "DmCellTV")
        dmTableView.dataSource = self
        dmTableView.delegate = self
        dmTableView.separatorStyle = .none 
        dmTableView.backgroundColor = UIColor(named: "BluePrimaryDark")
        
        let backButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backToProf))
        let newMessButton = UIBarButtonItem(image: UIImage(named: "icon_edit"), style: .done, target: self, action: #selector(toNewMess))
        
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = newMessButton
        
        view.addSubview(dmTableView)
        
        dmTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: dmTableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dmTableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dmTableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dmTableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
}
