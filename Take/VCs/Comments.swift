//
//  Comments.swift
//  Take
//
//  Created by Family on 5/7/18.
//  Copyright © 2018 N8. All rights reserved.
//

import CodableFirebase
import FirebaseAuth
import FirebaseFirestore
import UIKit

class Comments: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    // MARK: - IBOulets
    @IBOutlet private weak var myTableView: UITableView!
    @IBOutlet private weak var userCommentView: UIView!
    @IBOutlet private weak var userCommentNameLabel: UILabel!
    @IBOutlet private weak var userCommentImageView: UIImageView!
    @IBOutlet private weak var userCommentDatelabel: UILabel!
    @IBOutlet private weak var userCommentPostButton: UIButton!
    @IBOutlet private weak var userCommentField: UITextView!

    // MARK: - Variables
    var theRoute: Route!
    let dateFormatterPrint: DateFormatter = DateFormatter()
    let forFsSave: DateFormatter = DateFormatter()
    var userId: String = ""
    var comments: [Comment] = []

    // MARK: - View load/unlaod
    override func viewDidLoad() {
        super.viewDidLoad()

        userCommentField.text = "Placeholder"
        userCommentField.textColor = UIColor.lightGray
        userCommentField.becomeFirstResponder()
        userCommentField.selectedTextRange = userCommentField.textRange(from: userCommentField.beginningOfDocument, to: userCommentField.beginningOfDocument)
        userCommentField.resignFirstResponder()

        theRoute.getComments { comments in
            self.comments = comments.sorted { $0.date > $1.date }
            self.myTableView.reloadData()
        }

        if let userId = Auth.auth().currentUser?.uid {
            self.userId = userId
            Firestore.firestore().getUser(id: userId) { user in
                DispatchQueue.main.async {
                    self.userCommentNameLabel.text = user.name
                }
                user.getProfilePhoto { image in
                    DispatchQueue.main.async {
                        self.userCommentImageView.image = image
                    }
                }
            }
        }

        forFsSave.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatterPrint.dateFormat = "M/dd/yy"
        self.userCommentDatelabel.text = dateFormatterPrint.string(from: Date())
        self.userCommentImageView.roundImage(portion: 2)
        self.userCommentImageView.addBorder(color: .white, width: 2)
        self.userCommentView.roundView(portion: 10)
        self.userCommentField.roundField(portion: 10)
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CommentCell else { return UITableViewCell() }
        cell.backgroundColor = UIColor.clear
        cell.setNameLabel(with: "")
        let db = Firestore.firestore()
        db.getUser(id: self.comments[indexPath.row].userId) { user in
            cell.setNameLabel(with: user.name)
            user.getProfilePhoto { profileImage in
                DispatchQueue.main.async {
                    cell.setUserImage(with: profileImage)
                }
            }
        }
        cell.setCommentLabel(with: self.comments[indexPath.row].text)
        cell.setDateLabel(with: dateFormatterPrint.string(from: self.comments[indexPath.row].date))
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.comments[indexPath.row].userId == self.userId {
            return true
        }
        return false
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        comments[indexPath.row].delete(route: theRoute)
        comments.remove(at: indexPath.row)
        self.myTableView.deleteRows(at: [indexPath], with: .fade)
    }

    // MARK: - IBActions
    @IBAction private func goPostComment(_ sender: Any) {
        guard let commentText = self.userCommentField.text else { return }
        let commentId = UUID().uuidString
        let newComment = Comment(id: commentId, userId: self.userId, text: commentText, dateString: forFsSave.string(from: Date()))
        self.userCommentField.resignFirstResponder()
        self.userCommentField.text = ""
        self.comments.insert(newComment, at: 0)
        self.myTableView.reloadData()
        //save to db
        self.theRoute.commentIds.append(commentId)
        guard let data = try! FirebaseEncoder().encode(newComment) as? [String: Any] else { return }
        DispatchQueue.global(qos: .background).async {
            Firestore.firestore().collection("comments").document(commentId).setData(data)
            self.theRoute.fsSave()
        }
    }

    // MARK: - UITextView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        if updatedText.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        } else {
            return true
        }
        return false
    }
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }

    // MARK: - Navigation
    @IBAction private func hitBackButton(_ sender: Any) {

        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        guard let theWindow = self.view.window else { return }
        theWindow.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)

    }

}
