import Firebase
import FirebaseAuth
import Foundation
import Presentr
import UIKit
class MatchProfVC: UIViewController {
    
    var user: User?
    var match: User?
    var dm: DM?
    var routeLists: [RouteListViewModel] = []
    var notifications: [Notification] = []
    var sportButton: TypeButton!
    var trButton: TypeButton!
    var tradButton: TypeButton!
    var profPic: TypeButton!
    var boulderButton: TypeButton!
    var partnerMatch = UIButton()
    var editButton = UIButton()
    var climberSearch = UIButton()
    var profImage = UIImage()
    let userNameLabel = UILabel()
    let userBio = UILabel()
    let tradGrade = UILabel()
    let trGrade = UILabel()
    let sportGrade = UILabel()
    let boulderGrade = UILabel()
    var flag = false
    
    var tradLetter = ""
    var trLetter = ""
    var sportLetter = ""
    var tableView: UITableView!

    var presented = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    // notification stuff
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        routeLists = []
        getMatch()
    }
    
    func getMatch() {
        
        guard let match = self.match else { return }
        self.userNameLabel.text = match.name
        self.userBio.text = match.bio
        self.trGrade.text = "5.\(match.trGrade)" + match.trLetter
        self.tradGrade.text = "5.\(match.tradGrade)" + match.tradLetter
        self.sportGrade.text = "5.\(match.sportGrade)" + match.sportLetter
        self.boulderGrade.text = "V\(match.boulderGrade)"
        let userViewModel = UserViewModel(user: match)
        userViewModel.getProfilePhoto { image in
            DispatchQueue.main.async {
                self.profPic.setBackgroundImage(image, for: .normal)
            }
        }
        
    }
    
    @objc func openDM() {
        
        self.flag = false
        var count = 0
        guard let user = self.user else { return }
        guard let match = self.match else { return }

        for msgId in user.messageIds {
            count += 1
            if match.messageIds.contains(msgId) {
                self.flag = true
                let db = Firestore.firestore()
                db.query(collection: "messages", by: "messageId", with: msgId, of: DM.self) { dm in
                    guard let mess = dm.first else { print("error finding dm"); return }
                    self.dm = mess
                    self.linkToMsg()
                }
                break
            }
            if(!self.flag && count == user.messageIds.count) {
                self.newDM()
                self.flag = true
            }
        }
        if !self.flag {
            self.newDM()
        }
    }

    @objc func newDM() {
        guard let user = self.user else { return }
        guard let match = self.match else { return }

        let tc = ThreadContent(message: "", sender: user.id)
        self.dm = DM(messageId: UUID().uuidString, userIds: [user.id, match.id], thread: [tc])
        if let messId = self.dm?.messageId { // append message id onto users
            self.match?.messageIds.append(messId)
            self.user?.messageIds.append(messId)
        }
        Firestore.firestore().save(object: self.dm, to: "messages", with: self.dm?.messageId ?? "error in creating new msg", completion: nil)
        Firestore.firestore().save(object: self.user, to: "users", with: self.user?.id ?? "error in creating new msg", completion: nil)
        Firestore.firestore().save(object: self.match, to: "users", with: self.match?.id ?? "error in creating new msg", completion: nil)
        self.linkToMsg()
    }
    
    @objc func linkToMsg() {
        let msgLogContainer = MsgLogContainerVC()
        msgLogContainer.user = self.user
        msgLogContainer.friend = self.match
        msgLogContainer.dm = self.dm
        
        let nav = UINavigationController(rootViewController: msgLogContainer)
        nav.navigationBar.barTintColor = UISettings.shared.colorScheme.backgroundPrimary
        nav.navigationBar.tintColor = UIColor(named: "PinkAccent")
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor(named: "Placeholder") ?? .white,
            .font: UIFont(name: "Avenir-Black", size: 26) ?? .systemFont(ofSize: 26)
        ]
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func backToMatches() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func initViews() {
        if presented {
            let backButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backToMatches))
            self.navigationItem.leftBarButtonItem = backButton
            self.navigationItem.leftBarButtonItem?.tintColor = UISettings.shared.colorScheme.accent
            self.navigationItem.title = self.match?.username
        }
   
        view.backgroundColor =  UISettings.shared.colorScheme.backgroundPrimary
        
        userNameLabel.textColor = UISettings.shared.colorScheme.textSecondary
        userNameLabel.textAlignment = .left
        userNameLabel.font = UIFont(name: "Avenir-Heavy", size: 22)
        
        userBio.textColor = UISettings.shared.colorScheme.textSecondary
        userBio.textAlignment = .left
        userBio.font = UIFont(name: "Avenir-Oblique", size: 16)
        
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
        
        boulderButton = TypeButton()
        boulderButton.setTitle("B", for: .normal)
        boulderButton.addBorder(color: UISettings.shared.colorScheme.textSecondary, width: 1)
        boulderButton.backgroundColor = UIColor(hex: "#0E4343")
        
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
        editButton.setTitle("Message", for: .normal)
        editButton.setTitleColor( .black, for: .normal)
        editButton.addTarget(self, action: #selector(openDM), for: UIControl.Event.touchUpInside)
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
        view.addSubview(boulderButton)
        view.addSubview(boulderGrade)
        
        
        
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
        NSLayoutConstraint(item: userBio, attribute: .centerX, relatedBy: .equal, toItem: userNameLabel, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: userBio, attribute: .trailing, relatedBy: .equal, toItem: userNameLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: userBio, attribute: .top, relatedBy: .equal, toItem: userNameLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: userBio, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        
        trGrade.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: trGrade, attribute: .centerX, relatedBy: .equal, toItem: trButton, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: trGrade, attribute: .bottom, relatedBy: .equal, toItem: profPic, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: trGrade, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: trGrade, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true
        
        tradGrade.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tradGrade, attribute: .centerX, relatedBy: .equal, toItem: tradButton, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradGrade, attribute: .bottom, relatedBy: .equal, toItem: profPic, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradGrade, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: tradGrade, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true
        
        sportGrade.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: sportGrade, attribute: .centerX, relatedBy: .equal, toItem: sportButton, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
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
        
        boulderButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: boulderButton, attribute: .leading, relatedBy: .equal, toItem: tradButton, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: boulderButton, attribute: .bottom, relatedBy: .equal, toItem: trButton, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: boulderButton, attribute: .width, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: boulderButton, attribute: .height, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        
        boulderGrade.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: boulderGrade, attribute: .centerX, relatedBy: .equal, toItem: boulderButton, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: boulderGrade, attribute: .bottom, relatedBy: .equal, toItem: profPic, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: boulderGrade, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: boulderGrade, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: editButton, attribute: .leading, relatedBy: .equal, toItem: trButton, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: editButton, attribute: .top, relatedBy: .equal, toItem: trGrade, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: editButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: editButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40).isActive = true
    }
    
}
