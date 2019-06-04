import FirebaseAuth
import FirebaseMessaging
import UIKit

class LoginVC: UIViewController {

    var email: String = ""
    var password: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initViews()
    }

    @objc
    private func goLogin(sender: UIButton!) {
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if error != nil {
                self.showAlert(title: "Oops", message: "We were unable to log you in... Please try again.")
            } else {
                if let user = Auth.auth().currentUser {
                    Messaging.messaging().subscribe(toTopic: user.uid) { _ in
                        print("Subscribed to '\(user.uid)' topic")
                    }
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    @objc
    func emailFieldChanged(_ textField: UITextField) {
        self.email = textField.text ?? ""
    }

    @objc
    func passFieldChanged(_ textField: UITextField) {
        self.password = textField.text ?? ""
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {(_: UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc
    func openCreateAccount() {
        let create = CreateAccountVC()
        let nav = UINavigationController(rootViewController: create)
        nav.navigationBar.barTintColor =  UISettings.shared.colorScheme.backgroundPrimary
        nav.navigationBar.tintColor =  UISettings.shared.colorScheme.accent
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.titleTextAttributes = [
            .foregroundColor: UISettings.shared.colorScheme.textPrimary,
            .font: UIFont(name: "Avenir-Black", size: 26) ?? .systemFont(ofSize: 26)
        ]
        present(nav, animated: true, completion: nil)
    }

    private func initViews() {

        // bg image view
        let bgImageView = UIImageView(frame: view.frame)
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.image = UIImage(named: "bg_mountain")
        bgImageView.clipsToBounds = true

        // email label
        let myEmailLabel = LabelAvenir(size: 20, type: .Heavy, color: UIColor(named: "Placeholder"), alignment: .left)
        myEmailLabel.text = "email"

        // email field
        let myEmailTF = UITextField()
        myEmailTF.placeholder = "email"
        myEmailTF.textColor = .white
        myEmailTF.borderStyle = .none
        myEmailTF.keyboardType = .emailAddress
        myEmailTF.autocapitalizationType = .none
        myEmailTF.addTarget(self, action: #selector(emailFieldChanged(_:)), for: .editingChanged)
        //myEmailTF.becomeFirstResponder()

        // password label
        let myPassLabel = LabelAvenir(size: 20, type: .Heavy, color: UIColor(named: "Placeholder"), alignment: .left)
        myPassLabel.text = "password"

        // password field
        let myPassTF = UITextField()
        myPassTF.placeholder = "password"
        myPassTF.textColor = .white
        myPassTF.borderStyle = .none
        myPassTF.isSecureTextEntry = true
        myPassTF.autocapitalizationType = .none
        myPassTF.addTarget(self, action: #selector(passFieldChanged(_:)), for: .editingChanged)

        // login button
        let myLoginButton = UIButton()
        myLoginButton.setTitle("Login", for: .normal)
        myLoginButton.setTitleColor(UIColor(named: "PinkAccent"), for: .normal)
        myLoginButton.backgroundColor = .white
        myLoginButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 26)
        myLoginButton.layer.cornerRadius = 10
        myLoginButton.clipsToBounds = true
        myLoginButton.addTarget(self, action: #selector(goLogin), for: .touchUpInside)
        
        // login button
        let mySignUpButton = UIButton()
        mySignUpButton.setTitle("Create Account", for: .normal)
        mySignUpButton.setTitleColor(.white, for: .normal)
        mySignUpButton.backgroundColor = .clear
        mySignUpButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
        mySignUpButton.layer.cornerRadius = 10
        mySignUpButton.clipsToBounds = true
        mySignUpButton.addBorder(color: .white, width: 1.0)
        mySignUpButton.addTarget(self, action: #selector(openCreateAccount), for: .touchUpInside)
        
        var signUpLabel = UILabel()
        signUpLabel = LabelAvenir(size: 16, type: .Black, color: .white, alignment: .center)
        signUpLabel.text = "Don't have an account?"

        // add to subview
        view.addSubview(bgImageView)
        view.addSubview(myEmailLabel)
        view.addSubview(myEmailTF)
        view.addSubview(myPassLabel)
        view.addSubview(myPassTF)
        view.addSubview(myLoginButton)
        view.addSubview(signUpLabel)
        view.addSubview(mySignUpButton)

        
        mySignUpButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mySignUpButton, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mySignUpButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -15).isActive = true
        NSLayoutConstraint(item: mySignUpButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1/2, constant: 0).isActive = true
        NSLayoutConstraint(item: mySignUpButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40).isActive = true
        
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: signUpLabel, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: signUpLabel, attribute: .bottom, relatedBy: .equal, toItem: mySignUpButton, attribute: .top, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: signUpLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1/2, constant: 0).isActive = true
        NSLayoutConstraint(item: signUpLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20).isActive = true
        
        myEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        let emailLabelTopConst = NSLayoutConstraint(item: myEmailLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 100)
        let emailLabelLeadingConst = NSLayoutConstraint(item: myEmailLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20)
        let emailLabelTrailingConst = NSLayoutConstraint(item: myEmailLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20)
        NSLayoutConstraint.activate([emailLabelTopConst, emailLabelLeadingConst, emailLabelTrailingConst])

        myEmailTF.translatesAutoresizingMaskIntoConstraints = false
        let emailTFTopConst = NSLayoutConstraint(item: myEmailTF, attribute: .top, relatedBy: .equal, toItem: myEmailLabel, attribute: .bottom, multiplier: 1, constant: 10)
        let emailTFLeadingConst = NSLayoutConstraint(item: myEmailTF, attribute: .leading, relatedBy: .equal, toItem: myEmailLabel, attribute: .leading, multiplier: 1, constant: 0)
        let emailTFTrailingConst = NSLayoutConstraint(item: myEmailTF, attribute: .trailing, relatedBy: .equal, toItem: myEmailLabel, attribute: .trailing, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([emailTFTopConst, emailTFLeadingConst, emailTFTrailingConst])

        myPassLabel.translatesAutoresizingMaskIntoConstraints = false
        let passLabelTopConst = NSLayoutConstraint(item: myPassLabel, attribute: .top, relatedBy: .equal, toItem: myEmailTF, attribute: .bottom, multiplier: 1, constant: 20)
        let passLabelLeadingConst = NSLayoutConstraint(item: myPassLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20)
        let passLabelTrailingConst = NSLayoutConstraint(item: myPassLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20)
        NSLayoutConstraint.activate([passLabelTopConst, passLabelLeadingConst, passLabelTrailingConst])

        myPassTF.translatesAutoresizingMaskIntoConstraints = false
        let passTFTopConst = NSLayoutConstraint(item: myPassTF, attribute: .top, relatedBy: .equal, toItem: myPassLabel, attribute: .bottom, multiplier: 1, constant: 10)
        let passTFLeadingConst = NSLayoutConstraint(item: myPassTF, attribute: .leading, relatedBy: .equal, toItem: myPassLabel, attribute: .leading, multiplier: 1, constant: 0)
        let passTFTrailingConst = NSLayoutConstraint(item: myPassTF, attribute: .trailing, relatedBy: .equal, toItem: myPassLabel, attribute: .trailing, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([passTFTopConst, passTFLeadingConst, passTFTrailingConst])

        myLoginButton.translatesAutoresizingMaskIntoConstraints = false
        let loginButtonTopConst = NSLayoutConstraint(item: myLoginButton, attribute: .top, relatedBy: .equal, toItem: myPassTF, attribute: .bottom, multiplier: 1, constant: 40)
        let loginButtonLeadingConst = NSLayoutConstraint(item: myLoginButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 50)
        let loginButtonTrailingConst = NSLayoutConstraint(item: myLoginButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -50)
        NSLayoutConstraint.activate([loginButtonTopConst, loginButtonLeadingConst, loginButtonTrailingConst])
    }

}
