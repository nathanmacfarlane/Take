import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import UIKit

class MsgLogVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var dmViewModel: DmViewModel!
    var dm: DM?
    var user: User?
    var friend: User?
    private let cellId = "cellId"
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.placeholder = "Enter message..."
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(MsgCell.self, forCellWithReuseIdentifier: cellId)
        initViews()
    }
    
    
    @objc
    func backToProf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func handleSend() {
        guard let msg = self.inputTextField.text, let id = self.user?.id else { return }
        let tc = ThreadContent(message: msg, sender: id)
        
        self.dm?.Thread.append(tc) // should not have the ! but i am lazy
        Firestore.firestore().save(object: self.dm, to: "messages", with: self.dm?.messageId ?? "lol sheeit", completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dm?.Thread.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell: DmTVC = self.dmTableView.dequeueReusableCell(withIdentifier: "DmCellTV") as? DmTVC else { print("yooooooo"); return DmTVC() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MsgCell else { return MsgCell() }
        cell.message.text = dm?.Thread[indexPath.row].message
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 50)
    }
    
    func initViews() {
        let backButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backToProf))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = self.friend?.username
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor(named: "BluePrimaryDark")
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send It", for: .normal)
        sendButton.setTitleColor(UIColor(named: "PinkAccent"), for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        view.addSubview(containerView)
        view.addSubview(sendButton)
        view.addSubview(inputTextField)
        
        // x, y, w, h
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

extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}

class MsgCell: UICollectionViewCell {
    var message = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.backgroundColor = UIColor(named: "BluePrimary")
        
        
        message.text = "hey man lets go climbing"
        message.textColor = .white
        message.font = UIFont(name: "Avenir", size: 18)
        
        addSubview(message)
//
        message.translatesAutoresizingMaskIntoConstraints = false
        let messageWidthConst = NSLayoutConstraint(item: message, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 3, constant: 0)
        let messageCenterXConst = NSLayoutConstraint(item: message, attribute: .left, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: -20)
        let messageCenterYConst = NSLayoutConstraint(item: message, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([messageWidthConst, messageCenterXConst, messageCenterYConst])
    }
    
}

