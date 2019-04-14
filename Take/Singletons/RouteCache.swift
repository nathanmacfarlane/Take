import Foundation
import UIKit

class RouteCache {

    static let shared = RouteCache()
    private var mpCache: [Int: MPRoute] = [:]
    private var takeCache: [String: Route] = [:]

    func addRoute(route: Route) {
        takeCache[route.id] = route
    }

    func addRoute(route: MPRoute) {
        mpCache[route.id] = route
    }

    func getRoute(for id: Int, completion: @escaping (_ route: MPRoute?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let route = self.mpCache[id] {
                completion(route)
                return
            }
            MPService.shared.getRoutes(ids: ["\(id)"]) { routes in
                if let route = routes.first {
                    self.mpCache[route.id] = route
                    completion(route)
                    return
                }
            }
        }
    }

    func getRoute(for id: String, completion: @escaping (_ route: Route?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let route = self.takeCache[id] {
                self.takeCache[route.id] = route
                completion(route)
                return
            }
            FirestoreService.shared.fs.query(collection: "routes", by: "id", with: id, of: Route.self) { routes in
                if let route = routes.first {
                    completion(route)
                    return
                }
            }
        }
    }

    func clearCache() {
        mpCache = [:]
        takeCache = [:]
    }
}
