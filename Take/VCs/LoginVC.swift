import FirebaseAuth
import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {

    var email: String = ""
    var password: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initViews()
    }

    @objc
    private func goLogin(sender: UIButton!) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if error != nil {
                self.showAlert(title: "Oops", message: "We were unable to log you in... Please try again.")
            } else {
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

    private func initViews() {

        self.view.backgroundColor = UIColor(named: "BluePrimary")

        // login label
        let myLoginLabel = UILabel()
        myLoginLabel.text = "Login"
        myLoginLabel.textAlignment = .center
        myLoginLabel.textColor = .white
        myLoginLabel.font = UIFont(name: "Avenir-Black", size: 26)

        // email label
        let myEmailLabel = UILabel()
        myEmailLabel.text = "email"
        myEmailLabel.textAlignment = .left
        myEmailLabel.textColor = UIColor(named: "Placeholder")
        myEmailLabel.font = UIFont(name: "Avenir-Heavy", size: 20)

        // email field
        let myEmailTF = UITextField()
        myEmailTF.placeholder = "email"
        myEmailTF.textColor = .white
        myEmailTF.borderStyle = .none
        myEmailTF.keyboardType = .emailAddress
        myEmailTF.autocapitalizationType = .none
        myEmailTF.addTarget(self, action: #selector(emailFieldChanged(_:)), for: .editingChanged)
        myEmailTF.becomeFirstResponder()

        // password label
        let myPassLabel = UILabel()
        myPassLabel.text = "password"
        myPassLabel.textAlignment = .left
        myPassLabel.textColor = UIColor(named: "Placeholder")
        myPassLabel.font = UIFont(name: "Avenir-Heavy", size: 20)

        // password field
        let myPassTF = UITextField()
        myPassTF.placeholder = "email"
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

        // add to subview
        self.view.addSubview(myLoginLabel)
        self.view.addSubview(myEmailLabel)
        self.view.addSubview(myEmailTF)
        self.view.addSubview(myPassLabel)
        self.view.addSubview(myPassTF)
        self.view.addSubview(myLoginButton)

        // add constraints
        myLoginLabel.translatesAutoresizingMaskIntoConstraints = false
        let loginLabelTopConst = NSLayoutConstraint(item: myLoginLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 30)
        let loginLabelLeadingConst = NSLayoutConstraint(item: myLoginLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let loginLabelTrailingConst = NSLayoutConstraint(item: myLoginLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([loginLabelTopConst, loginLabelLeadingConst, loginLabelTrailingConst])

        myEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        let emailLabelTopConst = NSLayoutConstraint(item: myEmailLabel, attribute: .top, relatedBy: .equal, toItem: myLoginLabel, attribute: .bottom, multiplier: 1, constant: 50)
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
