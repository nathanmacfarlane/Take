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
    var partnerMatch = UIButton()
    var editButton = UIButton()
    var climberSearch = UIButton()
    var profImage = UIImage()
    var userNameLabel = UILabel()
    var userBio = UILabel()
    var tradGrade = UILabel()
    var trGrade = UILabel()
    var sportGrade = UILabel()
    var boulderGrade = UILabel()
    var infoTableView: UITableView!
    var info = [String]()
    
    var tradLetter = ""
    var trLetter = ""
    var sportLetter = ""
    var city = ""
    var state = ""
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
    }
    
    func getToDoLists(user: Firebase.User) {
        let db = Firestore.firestore()
        db.query(collection: "users", by: "id", with: user.uid, of: User.self) { user in
            guard var user = user.first else { return }
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
                    self.profPic.setImage(image, for: .normal)
                    self.profPic.imageView?.contentMode = .scaleAspectFill
                }
            }
            self.info = user.info
            LocationService.shared.location?.cityAndState { city, state, _ in
                guard let c = city else { print("CITY NOT FOUND "); return }
                guard let s = state else { return }
                user.location[0] = LocationService.shared.location?.coordinate.latitude ?? 0
                user.location[1] = LocationService.shared.location?.coordinate.longitude ?? 0
                
                Firestore.firestore().save(object: user, to: "users", with: self.user?.id ?? "error in updating profile", completion: nil)
                
                
                self.info.insert("\(c), \(s)", at: 0)
                self.infoTableView.reloadData()
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
        ep.info = self.info
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
    
    var seg: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Info", "PlanADay"])
        let font = UIFont(name: "Avenir-Heavy", size: 18)
        sc.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        sc.tintColor = UISettings.shared.colorScheme.textSecondary
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleSegmentChanges), for: .valueChanged)
        return sc
    }()
    
    @objc
    func handleSegmentChanges() {
        if seg.selectedSegmentIndex == 0 {
            infoTableView.isHidden = false
        }
        else if seg.selectedSegmentIndex == 1 {
            infoTableView.isHidden = true
        }
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
        
        self.infoTableView = UITableView()
        infoTableView.register(InfoCell.self, forCellReuseIdentifier: "InfoCell")
        infoTableView.dataSource = self
        infoTableView.delegate = self
        infoTableView.separatorStyle = .none
        infoTableView.backgroundColor = UISettings.shared.colorScheme.backgroundPrimary
        infoTableView.isHidden = false
        
        userNameLabel = LabelAvenir(size: 22, type: .Heavy, color: UISettings.shared.colorScheme.textSecondary, alignment: .left)
        
        userBio = LabelAvenir(size: 16, type: .Medium, color: UISettings.shared.colorScheme.textSecondary, alignment: .left)
        userBio.numberOfLines = 0
        userBio.lineBreakMode = .byWordWrapping
        userBio.layer.masksToBounds = true
        
        // type buttons
        sportButton = TypeButton()
        sportButton.setTitle("S", for: .normal)
        sportButton.addBorder(color: UISettings.shared.colorScheme.textSecondary, width: 1)
        sportButton.backgroundColor = UIColor(hex: "#0E4343")
        sportButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        
        boulderButton = TypeButton()
        boulderButton.setTitle("B", for: .normal)
        boulderButton.addBorder(color: UISettings.shared.colorScheme.textSecondary, width: 1)
        boulderButton.backgroundColor = UIColor(hex: "#0E4343")
        boulderButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        
        trButton = TypeButton()
        trButton.setTitle("TR", for: .normal)
        trButton.addBorder(color: UISettings.shared.colorScheme.textSecondary, width: 1)
        trButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        trButton.backgroundColor = UIColor(hex: "#0E4343")
        
        tradButton = TypeButton()
        tradButton.setTitle("T", for: .normal)
        tradButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        tradButton.addBorder(color: UISettings.shared.colorScheme.textSecondary, width: 1)
        tradButton.backgroundColor = UIColor(hex: "#0E4343")
        
        profPic = TypeButton()
        profPic.addBorder(color: UISettings.shared.colorScheme.textSecondary, width: 2.5)
        profPic.clipsToBounds = true
        profPic.layer.cornerRadius = 8
        profPic.contentMode = .scaleAspectFit
        
        tradGrade = LabelAvenir(size: 16, type: .Book, color: UISettings.shared.colorScheme.textSecondary, alignment: .center)
        
        trGrade = LabelAvenir(size: 16, type: .Book, color: UISettings.shared.colorScheme.textSecondary, alignment: .center)
        
        sportGrade = LabelAvenir(size: 16, type: .Book, color: UISettings.shared.colorScheme.textSecondary, alignment: .center)
        
        boulderGrade = LabelAvenir(size: 16, type: .Book, color: UISettings.shared.colorScheme.textSecondary, alignment: .center)
        
        
        editButton = UIButton()
        editButton.addTarget(self, action: #selector(openEditProfile), for: UIControl.Event.touchUpInside)
        editButton.setTitle("Edit Profile", for: .normal)
        editButton.setTitleColor( .black, for: .normal)
        editButton.backgroundColor = UIColor(named: "Placeholder")
        editButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
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
        view.addSubview(infoTableView)
        view.addSubview(seg)
        
        seg.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: seg, attribute: .leading , relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: seg, attribute: .top, relatedBy: .equal, toItem: editButton, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: seg, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -30).isActive = true
        NSLayoutConstraint(item: seg, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 45).isActive = true
        
        infoTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: infoTableView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: infoTableView, attribute: .top, relatedBy: .equal, toItem: seg, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: infoTableView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: infoTableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
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
        NSLayoutConstraint(item: editButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40).isActive = true
    }
    
}

class InfoCell: UITableViewCell {
    
    var infoLabel = UILabel()
    let container = UIView()
    var indent = CGFloat(100)
    var infoPic = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layer.masksToBounds = true
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.backgroundColor = UIColor(named: "BluePrimary")
        
        infoLabel.textColor = UISettings.shared.colorScheme.textPrimary
        infoLabel.font = UIFont(name: "Avenir-Heavy", size: 14)
        infoLabel.textAlignment = .left
        
        
        container.backgroundColor = UISettings.shared.colorScheme.backgroundCell
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 8
        
        infoPic.contentMode = .scaleAspectFill
        
        addSubview(container)
        addSubview(infoLabel)
        addSubview(infoPic)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: container, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: container, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: container, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -8).isActive = true
        NSLayoutConstraint(item: container, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 8/9, constant: 0).isActive = true
        
        
        infoPic.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: infoPic, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: infoPic, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: infoPic, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: infoPic, attribute: .width, relatedBy: .equal, toItem: container, attribute: .height, multiplier: 1, constant: 0).isActive = true
        
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.leadingAnchor.constraint(equalTo: infoPic.trailingAnchor, constant: 10).isActive = true
        infoLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 1).isActive = true
        infoLabel.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 1/3).isActive = true
    }
    
}
