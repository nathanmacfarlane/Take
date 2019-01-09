import Foundation
/// Struct for list of routes (ex: ToDo List)
/// - id: Identifier
/// - name: Name of list (ex: Summer 2019)
/// - owner: User id of the list creater
/// - contributors: User ids of other contributers to the list
/// - invitees: User ids of invitees on the list
/// - routes: key is userid, value is array of route ids
/// - description: optional description about the list
struct RouteList: Codable {
    var id: String
    var name: String
    var owner: String
    var routes: [String: [String]]
    var description: String?
    var contributors: [String]
    var invitees: [String]

    func containsRoute(routeId: String) -> Bool {
        for userId in routes.keys {
            for route in routes[userId] ?? [] where routeId == route {
                return true
            }
        }
        return false
    }
}
