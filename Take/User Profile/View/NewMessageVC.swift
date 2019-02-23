import UIKit
import Firebase
import FirebaseFirestore

class NewMessageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user: User?
    var dmList: [DM] = []
    var friendTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: SearchDMCell = self.friendTableView.dequeueReusableCell(withIdentifier: "SearchDMCell") as? SearchDMCell else { return SearchDMCell() }
//        for notMe in dms[indexPath.row].userIds where (notMe != self.user?.id) {
//            friendId = notMe
//        }
//        let db = Firestore.firestore()
//        db.query(collection: "users", by: "id", with: friendId, of: User.self) { users in
//            guard let user = users.first else { print("noooo i suck"); return }
//            self.friend.append(user)
//            cell.nameLabel.text = user.username // placeholder for username
//            let userViewModel = UserViewModel(user: user)
//            userViewModel.getProfilePhoto { image in
//                DispatchQueue.main.async {
//                    cell.profPic.setBackgroundImage(image, for: .normal)
//                }
//            }
//        }
//        cell.messageLabel.text = dms[indexPath.row].Thread.last?.message
//        self.dm = dms[indexPath.row]
//
        return cell
    }
    
    @objc
    func backToProf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func initViews() {
        self.navigationItem.title = "New DM"
        
        let backButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backToProf))
        
        self.navigationItem.leftBarButtonItem = backButton
    }
}

class SearchDMCell: UITableViewCell {
    
    var usernameLabel = UILabel()
    let container = UIView()
    var indent = CGFloat(100)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.backgroundColor = .black
        
        
        usernameLabel.textColor = .white
        usernameLabel.font = UIFont(name: "Avenir", size: 18)
        usernameLabel.text = "rockinatorDefault"
        
        
        container.backgroundColor = UIColor(named: "BluePrimary")
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 8
        
        addSubview(container)
        addSubview(usernameLabel)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 9/10).isActive = true
        container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 2/3).isActive = true
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 0).isActive = true
        usernameLabel.bottomAnchor.constraint(equalTo: container.topAnchor).isActive = true
        usernameLabel.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 1).isActive = true
        usernameLabel.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 1/3).isActive = true
    }
    
}
