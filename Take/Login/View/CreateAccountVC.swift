import FirebaseAuth
import Firebase
import FirebaseMessaging
import UIKit

class CreateAccountVC: UIViewController {
    
    var email: String = ""
    var password: String = ""
    var name: String = ""
    var username: String = ""
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UISettings.shared.colorScheme.backgroundPrimary
        
        self.initViews()
    }
    
    @objc
    func backToLogin() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func emailFieldChanged(_ textField: UITextField) {
        self.email = textField.text ?? ""
    }
    
    @objc
    func passFieldChanged(_ textField: UITextField) {
        self.password = textField.text ?? ""
    }
    @objc
    func usernameFieldChanged(_ textField: UITextField) {
        self.username = textField.text ?? ""
    }
    @objc
    func nameFieldChanged(_ textField: UITextField) {
        self.name = textField.text ?? ""
    }
    
    @objc
    func createUser() {
        print(self.username)
        print(self.password)
        print(self.email)
        print(self.name)
        
            // [START create_user]
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                // [START_EXCLUDE]
                guard let user = authResult?.user, error == nil else {
                    self.showAlert(title: "Whipper!", message: "Something went wrong when creating your account...")
                    return
                }
                self.backToLogin()
                self.user = User(id: user.uid, name: self.name, username: self.username)
                Firestore.firestore().save(object: self.user, to: "users", with: self.user?.id ?? "error in creating new user", completion: nil)
                
                // [END_EXCLUDE]
            }
            // [END create_user
        
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {(_: UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func initViews() {
        
        let backButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backToLogin))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "Create Account"
        
        let myPassLabel = LabelAvenir(size: 20, type: .Heavy, color: UISettings.shared.colorScheme.textSecondary, alignment: .left)
        myPassLabel.text = "Password"
        
        // password field
        let myPassTF = UITextField()
        myPassTF.placeholder = "password"
        myPassTF.textColor = UISettings.shared.colorScheme.textPrimary
        myPassTF.borderStyle = .roundedRect
        myPassTF.backgroundColor = UISettings.shared.colorScheme.backgroundCell
        myPassTF.isSecureTextEntry = true
        myPassTF.autocapitalizationType = .none
        myPassTF.addTarget(self, action: #selector(passFieldChanged(_:)), for: .editingChanged)
        
        // email label
        let myEmailLabel = LabelAvenir(size: 20, type: .Heavy, color: UISettings.shared.colorScheme.textSecondary, alignment: .left)
        myEmailLabel.text = "Email"
        
        // email field
        let myEmailTF = UITextField()
        myEmailTF.placeholder = "email"
        myEmailTF.textColor = UISettings.shared.colorScheme.textPrimary
        myEmailTF.borderStyle = .roundedRect
        myEmailTF.backgroundColor = UISettings.shared.colorScheme.backgroundCell
        myEmailTF.keyboardType = .emailAddress
        myEmailTF.autocapitalizationType = .none
        myEmailTF.addTarget(self, action: #selector(emailFieldChanged(_:)), for: .editingChanged)
        
        let myNameLabel = LabelAvenir(size: 20, type: .Heavy, color: UISettings.shared.colorScheme.textSecondary, alignment: .left)
        myNameLabel.text = "Name"
        
        let myUsernameLabel = LabelAvenir(size: 20, type: .Heavy, color: UISettings.shared.colorScheme.textSecondary, alignment: .left)
        myUsernameLabel.text = "Username"
        
        // email field
        let myNameTF = UITextField()
        myNameTF.placeholder = "name"
        myNameTF.textColor = UISettings.shared.colorScheme.textPrimary
        myNameTF.borderStyle = .roundedRect
        myNameTF.backgroundColor = UISettings.shared.colorScheme.backgroundCell
        myNameTF.autocapitalizationType = .none
        myNameTF.addTarget(self, action: #selector(nameFieldChanged(_:)), for: .editingChanged)
        
        let myUsernameTF = UITextField()
        myUsernameTF.placeholder = "username"
        myUsernameTF.textColor = UISettings.shared.colorScheme.textPrimary
        myUsernameTF.borderStyle = .roundedRect
        myUsernameTF.backgroundColor = UISettings.shared.colorScheme.backgroundCell
        myUsernameTF.autocapitalizationType = .none
        myUsernameTF.addTarget(self, action: #selector(usernameFieldChanged(_:)), for: .editingChanged)
        
        let sendButton = UIButton()
        sendButton.setTitle("Send It!", for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.backgroundColor = UIColor(named: "PinkAccent")
        sendButton.layer.cornerRadius = 8
        sendButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 20)
        sendButton.addTarget(self, action: #selector(createUser), for: UIControl.Event.touchUpInside)
        
        view.addSubview(myEmailLabel)
        view.addSubview(myEmailTF)
        view.addSubview(myPassLabel)
        view.addSubview(myPassTF)
        view.addSubview(myNameLabel)
        view.addSubview(myNameTF)
        view.addSubview(myUsernameLabel)
        view.addSubview(myUsernameTF)
        view.addSubview(sendButton)
        
        myEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: myEmailLabel, attribute: .leading, relatedBy: .equal, toItem: myEmailTF, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: myEmailLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: myEmailLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        NSLayoutConstraint(item: myEmailLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20).isActive = true
        
        myEmailTF.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: myEmailTF, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: myEmailTF, attribute: .top, relatedBy: .equal, toItem: myEmailLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: myEmailTF, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 5/6, constant: 0).isActive = true
        NSLayoutConstraint(item: myEmailTF, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50).isActive = true
        
        myPassLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: myPassLabel, attribute: .leading , relatedBy: .equal, toItem: myEmailLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: myPassLabel, attribute: .top, relatedBy: .equal, toItem: myEmailTF, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: myPassLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        NSLayoutConstraint(item: myPassLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20).isActive = true
        
        myPassTF.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: myPassTF, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: myPassTF, attribute: .top, relatedBy: .equal, toItem: myPassLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: myPassTF, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 5/6, constant: 0).isActive = true
        NSLayoutConstraint(item: myPassTF, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50).isActive = true
        
        myNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: myNameLabel, attribute: .leading , relatedBy: .equal, toItem: myEmailLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: myNameLabel, attribute: .top, relatedBy: .equal, toItem: myPassTF, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: myNameLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        NSLayoutConstraint(item: myNameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20).isActive = true
        
        myNameTF.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: myNameTF, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: myNameTF, attribute: .top, relatedBy: .equal, toItem: myNameLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: myNameTF, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 5/6, constant: 0).isActive = true
        NSLayoutConstraint(item: myNameTF, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50).isActive = true
        
        myUsernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: myUsernameLabel, attribute: .leading , relatedBy: .equal, toItem: myEmailLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: myUsernameLabel, attribute: .top, relatedBy: .equal, toItem: myNameTF, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: myUsernameLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        NSLayoutConstraint(item: myUsernameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20).isActive = true
        
        myUsernameTF.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: myUsernameTF, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: myUsernameTF, attribute: .top, relatedBy: .equal, toItem: myUsernameLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: myUsernameTF, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 5/6, constant: 0).isActive = true
        NSLayoutConstraint(item: myUsernameTF, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50).isActive = true
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: sendButton, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sendButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -15).isActive = true
        NSLayoutConstraint(item: sendButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/5, constant: 0).isActive = true
        NSLayoutConstraint(item: sendButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50).isActive = true
    }

}
