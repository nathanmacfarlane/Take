import UIKit
import CodableFirebase
import Firebase
import FirebaseAuth
import FirebaseFirestore

class MsgLogContainerVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var dmViewModel: DmViewModel!
    var dm: DM?
    var user: User?
    var friend: User?
    var cellId = "cellId"
    var msgTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.friend?.username
        Firestore.firestore().collection("messages").document(self.dm?.messageId ?? "")
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                let decoder = FirebaseDecoder()
                guard let result = try? decoder.decode(DM.self, from: data as Any) else { return }
                self.dm?.Thread = result.Thread
                DispatchQueue.main.async {
                    self.msgTableView.reloadData()
                    let indexPath = IndexPath(row: self.dm!.Thread.count - 1, section: 0)
                    self.msgTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        initViews()
        }
    
    let inputTextField: FlexibleTextView = {
        let textField = FlexibleTextView()
        textField.textColor = .white
        textField.maxHeight = 75
        textField.textColor = .white
        textField.font = UIFont(name: "Avenir", size: 18)
        textField.backgroundColor = UIColor(named: "BluePrimaryDark")
        textField.placeholder = "enter text here yo.... lol sheeit"
        return textField
    }()

    @objc
    func handleSend() {
        guard let msg = self.inputTextField.text, let id = self.user?.id else { return }
        let tc = ThreadContent(message: msg, sender: id)
        self.dm?.Thread.append(tc)
        Firestore.firestore().save(object: self.dm, to: "messages", with: self.dm?.messageId ?? "lol sheeit", completion: nil)
        self.inputTextField.text = ""
    }
    
    @objc
    func backToProf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("uitableview automatic...")
        print(UITableView.automaticDimension)
        return 100
    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dm?.Thread.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MsgCell = self.msgTableView.dequeueReusableCell(withIdentifier: "MsgCell") as? MsgCell else { return MsgCell() }
        cell.message.text = dm?.Thread[indexPath.row].message
//        cell.textViewDidChange(cell.message)
        
        if dm?.Thread[indexPath.row].sender == self.user?.id {
            guard let user = self.user else { return cell}
            let userViewModel = UserViewModel(user: user)
            userViewModel.getProfilePhoto { image in
                DispatchQueue.main.async {
                cell.profPic.setBackgroundImage(image, for: .normal)
                }
            }
        } else {
            guard let friend = self.friend else { return cell}
            let userViewModel = UserViewModel(user: friend)
            userViewModel.getProfilePhoto { image in
                DispatchQueue.main.async {
                    cell.profPic.setBackgroundImage(image, for: .normal)
                }
            }
        }
        
        
        return cell
    }
    
    func initViews() {
        view.backgroundColor = .black
        
        self.msgTableView = UITableView()
        self.msgTableView.backgroundColor = .clear
        msgTableView.register(MsgCell.self, forCellReuseIdentifier: "MsgCell")
        msgTableView.dataSource = self
        msgTableView.delegate = self
        msgTableView.rowHeight = UITableView.automaticDimension
        msgTableView.estimatedRowHeight = 100
        msgTableView.allowsSelection = false
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor(named: "BluePrimaryDark")
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send It", for: .normal)
        sendButton.setTitleColor(UIColor(named: "PinkAccent"), for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
    
        let backButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backToProf))
        self.navigationItem.leftBarButtonItem = backButton
        
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
        sendButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 100).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: 10).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
    }
    
}

class MsgCell: UITableViewCell {
    
    let message = UILabel()
    var profPic: TypeButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.layer.masksToBounds = true
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.backgroundColor = .black
        
        message.textColor = .white
        message.backgroundColor = .clear
        message.font = UIFont(name: "Avenir", size: 16)
        message.lineBreakMode = .byWordWrapping
        message.numberOfLines = 0
        message.layer.masksToBounds = true
        
        profPic = TypeButton()
        profPic.addBorder(width: 1)
        profPic.layer.cornerRadius = 8
        profPic.clipsToBounds = true
        profPic.contentMode = .scaleAspectFit
        
        self.addSubview(profPic)
        addSubview(message)
        
        profPic.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: profPic, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: profPic, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: profPic, attribute: .width, relatedBy: .equal, toItem: profPic, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: profPic, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1 / 2, constant: 0).isActive = true
        
        message.translatesAutoresizingMaskIntoConstraints = false
        message.leadingAnchor.constraint(equalTo: profPic.trailingAnchor, constant: 10).isActive = true
        message.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        message.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        message.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
}

//extension MsgCell: UITextViewDelegate {
//
//    func textViewDidChange(_ textView: UITextView) {
//        let size = CGSize(width: 200, height: 10000)
//        let estimatedSize = textView.sizeThatFits(size)
//        print("here here here")
//        textView.constraints.forEach { (constraint) in
//            if constraint.firstAttribute == .height {
//                constraint.constant = estimatedSize.height
//                print(estimatedSize.height)
//                print("nfidjnvodnvokdfsnokvndknvkdnx")
//            }
//
//        }
//    }
//}
