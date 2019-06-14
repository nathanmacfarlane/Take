import Firebase
import FirebaseAuth
import Foundation
import Presentr
import UIKit
class MatchProfVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    var userNameLabel = UILabel()
    var userBio = UILabel()
    var tradGrade = UILabel()
    var trGrade = UILabel()
    var sportGrade = UILabel()
    var boulderGrade = UILabel()
    var flag = false
    
    var tradLetter = ""
    var trLetter = ""
    var sportLetter = ""
  
    var infoTableView: UITableView!
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
            .foregroundColor: UISettings.shared.colorScheme.textPrimary,
            .font: UIFont(name: "Avenir-Black", size: 26) ?? .systemFont(ofSize: 26)
        ]
        self.present(nav, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: InfoCell = self.infoTableView.dequeueReusableCell(withIdentifier: "InfoCell") as? InfoCell else { print("yooooooo"); return InfoCell() }
//        guard let match = self.match else { return cell}
        cell.infoLabel.text = self.match?.info[indexPath.row]
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.infoLabel.isUserInteractionEnabled = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.match!.info.count
    }
    
    @objc func backToMatches() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func initViews() {
        let backButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backToMatches))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.tintColor = UISettings.shared.colorScheme.accent
        self.navigationItem.title = self.match?.username
        
        self.infoTableView = UITableView()
        infoTableView.register(InfoCell.self, forCellReuseIdentifier: "InfoCell")
        infoTableView.dataSource = self
        infoTableView.delegate = self
        infoTableView.separatorStyle = .none
        infoTableView.backgroundColor = UISettings.shared.colorScheme.backgroundPrimary
        infoTableView.isHidden = false

        if presented {
            let backButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backToMatches))
            self.navigationItem.leftBarButtonItem = backButton
            self.navigationItem.leftBarButtonItem?.tintColor = UISettings.shared.colorScheme.accent
            self.navigationItem.title = self.match?.username
        }
   
        view.backgroundColor =  UISettings.shared.colorScheme.backgroundPrimary
        
        userNameLabel = LabelAvenir(size: 22, type: .Heavy, color: UISettings.shared.colorScheme.textSecondary, alignment: .left)
        
        userBio = LabelAvenir(size: 16, type: .Medium, color: UISettings.shared.colorScheme.textSecondary, alignment: .left)
        userBio.numberOfLines = 0
        userBio.lineBreakMode = .byWordWrapping
        userBio.layer.masksToBounds = true
        
        // type buttons
        sportButton = TypeButton()
        sportButton.setTitle("S", for: .normal)
        sportButton.addBorder(color: UISettings.shared.colorScheme.outlineButton, width: 1)
        sportButton.backgroundColor = UISettings.shared.colorScheme.gradeBubble
        sportButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        
        boulderButton = TypeButton()
        boulderButton.setTitle("B", for: .normal)
        boulderButton.addBorder(color: UISettings.shared.colorScheme.outlineButton, width: 1)
        boulderButton.backgroundColor = UISettings.shared.colorScheme.gradeBubble
        boulderButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        
        trButton = TypeButton()
        trButton.setTitle("TR", for: .normal)
        trButton.addBorder(color: UISettings.shared.colorScheme.outlineButton, width: 1)
        trButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        trButton.backgroundColor = UISettings.shared.colorScheme.gradeBubble
        
        tradButton = TypeButton()
        tradButton.setTitle("T", for: .normal)
        tradButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        tradButton.addBorder(color: UISettings.shared.colorScheme.outlineButton, width: 1)
        tradButton.backgroundColor = UISettings.shared.colorScheme.gradeBubble
        
        profPic = TypeButton()
        profPic.addBorder(color: UISettings.shared.colorScheme.outlineButton, width: 2.5)
        profPic.clipsToBounds = true
        profPic.layer.cornerRadius = 8
        profPic.contentMode = .scaleAspectFit
        
        tradGrade = LabelAvenir(size: 16, type: .Book, color: UISettings.shared.colorScheme.textSecondary, alignment: .center)
        
        trGrade = LabelAvenir(size: 16, type: .Book, color: UISettings.shared.colorScheme.textSecondary, alignment: .center)
        
        sportGrade = LabelAvenir(size: 16, type: .Book, color: UISettings.shared.colorScheme.textSecondary, alignment: .center)
        
        boulderGrade = LabelAvenir(size: 16, type: .Book, color: UISettings.shared.colorScheme.textSecondary, alignment: .center)
        
        editButton = UIButton()
        editButton.setTitle("Message", for: .normal)
        editButton.setTitleColor( .black, for: .normal)
        editButton.addTarget(self, action: #selector(openDM), for: UIControl.Event.touchUpInside)
        editButton.backgroundColor = UISettings.shared.colorScheme.segmentColor
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
        view.addSubview(infoTableView)
        
        
        infoTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: infoTableView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: infoTableView, attribute: .top, relatedBy: .equal, toItem: editButton, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
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
