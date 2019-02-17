import FirebaseFirestore
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
        var str = "\(routeCount) Route"
        if routeCount > 1 {
            str += "s"
        }
        str += ", \(contributors.count) Contributor"
        if contributors.count > 1 {
            str += "s"
        }
        return str
    }

    var contributors: [String] {
        return routeList.contributors
    }

    var routeCount: Int {
        var count = 0
        let keys = Array(routeList.routes.keys)
        keys.forEach { key in
            count += routeList.routes[key]?.count ?? 0
        }
        return count
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

    func getContributors(completion: @escaping (_ contributors: [User]) -> Void) {
        var users: [User] = []
        for userId in routeList.contributors {
            Firestore.firestore().query(collection: "users", by: "id", with: userId, of: User.self) { user in
                guard let user = user.first else { return }
                users.append(user)
                if users.count == self.routeList.contributors.count {
                    completion(users)
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

    mutating func removeRoute(user: User, route: Route, completion: @escaping (_ success: Bool) -> Void) {
        guard var userRoutes = routeList.routes[user.id] else {
            completion(false)
            return
        }
        userRoutes = userRoutes.filter { $0 != route.id }
        routeList.routes[user.id] = userRoutes
        Firestore.firestore().save(object: routeList, to: "routeLists", with: routeList.id) {
            completion(true)
        }
    }
}
