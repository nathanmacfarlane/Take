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
    var tradButton: TypeButton!
    var profPic: TypeButton!
    var home: TypeButton!
    var carabiner: TypeButton!
    var beer: TypeButton!
    var whippers: TypeButton!
    var partnerMatch =  UIButton()
    var editButton =  UIButton()
    var climberSearch =  UIButton()
    var profImage = UIImage()
    let homeImage = UIImage(named: "home.png")
    let carabinerImage = UIImage(named: "carabiner.png")
    let beerImage = UIImage(named: "beer.png")
    let whipImage = UIImage(named: "octo.png")
    let userNameLabel = UILabel()
    let userBio = UILabel()
    let homeLabel = UILabel()
    let carabinerLabel = UILabel()
    let beerLabel = UILabel()
    let whipLabel = UILabel()
    let tradGrade = UILabel()
    let trGrade = UILabel()
    let sportGrade = UILabel()
    
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
    }
    
    func getLetters() {
        
    }
    func getToDoLists(user: Firebase.User) {
        let db = Firestore.firestore()
        db.query(collection: "users", by: "id", with: user.uid, of: User.self) { user in
            guard let user = user.first else { return }
            self.user = user
            self.userNameLabel.text = user.name
            self.userBio.text = user.bio
            self.beerLabel.text = "Favorite beer is \(user.beer)"
            self.whipLabel.text = "Number of massive whips: \(user.whips)"
            self.carabinerLabel.text = "Climbing since \(user.climbYear)"
            self.trGrade.text = "5.\(user.trGrade)" + user.trLetter
            self.tradGrade.text = "5.\(user.tradGrade)" + user.tradLetter
            self.sportGrade.text = "5.\(user.sportGrade)" + user.sportLetter
            let userViewModel = UserViewModel(user: user)
            userViewModel.getProfilePhoto { image in
                DispatchQueue.main.async {
                    self.profPic.setBackgroundImage(image, for: .normal)
                }
            }
            
            //            for routeListId in user.toDo {
            //                db.query(collection: "routeLists", by: "id", with: routeListId, of: RouteList.self) { routeList in
            //                    guard let routeList = routeList.first else { return }
            //                    self.routeLists.append(RouteListViewModel(routeList: routeList))
            //                    self.tableView.reloadData()
            //                }
            //            }
            //            let userViewModel = UserViewModel(user: user)
            //            userViewModel.getNotifications { notifications in
            //                self.notifications = notifications
            //                if !notifications.isEmpty {
            //                    self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "PinkAccent")
            //                } else {
            //                    self.navigationItem.rightBarButtonItem?.tintColor = .white
            //                }
            //            }
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
        
        //        // nav noti button
        //        let notiIcon = UIImage(named: "notification")
        //        let notiIconButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(notiSelected))
        //        notiIconButton.image = notiIcon
        //        notiIconButton.tintColor = .white
        //        self.navigationItem.rightBarButtonItem = notiIconButton
        
        let msgButton = UIBarButtonItem(title: nil, style: .done, target: self, action: #selector(openDmView))
        let msgIcon = UIImage(named: "mail.png")
        msgButton.image = msgIcon
        msgButton.tintColor = UISettings.shared.colorScheme.textSecondary
        self.navigationItem.rightBarButtonItem = msgButton
        
        let pmButton = UIBarButtonItem(title: nil, style: .done, target: self, action: #selector(openPartnerMatchView))
        let pmIcon = UIImage(named: "rope")
        pmButton.image = pmIcon
        pmButton.tintColor = UISettings.shared.colorScheme.accent
        self.navigationItem.leftBarButtonItem = pmButton
        
        userNameLabel.textColor = UISettings.shared.colorScheme.textSecondary
        userNameLabel.textAlignment = .left
        userNameLabel.font = UIFont(name: "Avenir-Heavy", size: 22)
        
        userBio.textColor = UISettings.shared.colorScheme.textSecondary
        userBio.textAlignment = .left
        userBio.font = UIFont(name: "Avenir-Oblique", size: 16)
        
        homeLabel.textColor = UISettings.shared.colorScheme.textSecondary
        homeLabel.textAlignment = .left
        homeLabel.font = UIFont(name: "Avenir", size: 20)
        homeLabel.text = "Currently in San Luis Obispo, Ca"
        
        carabinerLabel.textColor = UISettings.shared.colorScheme.textSecondary
        carabinerLabel.textAlignment = .left
        carabinerLabel.font = UIFont(name: "Avenir", size: 20)
        
        beerLabel.textColor = UISettings.shared.colorScheme.textSecondary
        beerLabel.textAlignment = .left
        beerLabel.font = UIFont(name: "Avenir", size: 20)
        
        whipLabel.textColor = UISettings.shared.colorScheme.textSecondary
        whipLabel.textAlignment = .left
        whipLabel.font = UIFont(name: "Avenir", size: 20)
        
        // type buttons
        sportButton = TypeButton()
        sportButton.setTitle("S", for: .normal)
        sportButton.addBorder(color: UISettings.shared.colorScheme.textSecondary, width: 1)
        sportButton.backgroundColor = UIColor(hex: "#0E4343")
        
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
        
        home = TypeButton()
        home.setBackgroundImage(homeImage, for: .normal)
        home.tintColor = UISettings.shared.colorScheme.textSecondary
        
        carabiner = TypeButton()
        carabiner.setBackgroundImage(carabinerImage, for: .normal)
        carabiner.tintColor = UISettings.shared.colorScheme.textSecondary
        
        beer = TypeButton()
        beer.setBackgroundImage(beerImage, for: .normal)
        beer.tintColor = UISettings.shared.colorScheme.textSecondary
        
        whippers = TypeButton()
        whippers.setBackgroundImage(whipImage, for: .normal)
        whippers.tintColor = UISettings.shared.colorScheme.textSecondary
        
        tradGrade.font = UIFont(name: "Avenir", size: 16)
        tradGrade.textColor = UISettings.shared.colorScheme.textSecondary
        tradGrade.textAlignment = .left
        
        trGrade.font = UIFont(name: "Avenir", size: 16)
        trGrade.textColor = UISettings.shared.colorScheme.textSecondary
        trGrade.textAlignment = .left
        
        sportGrade.font = UIFont(name: "Avenir", size: 16)
        sportGrade.textColor = UISettings.shared.colorScheme.textSecondary
        sportGrade.textAlignment = .left
        
        
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
        view.addSubview(home)
        view.addSubview(carabiner)
        view.addSubview(beer)
        view.addSubview(whippers)
        view.addSubview(homeLabel)
        view.addSubview(carabinerLabel)
        view.addSubview(beerLabel)
        view.addSubview(whipLabel)
        view.addSubview(editButton)
        
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: userNameLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: userNameLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: userNameLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 2, constant: 0).isActive = true
        NSLayoutConstraint(item: userNameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true
        
        profPic.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: profPic, attribute: .trailing, relatedBy: .equal, toItem: userNameLabel, attribute: .leading, multiplier: 1, constant: -40).isActive = true
        NSLayoutConstraint(item: profPic, attribute: .top, relatedBy: .equal, toItem: userNameLabel, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: profPic, attribute: .width, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 3, constant: 0).isActive = true
        NSLayoutConstraint(item: profPic, attribute: .height, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 3, constant: 0).isActive = true
        
        userBio.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: userBio, attribute: .centerX, relatedBy: .equal, toItem: userNameLabel, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: userBio, attribute: .trailing, relatedBy: .equal, toItem: userNameLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: userBio, attribute: .top, relatedBy: .equal, toItem: userNameLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: userBio, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        
        trGrade.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: trGrade, attribute: .leading, relatedBy: .equal, toItem: trButton, attribute: .leading, multiplier: 1, constant: 2).isActive = true
        NSLayoutConstraint(item: trGrade, attribute: .bottom, relatedBy: .equal, toItem: profPic, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: trGrade, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: trGrade, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true
        
        tradGrade.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tradGrade, attribute: .leading, relatedBy: .equal, toItem: tradButton, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: tradGrade, attribute: .bottom, relatedBy: .equal, toItem: profPic, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradGrade, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: tradGrade, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true
        
        sportGrade.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: sportGrade, attribute: .leading, relatedBy: .equal, toItem: sportButton, attribute: .leading, multiplier: 1, constant: 2).isActive = true
        NSLayoutConstraint(item: sportGrade, attribute: .bottom, relatedBy: .equal, toItem: profPic, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sportGrade, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: sportGrade, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true
        
        trButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: trButton, attribute: .trailing, relatedBy: .equal, toItem: sportButton, attribute: .leading, multiplier: 1, constant: -8).isActive = true
        NSLayoutConstraint(item: trButton, attribute: .leading, relatedBy: .equal, toItem: userNameLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: trButton, attribute: .bottom, relatedBy: .equal, toItem: trGrade, attribute: .top, multiplier: 1, constant: -5).isActive = true
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
        
        home.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: home, attribute: .leading, relatedBy: .equal, toItem: profPic, attribute: .leading, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: home,  attribute: .top, relatedBy: .equal, toItem: profPic, attribute: .bottom, multiplier: 1, constant: 80).isActive = true
        NSLayoutConstraint(item: home, attribute: .width, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: home, attribute: .height, relatedBy: .equal, toItem: trButton, attribute: .height, multiplier: 1, constant: 1).isActive = true
        
        carabiner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: carabiner, attribute: .leading, relatedBy: .equal, toItem: home, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: carabiner,  attribute: .top, relatedBy: .equal, toItem: home, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: carabiner, attribute: .width, relatedBy: .equal, toItem: home, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: carabiner, attribute: .height, relatedBy: .equal, toItem: home, attribute: .height, multiplier: 1, constant: 0).isActive = true
        
        beer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: beer, attribute: .leading, relatedBy: .equal, toItem: home, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: beer,  attribute: .top, relatedBy: .equal, toItem: carabiner, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: beer, attribute: .width, relatedBy: .equal, toItem: home, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: beer, attribute: .height, relatedBy: .equal, toItem: home, attribute: .height, multiplier: 1, constant: 0).isActive = true
        
        whippers.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: whippers, attribute: .leading, relatedBy: .equal, toItem: beer, attribute: .leading, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: whippers,  attribute: .top, relatedBy: .equal, toItem: beer, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: whippers, attribute: .width, relatedBy: .equal, toItem: home, attribute: .width, multiplier: 1.5, constant: 0).isActive = true
        NSLayoutConstraint(item: whippers, attribute: .height, relatedBy: .equal, toItem: home, attribute: .height, multiplier: 1.5, constant: 0).isActive = true
        
        homeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: homeLabel, attribute: .leading, relatedBy: .equal, toItem: home, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: homeLabel,  attribute: .bottom, relatedBy: .equal, toItem: home, attribute: .bottom, multiplier: 1, constant: -5).isActive = true
        
        carabinerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: carabinerLabel, attribute: .leading, relatedBy: .equal, toItem: carabiner, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: carabinerLabel,  attribute: .bottom, relatedBy: .equal, toItem: carabiner, attribute: .bottom, multiplier: 1, constant: -5).isActive = true
        
        beerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: beerLabel, attribute: .leading, relatedBy: .equal, toItem: beer, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: beerLabel,  attribute: .bottom, relatedBy: .equal, toItem: beer, attribute: .bottom, multiplier: 1, constant: -5).isActive = true
        
        whipLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: whipLabel, attribute: .leading, relatedBy: .equal, toItem: whippers, attribute: .trailing, multiplier: 1, constant: -5).isActive = true
        NSLayoutConstraint(item: whipLabel,  attribute: .bottom, relatedBy: .equal, toItem: whippers, attribute: .bottom, multiplier: 1, constant: -20).isActive = true
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: editButton, attribute: .leading, relatedBy: .equal, toItem: trButton, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: editButton, attribute: .top, relatedBy: .equal, toItem: trGrade, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: editButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: editButton, attribute: .height, relatedBy: .equal, toItem: home, attribute: .height, multiplier: 1.0, constant: 0).isActive = true
    }
    
}
