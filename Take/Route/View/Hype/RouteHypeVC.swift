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

        for star in routeViewModel.starsArray {
            let index = self.getIndex(ht: star)
            self.hypeData.append(star)
            self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .middle)
        }

        FirestoreService.shared.fs.listen(collection: "comments", by: "routeId", with: routeViewModel.id, of: Comment.self) { comment in
            let index = self.getIndex(ht: comment)
            self.hypeData.append(comment)
            self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .middle)
        }

        FirestoreService.shared.fs.listen(collection: "arDiagrams", by: "routeId", with: routeViewModel.id, of: ARDiagram.self) { arDiagram in
            let index = self.getIndex(ht: arDiagram)
            self.hypeData.append(arDiagram)
            self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .middle)
        }
    }

    func getIndex(ht: HypeType) -> Int {
        if let index = hypeData.index(where: { Double($0.dateString) ?? 0.0 > Double(ht.dateString) ?? 0.0 }) {
            return index
        }
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let hypeType = tableData[indexPath.row]

        if let arDiagram = hypeType as? ARDiagram, let cell = tableView.dequeueReusableCell(withIdentifier: "HypeArTVC") as? HypeArTVC {
            cell.selectionStyle = .none
            let arViewModel = ARDiagramViewModel(arDiagram: arDiagram)
            cell.commentImageView.image = nil
            cell.dgImageView.image = nil
            arViewModel.getUsername { username in
                cell.nameLabel.text = username
            }
            ImageCache.shared.getImage(for: arViewModel.bgImageUrl) { image in
                DispatchQueue.main.async {
                    cell.commentImageView.image = image
                }
            }
            ImageCache.shared.getImage(for: arViewModel.dgImageUrl) { image in
                DispatchQueue.main.async {
                    cell.dgImageView.image = image
                }
            }
            cell.dateLabel.text = arViewModel.dateString
            cell.eventLabel.text = "Added a new diagram"
            cell.commentLabel.text = arViewModel.message
            return cell
        } else if let comment = hypeType as? Comment, let cell = tableView.dequeueReusableCell(withIdentifier: "HypeCommentTVC") as? HypeCommentTVC {
            cell.selectionStyle = .none
            let commentViewModel = CommentViewModel(comment: comment)
            cell.commentImageView.image = nil
            commentViewModel.getUsername { username in
                cell.nameLabel.text = username
            }
            if let imageUrl = commentViewModel.imageUrl {
                ImageCache.shared.getImage(for: imageUrl) { image in
                    DispatchQueue.main.async {
                        cell.commentImageView.image = image
                    }
                }
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
        } else if hypeType as? ARDiagram != nil {
            return 200
        } else if hypeType as? Star != nil {
            return 125
        }
        return 75
    }

    func initViews() {
        self.view.backgroundColor = UISettings.shared.colorScheme.backgroundPrimary

        tableView = UITableView()
        tableView.register(HypeCommentTVC.self, forCellReuseIdentifier: "HypeCommentTVC")
        tableView.register(HypeStarTVC.self, forCellReuseIdentifier: "HypeStarTVC")
        tableView.register(HypeArTVC.self, forCellReuseIdentifier: "HypeArTVC")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 65).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }

}
