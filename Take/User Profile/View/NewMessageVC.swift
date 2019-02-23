import UIKit
import Firebase
import FirebaseFirestore

class NewMessageVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var user: User?
    var dmList: [DM] = []
    var friends: [User] = []
    var friendTableView: UITableView!
    var mySearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        mySearchBar.text = ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: SearchDMCell = self.friendTableView.dequeueReusableCell(withIdentifier: "SearchDMCell") as? SearchDMCell else { print("njifjinf")
            return SearchDMCell() }
        cell.usernameLabel.text = self.friends[indexPath.row].username
        print(self.friends[indexPath.row].username)
        print("helloooooooooo")
        print(self.friends)
        
        return cell
    }
    
    @objc
    func backToProf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.mySearchBar.resignFirstResponder()
        
        guard let searchText = searchBar.text else { return }
        Firestore.firestore().query(collection: "users", by: "name", with: searchText, of: User.self) { users in
            guard let user = users.first else { print("noooo i suck"); return }
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
