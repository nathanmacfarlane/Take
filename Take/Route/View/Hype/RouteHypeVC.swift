import FirebaseFirestore
import UIKit

class RouteHypeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // injections
    var routeViewModel: RouteViewModel!
    // ui
    var tableView: UITableView!

    var hypeData: [HypeType] = []
    // sorted version of hypeData for the table view
    var tableData: [HypeType] {
        return hypeData.sorted { Double($0.dateString) ?? 0.0 > Double($1.dateString) ?? 0.0 }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        hypeData = []

        Firestore.firestore().query(collection: "comments", by: "routeId", with: routeViewModel.id, of: Comment.self) { comments in
            self.hypeData.append(contentsOf: comments)
            self.tableView.reloadData()
        }

        hypeData.append(contentsOf: routeViewModel.starsArray)
        self.tableView.reloadData()

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let hypeType = tableData[indexPath.row]

        if let comment = hypeType as? Comment, let cell = tableView.dequeueReusableCell(withIdentifier: "HypeCommentTVC") as? HypeCommentTVC {
            cell.selectionStyle = .none
            let commentViewModel = CommentViewModel(comment: comment)
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
        } else if let star = hypeType as? Star, let cell = tableView.dequeueReusableCell(withIdentifier: "HypeStarTVC") as? HypeStarTVC {
            cell.selectionStyle = .none
            let starViewModel = StarViewModel(star: star)
            starViewModel.getUsername { username in
                cell.nameLabel.text = username
            }
            cell.cosmos.rating = starViewModel.value
            cell.dateLabel.text = starViewModel.dateString
            cell.eventLabel.text = "Added a new Rating"
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let hypeType = tableData[indexPath.row]
        if hypeType as? Comment != nil {
            return 200
        } else if hypeType as? Star != nil {
            return 125
        }
        return 75
    }

    func initViews() {
        self.view.backgroundColor = UIColor(named: "BluePrimaryDark")

        tableView = UITableView()
        tableView.register(HypeCommentTVC.self, forCellReuseIdentifier: "HypeCommentTVC")
        tableView.register(HypeStarTVC.self, forCellReuseIdentifier: "HypeStarTVC")
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
