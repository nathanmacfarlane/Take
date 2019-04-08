import UIKit
import Firebase
import FirebaseFirestore

class NewMessageVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var user: User?
    var dmList: [DM] = []
    var dm: DM?
    var friends: [User] = []
    var friendTableView: UITableView!
    var mySearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        mySearchBar.text = ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: SearchDMCell = self.friendTableView.dequeueReusableCell(withIdentifier: "SearchDMCell") as? SearchDMCell else { print("error")
            return SearchDMCell() }
        cell.usernameLabel.text = self.friends[indexPath.row].username
        
        let userViewModel = UserViewModel(user: self.friends[indexPath.row])
        userViewModel.getProfilePhoto { image in
            DispatchQueue.main.async {
                cell.profPic.setBackgroundImage(image, for: .normal)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let userId = self.user?.id else { return }
        let friendId = self.friends[indexPath.row].id
        
        let tc = ThreadContent(message: "", sender: userId)
        dm = DM(messageId: UUID().uuidString, userIds: [userId, friendId], thread: [tc])
        
        if let messId = dm?.messageId { // append message id onto users
            self.friends[indexPath.row].messageIds.append(messId)
            self.user?.messageIds.append(messId)
        }
        Firestore.firestore().save(object: self.dm, to: "messages", with: self.dm?.messageId ?? "lol sheeit", completion: nil)
        Firestore.firestore().save(object: self.user, to: "users", with: self.user?.id ?? "lol sheeit", completion: nil)
        Firestore.firestore().save(object: self.friends[indexPath.row], to: "users", with: self.friends[indexPath.row].id, completion: nil)
        
        let msgLogContainer = MsgLogContainerVC()
        msgLogContainer.user = self.user
        msgLogContainer.friend = self.friends[indexPath.row]
        msgLogContainer.dm = dm

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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.mySearchBar.resignFirstResponder()
        
        guard let searchText = searchBar.text else { return }
        Firestore.firestore().query(collection: "users", by: "name", with: searchText, of: User.self) { users in
            guard let user = users.first else { print("error in search bar"); return }
            self.friends.append(user)
            self.friendTableView.reloadData()
        }
    }
    
    func initViews() {
        view.backgroundColor = UIColor(named: "BluePrimary")
        
        self.navigationItem.title = "New DM"
        let backButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backToProf))
        self.navigationItem.leftBarButtonItem = backButton
        
        // table
        self.friendTableView = UITableView()
        self.friendTableView.backgroundColor = .clear
        friendTableView.register(SearchDMCell.self, forCellReuseIdentifier: "SearchDMCell")
        friendTableView.dataSource = self
        friendTableView.delegate = self
        friendTableView.separatorStyle = .none
        
        // search bar stuff
        self.mySearchBar = UISearchBar()
        mySearchBar.delegate = self
        mySearchBar.searchBarStyle = .minimal
        mySearchBar.placeholder = "Search..."
        
        let textFieldInsideSearchBar = mySearchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        
        self.view.addSubview(mySearchBar)
        view.addSubview(self.friendTableView)
        
        // x, y, w, h
        mySearchBar.translatesAutoresizingMaskIntoConstraints = false
        let searchBarTopConst = NSLayoutConstraint(item: mySearchBar, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 15)
        let searchBarLeadingConst = NSLayoutConstraint(item: mySearchBar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let searchBarTrialingConst = NSLayoutConstraint(item: mySearchBar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([searchBarTopConst, searchBarLeadingConst, searchBarTrialingConst])
        
        friendTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: friendTableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: friendTableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: friendTableView, attribute: .top, relatedBy: .equal, toItem: mySearchBar, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: friendTableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
}

class SearchDMCell: UITableViewCell {
    
    var usernameLabel = UILabel()
    let container = UIView()
    var indent = CGFloat(100)
    var profPic: TypeButton!
    
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
        self.backgroundColor = UIColor(named: "BluePrimary")
        
        
        usernameLabel.textColor = .white
        usernameLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
        
        
        container.backgroundColor = UIColor(named: "BluePrimaryDark")
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 8
        
        profPic = TypeButton()
        profPic.addBorder(width: 1)
        profPic.layer.cornerRadius = 8
        profPic.clipsToBounds = true
        profPic.contentMode = .scaleAspectFit
        
        addSubview(container)
        addSubview(usernameLabel)
        addSubview(profPic)
        
        profPic.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: profPic, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: profPic, attribute: .centerY, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: profPic, attribute: .width, relatedBy: .equal, toItem: profPic, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: profPic, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 3 / 5, constant: 0).isActive = true
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 9/10).isActive = true
        container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 5/6).isActive = true
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.leftAnchor.constraint(equalTo: profPic.rightAnchor, constant: 25).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        usernameLabel.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 1).isActive = true
        usernameLabel.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 1/3).isActive = true
    }
    
}
