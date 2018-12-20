import Firebase
import Foundation

struct RouteListViewModel {
    var routeList: RouteList
    var id: String {
        return routeList.id
    }
    var name: String {
        return routeList.name
    }
    var description: String {
        return routeList.description ?? ""
    }

    var detailText: String {
        var str = "\(routeList.routes.count) Route"
        if routeList.routes.count > 1 {
            str += "s"
        }
        str += ", \(contributors.count) Contributor"
        if contributors.count > 1 {
            str += "s"
        }
        return str
    }

    var contributors: [String] {
        return Array(routeList.routes.keys)
    }

    func getRoutes(completion: @escaping (_ results: [String: [Route]]) -> Void) {
        var routes: [String: [Route]] = [:]
        var count = 0
        var totalCount = 0
        for userId in routeList.routes.keys {
            for _ in routeList.routes[userId] ?? [] {
                totalCount += 1
            }
        }
        for userId in routeList.routes.keys {
            let routesForUser = routeList.routes[userId] ?? []
            for routeId in routesForUser {
                Firestore.firestore().query(collection: "routes", by: "id", with: routeId, of: Route.self) { route in
                    if let route = route.first {
                        if routes[userId] == nil {
                            routes[userId] = [route]
                        } else {
                            routes[userId]?.append(route)
                        }
                        count += 1
                        if count == totalCount {
                            completion(routes)
                        }
                    }
                }
            }
        }
    }

    func getOwner(completion: @escaping (_ owner: User) -> Void) {
        Firestore.firestore().query(collection: "users", by: "id", with: routeList.owner, of: User.self) { owner in
            guard let owner = owner.first else { return }
            completion(owner)
        }
    }
}
