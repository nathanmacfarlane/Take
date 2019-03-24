import CodableFirebase
import FirebaseFirestore
import Foundation
import UIKit

extension SearchRoutesVC: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.results.clear()
        self.resultsMashed.removeAll()
        self.myTableView.reloadData()

        self.mySearchBar.resignFirstResponder()

        guard let searchText = searchBar.text else { return }
        FirestoreService.shared.fs.listen(collection: "routes", by: "name", with: searchText, of: Route.self) { route in
            self.resultsMashed.append(route)
            self.results.routes.append(route)
            self.myTableView.insertRows(at: [IndexPath(row: self.resultsMashed.count - 1, section: 0)], with: UITableView.RowAnimation.right)
        }
    }
}
