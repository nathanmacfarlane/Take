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
    var partnerMatchButton: TypeButton!
    let image = UIImage(named: "rocki2.jpeg")

    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }

// notification stuff
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        routeLists = []
//        if let currentUser = Auth.auth().currentUser {
//            getToDoLists(user: currentUser)
//        }
//    }

//    func getToDoLists(user: Firebase.User) {
//        let db = Firestore.firestore()
//        db.query(collection: "users", by: "id", with: user.uid, of: User.self) { user in
//            guard let user = user.first else { return }
//            self.user = user
//            self.user?.name = user.name
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
//        }
//    }

    func clearedNotification(_ noti: Notification) {
        var index = 0
        for notification in notifications {
            if notification.id == noti.id {
                notifications.remove(at: index)
                if notifications.isEmpty {
                    self.navigationItem.rightBarButtonItem?.tintColor = .white
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
    private func goLogout(sender: UIButton!) {
        try? Auth.auth().signOut()
        self.present(LoginVC(), animated: true, completion: nil)
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
    func openNextView() {
        let dms = DirectMessVC()
        present(dms, animated: true, completion: nil)
    }
    
    func initViews() {
        view.backgroundColor = UIColor(named: "BluePrimaryDark")
        let tradGrade = UILabel()
        let trGrade = UILabel()
        let sportGrade = UILabel()
        //let boulderGrade = UILabel()
        //let aidGrade = UILabel()
        let userNameLabel = UILabel()

        // nav logout button
        let myNavLogoutButton = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(goLogout))
        myNavLogoutButton.tintColor = UIColor(named: "PinkAccent")
        self.navigationItem.leftBarButtonItem = myNavLogoutButton

        // nav noti button
        let notiIcon = UIImage(named: "notification")
        let notiIconButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(notiSelected))
        notiIconButton.image = notiIcon
        notiIconButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = notiIconButton
        // why is this not working?
        //userNameLabel.text = self.user?.name
        userNameLabel.text = "Rocki Bonilla"
        userNameLabel.textColor = .white
        userNameLabel.textAlignment = .left
        userNameLabel.font = UIFont(name: "Avenir-Heavy", size: 22)
        let userBio = UILabel()
        userBio.textColor = .lightGray
        userBio.textAlignment = .left
        userBio.font = UIFont(name: "Avenir-Oblique", size: 16)
        userBio.text = "I am a climber"
        // type buttons
        sportButton = TypeButton()
        sportButton.setTitle("S", for: .normal)
        sportButton.addBorder(width: 1)
        sportButton.backgroundColor = UIColor(hex: "#0E4343")
        
        trButton = TypeButton()
        trButton.setTitle("TR", for: .normal)
        trButton.addBorder(width: 1)
        trButton.backgroundColor = UIColor(hex: "#0E4343")
        
        tradButton = TypeButton()
        tradButton.setTitle("T", for: .normal)
        tradButton.addBorder(width: 1)
        tradButton.backgroundColor = UIColor(hex: "#0E4343")
        
        profPic = TypeButton()
        profPic.addBorder(width: 2.5)
        profPic.setBackgroundImage(image, for: .normal)
        profPic.layer.cornerRadius = 8
        profPic.clipsToBounds = true
        profPic.contentMode = .scaleAspectFill
        
        partnerMatchButton = TypeButton()
        partnerMatchButton.setTitle("partner match", for: .normal)
        partnerMatchButton.layer.cornerRadius = 8
        partnerMatchButton.translatesAutoresizingMaskIntoConstraints = false
        partnerMatchButton.backgroundColor = UIColor(hex: "#CB27BE")
        partnerMatchButton.addTarget(self, action: #selector(openNextView), for: .touchUpInside)
        
        
        tradGrade.text = "5.7"
        tradGrade.font = UIFont(name: "Avenir", size: 16)
        tradGrade.textColor = .white
        tradGrade.textAlignment = .left
        
        trGrade.text = "5.11"
        trGrade.font = UIFont(name: "Avenir", size: 16)
        trGrade.textColor = .white
        trGrade.textAlignment = .left
        
        sportGrade.text = "5.10"
        sportGrade.font = UIFont(name: "Avenir", size: 16)
        sportGrade.textColor = .white
        sportGrade.textAlignment = .left
        
        view.addSubview(userNameLabel)
        view.addSubview(userBio)
        view.addSubview(sportButton)
        view.addSubview(trButton)
        view.addSubview(tradButton)
        view.addSubview(profPic)
        view.addSubview(trGrade)
        view.addSubview(tradGrade)
        view.addSubview(sportGrade)
        view.addSubview(partnerMatchButton)
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: userNameLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: userNameLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: userNameLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: userNameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true
        profPic.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: profPic, attribute: .trailing, relatedBy: .equal, toItem: userNameLabel, attribute: .leading, multiplier: 1, constant: -25).isActive = true
        NSLayoutConstraint(item: profPic, attribute: .top, relatedBy: .equal, toItem: userNameLabel, attribute: .top, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: profPic, attribute: .width, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 4, constant: 0).isActive = true
        NSLayoutConstraint(item: profPic, attribute: .height, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 4, constant: 0).isActive = true
        userBio.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: userBio, attribute: .centerX, relatedBy: .equal, toItem: userNameLabel, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: userBio, attribute: .trailing, relatedBy: .equal, toItem: userNameLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: userBio, attribute: .top, relatedBy: .equal, toItem: userNameLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: userBio, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        trButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: trButton, attribute: .trailing, relatedBy: .equal, toItem: sportButton, attribute: .leading, multiplier: 1, constant: -8).isActive = true
        NSLayoutConstraint(item: trButton, attribute: .leading, relatedBy: .equal, toItem: userNameLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: trButton, attribute: .bottom, relatedBy: .equal, toItem: profPic, attribute: .bottom, multiplier: 1, constant: -35).isActive = true
        NSLayoutConstraint(item: trButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 10, constant: 0).isActive = true
        NSLayoutConstraint(item: trButton, attribute: .height, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 10, constant: 0).isActive = true
        sportButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: sportButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sportButton, attribute: .leading, relatedBy: .equal, toItem: trButton, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sportButton, attribute: .trailing, relatedBy: .equal, toItem: tradButton, attribute: .leading, multiplier: 1, constant: -8).isActive = true
        NSLayoutConstraint(item: sportButton, attribute: .bottom, relatedBy: .equal, toItem: profPic, attribute: .bottom, multiplier: 1, constant: -35).isActive = true
        NSLayoutConstraint(item: sportButton, attribute: .width, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sportButton, attribute: .height, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        tradButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tradButton, attribute: .trailing, relatedBy: .equal, toItem: trButton, attribute: .leading, multiplier: 1, constant: -8).isActive = true
        NSLayoutConstraint(item: tradButton, attribute: .leading, relatedBy: .equal, toItem: sportButton, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradButton, attribute: .bottom, relatedBy: .equal, toItem: profPic, attribute: .bottom, multiplier: 1, constant: -35).isActive = true
        NSLayoutConstraint(item: tradButton, attribute: .width, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradButton, attribute: .height, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        trGrade.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: trGrade, attribute: .leading, relatedBy: .equal, toItem: trButton, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: trGrade, attribute: .top, relatedBy: .equal, toItem: trButton, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: trGrade, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: trGrade, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true
        tradGrade.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tradGrade, attribute: .leading, relatedBy: .equal, toItem: tradButton, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: tradGrade, attribute: .top, relatedBy: .equal, toItem: tradButton, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: tradGrade, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: tradGrade, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true
        sportGrade.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: sportGrade, attribute: .leading, relatedBy: .equal, toItem: sportButton, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: sportGrade, attribute: .top, relatedBy: .equal, toItem: sportButton, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: sportGrade, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: sportGrade, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true
        
        partnerMatchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: partnerMatchButton, attribute: .leading, relatedBy: .equal, toItem: sportButton, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: partnerMatchButton, attribute: .top, relatedBy: .equal, toItem: sportButton, attribute: .bottom, multiplier: 1, constant: 90).isActive = true
        NSLayoutConstraint(item: partnerMatchButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: partnerMatchButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true

    }
    
}
