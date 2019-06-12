import CodableFirebase
import FirebaseFirestore
import Foundation
import InstantSearchClient
import UIKit

struct AlgoliaRoute: Codable {
    let name: String
    let objectID: String
}

struct AlgoliaUser: Codable {
    let name: String
    let objectID: String
}

struct AlgoliaUsersService: Codable {
    let hits: [AlgoliaUser]
}

struct AlgoliaRoutesService: Codable {
    let hits: [AlgoliaRoute]
}

extension SearchRoutesVC: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.results.clear()
        self.resultsMashed.removeAll()
        self.myTableView.reloadData()

        self.mySearchBar.resignFirstResponder()

        guard let searchText = searchBar.text else { return }

        let index = client.index(withName: "route_search")
        index.search(Query(query: searchText)) { data, _ in
            guard let d = data else { return }
            guard let results = try? FirebaseDecoder().decode(AlgoliaRoutesService.self, from: d) else { return }

            for r in results.hits {
                FirestoreService.shared.fs.listen(collection: "routes", by: "id", with: r.objectID, of: Route.self) { route in
                    self.resultsMashed.append(route)
                    self.results.routes.append(route)
                    self.myTableView.insertRows(at: [IndexPath(row: self.resultsMashed.count - 1, section: 0)], with: UITableView.RowAnimation.right)
                }
            }
        }

        let user_index = client.index(withName: "user_search")
        user_index.search(Query(query: searchText)) { data, _ in
            guard let d = data else { return }
            guard let results = try? FirebaseDecoder().decode(AlgoliaUsersService.self, from: d) else { return }

            for r in results.hits {
                FirestoreService.shared.fs.listen(collection: "users", by: "id", with: r.objectID, of: User.self) { user in
                    self.resultsMashed.append(user)
                    self.results.users.append(user)
                    self.myTableView.insertRows(at: [IndexPath(row: self.resultsMashed.count - 1, section: 0)], with: UITableView.RowAnimation.right)
                }
            }
        }

//        guard let searchText = searchBar.text else { return }
//        FirestoreService.shared.fs.listen(collection: "routes", by: "name", with: searchText, of: Route.self) { route in
//            self.resultsMashed.append(route)
//            self.results.routes.append(route)
//            self.myTableView.insertRows(at: [IndexPath(row: self.resultsMashed.count - 1, section: 0)], with: UITableView.RowAnimation.right)
//        }
//
//        FirestoreService.shared.fs.listen(collection: "areas", by: "name", with: searchText, of: Area.self) { area in
//            self.resultsMashed.append(area)
//            self.results.areas.append(area)
//            self.myTableView.insertRows(at: [IndexPath(row: self.resultsMashed.count - 1, section: 0)], with: UITableView.RowAnimation.right)
//        }
    }
}
