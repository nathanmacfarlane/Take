import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import UIKit

class MsgLogContainerVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var dmViewModel: DmViewModel!
    var dm: DM?
    var user: User?
    var friend: User?
    var cellId = "cellId"
    var msgTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Firestore.firestore().collection("messages").document(self.dm?.messageId ?? "").addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(String(describing: error))")
                    return
                }
                if document.data() == nil {
                    print("Document data was empty.")
                    return
                }
                DispatchQueue.main.async {
                    self.msgTableView.reloadData()
                    guard let dm = self.dm else { return }
                    let indexPath = IndexPath(row: dm.Thread.count - 1, section: 0)
                    self.msgTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
        }
        initViews()
    }
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: "Enter message... keep it short", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        return textField
    }()

    @objc
    func handleSend() {
        guard let msg = self.inputTextField.text, let id = self.user?.id else { return }
        let tc = ThreadContent(message: msg, sender: id)
        
        self.dm?.Thread.append(tc) // should not have the ! but i am lazy
        Firestore.firestore().save(object: self.dm, to: "messages", with: self.dm?.messageId ?? "lol sheeit", completion: nil)
        if let user = self.user, let friend = self.friend, let dm = self.dm {
            let noti = NotificationMessage(fromUser: user, toUser: friend.id, message: tc.message, messagesId: dm.messageId)
            Firestore.firestore().save(object: noti, to: "notifications", with: "\(dm.messageId)-\(dm.Thread.count)", completion: nil)
        }

        self.inputTextField.text = ""
    }
    
    @objc
    func backToProf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    } 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dm?.Thread.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MsgCell = self.msgTableView.dequeueReusableCell(withIdentifier: "MsgCell") as? MsgCell else { return MsgCell() }
        cell.message.text = dm?.Thread[indexPath.row].message
        
        // using this if statement to avoid an extra query for the sender's username
        // ok for now cuz dms are only between 2 people
        if dm?.Thread[indexPath.row].sender == self.user?.id {
            cell.senderLabel.text = ""
        } else {
            cell.senderLabel.text = self.friend?.username
        }
        return cell
    }
    
    func initViews() {
        
        self.msgTableView = UITableView()
        self.msgTableView.backgroundColor = .clear
        msgTableView.register(MsgCell.self, forCellReuseIdentifier: "MsgCell")
        msgTableView.dataSource = self
        msgTableView.delegate = self
        msgTableView.separatorStyle = .none
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor(named: "BluePrimaryDark")
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send It", for: .normal)
        sendButton.setTitleColor(UIColor(named: "PinkAccent"), for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
    
        let backButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backToProf))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = self.friend?.username
        
        view.addSubview(containerView)
        view.addSubview(sendButton)
        view.addSubview(inputTextField)
        view.addSubview(self.msgTableView)
        
        // x, y, w, h
        msgTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: msgTableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: msgTableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: msgTableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: msgTableView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.widthAnchor.constraint(equalToConstant: 340).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
    }
    
}

class MsgCell: UITableViewCell {
    
    var message = UITextField()
    var senderLabel = UILabel()
    let container = UIView()
    var indent = CGFloat(100)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        self.backgroundColor = .clear
        
        message.textColor = .white
        message.font = UIFont(name: "Avenir", size: 18)
        
        senderLabel.textColor = .white
        senderLabel.font = UIFont(name: "Avenir", size: 18)
        senderLabel.text = "rockinator"
        
        container.backgroundColor = UIColor(named: "BluePrimary")
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 8
    
        addSubview(container)
        addSubview(message)
        addSubview(senderLabel)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 9 / 10).isActive = true
        container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 2 / 3).isActive = true
        
        message.translatesAutoresizingMaskIntoConstraints = false
        let messageWidthConst = NSLayoutConstraint(item: message, attribute: .width, relatedBy: .equal, toItem: container, attribute: .width, multiplier: 3, constant: 0)
        let messageCenterXConst = NSLayoutConstraint(item: message, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1, constant: 20)
        let messageCenterYConst = NSLayoutConstraint(item: message, attribute: .centerY, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([messageWidthConst, messageCenterXConst, messageCenterYConst])
        
        senderLabel.translatesAutoresizingMaskIntoConstraints = false
        senderLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 0).isActive = true
        senderLabel.bottomAnchor.constraint(equalTo: container.topAnchor).isActive = true
        senderLabel.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 1).isActive = true
        senderLabel.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 1 / 3).isActive = true
    }
    
}
