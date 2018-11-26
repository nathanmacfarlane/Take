//
//  Login.swift
//  Take
//
//  Created by Family on 5/28/18.
//  Copyright © 2018 N8. All rights reserved.
//

import FirebaseAuth
import UIKit

class Login: UIViewController, UITextFieldDelegate {

    // MARK: - IBOutlets
    @IBOutlet private weak var loginWithGoogleButton: UIButton!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var loginUsernameButton: UIButton!
    @IBOutlet private weak var accountTypeLabel: UILabel!

    // MARK: - Variables

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loginWithGoogleButton.roundView(portion: 4)
        self.loginUsernameButton.roundView(portion: 4)

    }

    // MARK: - TextField Functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            self.passwordField.becomeFirstResponder()
        } else {
            print("should resign")
            textField.resignFirstResponder()
        }
        return true
    }

    // MARK: - Other Functions
    @IBAction private func changeType(_ sender: UIButton) {
        if sender.titleLabel?.text == "Sign Up" {
            sender.setTitle("Login", for: .normal)
            self.typeLabel.text = "Sign Up"
            self.loginUsernameButton.setTitle("Sign Up", for: .normal)
            self.accountTypeLabel.text = "Need an Account?"
        } else {
            sender.setTitle("Sign Up", for: .normal)
            self.typeLabel.text = "Login"
            self.loginUsernameButton.setTitle("Login", for: .normal)
            self.accountTypeLabel.text = "Have an Account?"
        }
    }
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) {(_: UIAlertAction) -> Void in
            print("OK")
        }

        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Navigation
    @IBAction private func goLoginSignUp(_ sender: UIButton) {

        if let email = emailField.text, let password = passwordField.text {
            if sender.titleLabel?.text == "Login" {
                goLogin(email: email, password: password)
            } else {
                goSignUp(email: email, password: password)
            }
        } else {
            self.showAlert(title: "Oh No", message: "You must enter a valid email and password to login")
        }
    }
    func goSignUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if error != nil {
                self.showAlert(title: "Oops", message: "We were unable to create a new account for you... Error: '\(String(describing: error))'")
                self.passwordField.text = ""
                self.emailField.text = ""
                self.emailField.becomeFirstResponder()
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    func goLogin(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if error != nil {
                self.showAlert(title: "Oops", message: "We were unable to log you in... Please try again.")
                self.passwordField.text = ""
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
