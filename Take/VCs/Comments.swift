//
//  Comments.swift
//  Take
//
//  Created by Family on 5/7/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit

class Comments: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - IBOulets
    @IBOutlet private weak var searchBG: UIView!
    @IBOutlet private weak var myTableView: UITableView!
    @IBOutlet private weak var freqWordsLabel: UILabel!
    @IBOutlet private weak var userCommentView: UIView!
    @IBOutlet private weak var userCommentNameLabel: UILabel!
    @IBOutlet private weak var userCommentImageView: UIImageView!
    @IBOutlet private weak var userCommentDatelabel: UILabel!
    @IBOutlet private weak var userCommentPostButton: UIButton!
    @IBOutlet private weak var userCommentField: UITextView!

    // MARK: - Variables
    var theRoute: Route!
    let dateFormatterPrint: DateFormatter = DateFormatter()
    var id: String = "IDdbKJxtW9gGxaxHncMaJzTIb9j2"

    // MARK: - View load/unlaod
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatterPrint.dateFormat = "M.dd.yy"
        let topWords = self.mostFreqWords()
        self.searchBG.roundView(portion: 10)
        self.freqWordsLabel.text = topWords.joined(separator: ", ")
        self.userCommentDatelabel.text = dateFormatterPrint.string(from: Date())
        self.userCommentImageView.roundImage(portion: 2)
        self.userCommentImageView.addBorder(color: .white, width: 2)
        self.userCommentView.roundView(portion: 10)
        self.userCommentField.roundField(portion: 10)
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theRoute.comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CommentCell else { return UITableViewCell() }

        let topWords = mostFreqWords()
        let comment = self.theRoute.comments[indexPath.row]
        for topW in topWords {
            if comment.text.contains(topW) {
                //print("cell at index: \(indexPath.row) contains: \(topW)")
            }
        }

        cell.backgroundColor = UIColor.clear
        cell.setNameLabel(with: theRoute.comments[indexPath.row].id)
        cell.setCommentLabel(with: theRoute.comments[indexPath.row].text)
        cell.setDateLabel(with: dateFormatterPrint.string(from: theRoute.comments[indexPath.row].date))
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.theRoute.comments[indexPath.row].id == self.id {
            return true
        }
        return false
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        self.theRoute.comments.remove(at: indexPath.row)
        self.myTableView.deleteRows(at: [indexPath], with: .fade)
    }

    // MARK: - IBActions
    @IBAction private func goPostComment(_ sender: Any) {
        guard let commentText = self.userCommentField.text else { return }
        let newComment = Comment(id: self.id, text: commentText, date: Date())
        self.userCommentField.resignFirstResponder()
        self.userCommentField.text = ""
        self.theRoute.comments.insert(newComment, at: 0)
        self.myTableView.reloadData()
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

    // MARK: - other functions
    func mostFreqWords() -> [String] {
        var topWords: [String] = []
        var allWords: String = ""
        for comment in self.theRoute.comments {
            allWords.append(" \(comment.text)")
        }

        let wordsArr = allWords.components(separatedBy: " ")
        var counts: [String: Int] = [:]

        for item in wordsArr where item.count >= 5 {
            counts[item] = (counts[item] ?? 0) + 1
        }

        for _ in 1...3 {
            var maxKey = ""
            var maxCount = 0
            for (key, value) in counts where value > maxCount {
                maxKey = key
                maxCount = value
            }

            if !maxKey.isEmpty {
                topWords.append(maxKey)
                counts.removeValue(forKey: maxKey)
            }
        }

        return topWords
    }

}
