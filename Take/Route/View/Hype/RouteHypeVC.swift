import FirebaseFirestore
import UIKit

class RouteHypeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // injections
    var routeViewModel: RouteViewModel!
    // variables
    var comments: [Comment] = []
    // ui
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initViews()

        Firestore.firestore().query(collection: "comments", by: "routeId", with: routeViewModel.id, of: Comment.self) { comments in
            self.comments = comments
            self.tableView.reloadData()
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HypeCommentTVC") as? HypeCommentTVC ?? HypeCommentTVC()
        cell.selectionStyle = .none
        let commentViewModel = CommentViewModel(comment: comments[indexPath.row])
        commentViewModel.getUsername { username in
            cell.nameLabel.text = username
        }
        commentViewModel.getImage { image in
            cell.commentImageView.image = image
        }
        cell.dateLabel.text = commentViewModel.dateString
        cell.eventLabel.text = commentViewModel.imageUrl != nil ? "Added a new photo" : "Added a new comment"
        cell.commentLabel.text = commentViewModel.message
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func initViews() {
        self.view.backgroundColor = UIColor(named: "BluePrimaryDark")

        tableView = UITableView()
        tableView.register(HypeCommentTVC.self, forCellReuseIdentifier: "HypeCommentTVC")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 65).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }

}
