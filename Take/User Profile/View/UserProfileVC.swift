import Firebase
import FirebaseAuth
import Foundation
import Presentr
import UIKit
class UserProfileVC: UIViewController, NotificationPresenterVCDelegate {
    
    var user: User?
    var routeLists: [RouteListViewModel] = []
    var notifications: [Notification] = []
    var sportButton: TypeButton!
    var trButton: TypeButton!
    var boulderButton: TypeButton!
    var tradButton: TypeButton!
    var profPic: TypeButton!
    var partnerMatch =  UIButton()
    var editButton =  UIButton()
    var climberSearch =  UIButton()
    var profImage = UIImage()
    let userNameLabel = UILabel()
    let userBio = UILabel()
    let tradGrade = UILabel()
    let trGrade = UILabel()
    let sportGrade = UILabel()
    let boulderGrade = UILabel()
    
    var tradLetter = ""
    var trLetter = ""
    var sportLetter = ""
    
    //let boulderGrade = UILabel()
    //let aidGrade = UILabel()
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    // notification stuff
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        routeLists = []
        if let currentUser = Auth.auth().currentUser {
            getToDoLists(user: currentUser)
        }
        guard let user = self.user else { return }
        let userViewModel = UserViewModel(user: user)
        userViewModel.getProfilePhoto { image in
            DispatchQueue.main.async {
                self.profPic.setBackgroundImage(image, for: .normal)
            }
        }
    }
    
    func getToDoLists(user: Firebase.User) {
        let db = Firestore.firestore()
        db.query(collection: "users", by: "id", with: user.uid, of: User.self) { user in
            guard let user = user.first else { return }
            self.user = user
            self.userNameLabel.text = user.name
            self.userBio.text = user.bio
            self.trGrade.text = "5.\(user.trGrade)" + user.trLetter
            self.tradGrade.text = "5.\(user.tradGrade)" + user.tradLetter
            self.sportGrade.text = "5.\(user.sportGrade)" + user.sportLetter
            self.boulderGrade.text = "V\(user.boulderGrade)"
            let userViewModel = UserViewModel(user: user)
            userViewModel.getProfilePhoto { image in
                DispatchQueue.main.async {
                    self.profPic.setBackgroundImage(image, for: .normal)
                }
            }
        }
    }
    
    func clearedNotification(_ noti: Notification) {
        var index = 0
        for notification in notifications {
            if notification.id == noti.id {
                notifications.remove(at: index)
                if notifications.isEmpty {
                    //self.navigationItem.rightBarButtonItem?.tintColor = .white
                }
                return
            }
            index += 1
        }
    }
    
    func selectedNotification(_ noti: Notification) {
        if let noti = noti as? NotificationCollaboration {
            Firestore.firestore().query(collection: "routeLists", by: "id", with: noti.routeListId, of: RouteList.self) { routeList in
                guard let routeList = routeList.first else { return }
                let routeListVC = RouteListVC()
                routeListVC.user = self.user
                routeListVC.notification = noti
                routeListVC.routeListViewModel = RouteListViewModel(routeList: routeList)
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
                self.navigationController?.pushViewController(routeListVC, animated: true)
            }
        }
    }
    
    @objc
    func notiSelected() {
        guard let user = self.user else { return }
        let presenter: Presentr = {
            let customPresenter = Presentr(presentationType: .topHalf)
            customPresenter.transitionType = .coverVerticalFromTop
            customPresenter.dismissTransitionType = .crossDissolve
            customPresenter.roundCorners = true
            customPresenter.cornerRadius = 15
            customPresenter.backgroundColor = .white
            customPresenter.backgroundOpacity = 0.5
            return customPresenter
        }()
        let npvc = NotificationPresenterVC()
        npvc.delegate = self
        npvc.user = user
        npvc.notifications = self.notifications
        self.customPresentViewController(presenter, viewController: npvc, animated: true)
    }
    
    @objc
    func openDmView() {
        let dms = DirectMessVC()
        dms.user = user
        let nav = UINavigationController(rootViewController: dms)
        nav.navigationBar.barTintColor =  UISettings.shared.colorScheme.backgroundPrimary
        nav.navigationBar.tintColor =  UISettings.shared.colorScheme.accent
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.titleTextAttributes = [
            .foregroundColor: UISettings.shared.colorScheme.textPrimary,
            .font: UIFont(name: "Avenir-Black", size: 26) ?? .systemFont(ofSize: 26)
        ]
        present(nav, animated: true, completion: nil)
    }
    
    @objc
    func openPartnerMatchView() {
        let pm = PartnerMatchVC()
        guard let user = self.user else{ return }
        pm.user = user
        let nav = UINavigationController(rootViewController: pm)
        nav.navigationBar.barTintColor = UISettings.shared.colorScheme.backgroundPrimary
        nav.navigationBar.tintColor = UISettings.shared.colorScheme.accent
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor(named: "Placeholder") ?? .white,
            .font: UIFont(name: "Avenir-Black", size: 26) ?? .systemFont(ofSize: 26)
        ]
        present(nav, animated: true, completion: nil)
    }
    
    @objc
    func openEditProfile() {
        let ep = EditProfileVC()
        ep.user = self.user
        let nav = UINavigationController(rootViewController: ep)
        nav.navigationBar.barTintColor = UISettings.shared.colorScheme.backgroundPrimary
        nav.navigationBar.tintColor = UISettings.shared.colorScheme.accent
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor(named: "Placeholder") ?? .white,
            .font: UIFont(name: "Avenir-Black", size: 26) ?? .systemFont(ofSize: 26)
        ]
        present(nav, animated: true, completion: nil)
    }
    
    func initViews() {
        view.backgroundColor =  UISettings.shared.colorScheme.backgroundPrimary
        
        let msgButton = UIBarButtonItem(title: nil, style: .done, target: self, action: #selector(openDmView))
        let msgIcon = UIImage(named: "envelope")
        msgButton.image = msgIcon
        msgButton.tintColor = UISettings.shared.colorScheme.textSecondary
        self.navigationItem.rightBarButtonItem = msgButton
        
        let pmButton = UIBarButtonItem(title: nil, style: .done, target: self, action: #selector(openPartnerMatchView))
        let pmIcon = UIImage(named: "handshake")
        pmButton.image = pmIcon
        pmButton.tintColor = UISettings.shared.colorScheme.accent
        self.navigationItem.leftBarButtonItem = pmButton
        
        userNameLabel.textColor = UISettings.shared.colorScheme.textSecondary
        userNameLabel.textAlignment = .left
        userNameLabel.font = UIFont(name: "Avenir-Heavy", size: 22)
        
        userBio.textColor = UISettings.shared.colorScheme.textSecondary
        userBio.textAlignment = .left
        userBio.font = UIFont(name: "Avenir-Oblique", size: 16)
        userBio.numberOfLines = 0
        userBio.lineBreakMode = .byWordWrapping
        userBio.layer.masksToBounds = true
        
        // type buttons
        sportButton = TypeButton()
        sportButton.setTitle("S", for: .normal)
        sportButton.addBorder(color: UISettings.shared.colorScheme.textSecondary, width: 1)
        sportButton.backgroundColor = UIColor(hex: "#0E4343")
        
        boulderButton = TypeButton()
        boulderButton.setTitle("B", for: .normal)
        boulderButton.addBorder(color: UISettings.shared.colorScheme.textSecondary, width: 1)
        boulderButton.backgroundColor = UIColor(hex: "#0E4343")
        
        trButton = TypeButton()
        trButton.setTitle("TR", for: .normal)
        trButton.addBorder(color: UISettings.shared.colorScheme.textSecondary, width: 1)
        trButton.backgroundColor = UIColor(hex: "#0E4343")
        
        tradButton = TypeButton()
        tradButton.setTitle("T", for: .normal)
        tradButton.addBorder(color: UISettings.shared.colorScheme.textSecondary, width: 1)
        tradButton.backgroundColor = UIColor(hex: "#0E4343")
        
        profPic = TypeButton()
        profPic.addBorder(color: UISettings.shared.colorScheme.textSecondary, width: 2.5)
        profPic.clipsToBounds = true
        profPic.layer.cornerRadius = 8
        profPic.contentMode = .scaleAspectFit
        
        tradGrade.font = UIFont(name: "Avenir", size: 16)
        tradGrade.textColor = UISettings.shared.colorScheme.textSecondary
        tradGrade.textAlignment = .center
        
        trGrade.font = UIFont(name: "Avenir", size: 16)
        trGrade.textColor = UISettings.shared.colorScheme.textSecondary
        trGrade.textAlignment = .center
        
        sportGrade.font = UIFont(name: "Avenir", size: 16)
        sportGrade.textColor = UISettings.shared.colorScheme.textSecondary
        sportGrade.textAlignment = .center
        
        boulderGrade.font = UIFont(name: "Avenir", size: 16)
        boulderGrade.textColor = UISettings.shared.colorScheme.textSecondary
        boulderGrade.textAlignment = .center
        
        
        editButton = UIButton()
        editButton.addTarget(self, action: #selector(openEditProfile), for: UIControl.Event.touchUpInside)
        editButton.setTitle("Edit Profile", for: .normal)
        editButton.setTitleColor( .black, for: .normal)
        editButton.backgroundColor = UIColor(named: "Placeholder")
        editButton.layer.cornerRadius = 8
        
        view.addSubview(userNameLabel)
        view.addSubview(userBio)
        view.addSubview(sportButton)
        view.addSubview(trButton)
        view.addSubview(tradButton)
        view.addSubview(profPic)
        view.addSubview(trGrade)
        view.addSubview(tradGrade)
        view.addSubview(sportGrade)
        view.addSubview(editButton)
        view.addSubview(boulderGrade)
        view.addSubview(boulderButton)
        
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: userNameLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: userNameLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: userNameLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: userNameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true
        
        profPic.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: profPic, attribute: .trailing, relatedBy: .equal, toItem: userNameLabel, attribute: .leading, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: profPic, attribute: .top, relatedBy: .equal, toItem: userNameLabel, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: profPic, attribute: .width, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 3, constant: 0).isActive = true
        NSLayoutConstraint(item: profPic, attribute: .height, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 3, constant: 0).isActive = true
        
        userBio.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: userBio, attribute: .leading, relatedBy: .equal, toItem: userNameLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: userBio, attribute: .trailing, relatedBy: .equal, toItem: userNameLabel, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: userBio, attribute: .top, relatedBy: .equal, toItem: userNameLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: userBio, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        
        trGrade.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: trGrade, attribute: .centerX, relatedBy: .equal, toItem: trButton, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: trGrade, attribute: .top, relatedBy: .equal, toItem: trButton, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: trGrade, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: trGrade, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true
        
        tradGrade.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tradGrade, attribute: .centerX, relatedBy: .equal, toItem: tradButton, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradGrade, attribute: .top, relatedBy: .equal, toItem: trGrade, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradGrade, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: tradGrade, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true
        
        sportGrade.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: sportGrade, attribute: .centerX, relatedBy: .equal, toItem: sportButton, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sportGrade, attribute: .top, relatedBy: .equal, toItem: trGrade, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sportGrade, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: sportGrade, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true
        
        trButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: trButton, attribute: .trailing, relatedBy: .equal, toItem: sportButton, attribute: .leading, multiplier: 1, constant: -8).isActive = true
        NSLayoutConstraint(item: trButton, attribute: .leading, relatedBy: .equal, toItem: userNameLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: trButton, attribute: .top, relatedBy: .equal, toItem: userBio, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: trButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 10, constant: 0).isActive = true
        NSLayoutConstraint(item: trButton, attribute: .height, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 10, constant: 0).isActive = true
        
        sportButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: sportButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sportButton, attribute: .leading, relatedBy: .equal, toItem: trButton, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sportButton, attribute: .trailing, relatedBy: .equal, toItem: tradButton, attribute: .leading, multiplier: 1, constant: -8).isActive = true
        NSLayoutConstraint(item: sportButton, attribute: .bottom, relatedBy: .equal, toItem: trButton, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sportButton, attribute: .width, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sportButton, attribute: .height, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        
        tradButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tradButton, attribute: .trailing, relatedBy: .equal, toItem: trButton, attribute: .leading, multiplier: 1, constant: -8).isActive = true
        NSLayoutConstraint(item: tradButton, attribute: .leading, relatedBy: .equal, toItem: sportButton, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradButton, attribute: .bottom, relatedBy: .equal, toItem: trButton, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradButton, attribute: .width, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradButton, attribute: .height, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
       
        boulderButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: boulderButton, attribute: .leading, relatedBy: .equal, toItem: tradButton, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: boulderButton, attribute: .bottom, relatedBy: .equal, toItem: trButton, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: boulderButton, attribute: .width, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: boulderButton, attribute: .height, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        
        boulderGrade.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: boulderGrade, attribute: .centerX, relatedBy: .equal, toItem: boulderButton, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: boulderGrade, attribute: .top, relatedBy: .equal, toItem: trGrade, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: boulderGrade, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: boulderGrade, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: editButton, attribute: .leading, relatedBy: .equal, toItem: trButton, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: editButton, attribute: .top, relatedBy: .equal, toItem: trGrade, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: editButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: editButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50).isActive = true
    }
    
}

class InfoCell: UITableViewCell {
    
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
