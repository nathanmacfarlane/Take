import Foundation
import UIKit

extension SearchRoutesVC: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.results.clear()
        self.resultsMashed.removeAll()
        self.myTableView.reloadData()

        self.mySearchBar.resignFirstResponder()

        guard let searchText = searchBar.text else { return }
        FirestoreService.shared.fs.query(collection: "routes", by: "name", with: searchText, of: Route.self) { routes in
            self.resultsMashed.append(contentsOf: routes)
            self.results.routes.append(contentsOf: routes)
            self.myTableView.reloadData()
        }
    }
}
