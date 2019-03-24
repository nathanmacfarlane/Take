import Foundation

enum MPQueryTitle: String {
    case maxDistance, maxResults, minDiff, maxDiff
}

struct MPQueryParam {
    var title: MPQueryTitle
    var property: String
}

class MPService {
    static let shared = MPService()

    private let urlPrefix = "https://www.mountainproject.com/data"

    func getRoutesForLatLon(latitude: Double, longitude: Double, params: [MPQueryParam] = [], completion: @escaping (_ results: [MPRoute]) -> Void) {
        let paramString = params.map { "&\($0.title)=\($0.property)" }.joined()
        let url = "\(urlPrefix)/get-routes-for-lat-lon?lat=\(latitude)&lon=\(longitude)\(paramString)&key=\(Constants.mpApiKey)"
        mpQuery(url: url, type: MPRouteArray.self) { results in
            completion(results.routes)
        }
    }

    func getRoutes(ids: [String], completion: @escaping (_ results: [MPRoute]) -> Void) {
        let idString = ids.joined(separator: ",")
        let url = "\(urlPrefix)/get-routes?routeIds=\(idString)&key=\(Constants.mpApiKey)"
        mpQuery(url: url, type: MPRouteArray.self) { results in
            completion(results.routes)
        }
    }

    func getUser(userId: String? = nil, email: String? = nil, completion: @escaping (_ user: MPUser) -> Void) {
        if (userId == nil && email == nil) || (userId != nil && email != nil) { return }

        let userOrEmail = "\(userId != nil ? "userId=\(userId ?? "")" : "email=\(email ?? "")")"
        let url = "\(urlPrefix)/get-user?\(userOrEmail)&key=\(Constants.mpApiKey)"

        mpQuery(url: url, type: MPUser.self) { user in
            completion(user)
        }
    }

    func getTicks(userId: String? = nil, email: String? = nil, startPos: Int? = nil, completion: @escaping (_ user: MPTickList) -> Void) {
        if (userId == nil && email == nil) || (userId != nil && email != nil) { return }
        let userOrEmail = "\(userId != nil ? "userId=\(userId ?? "")" : "email=\(email ?? "")")"
        let url = "\(urlPrefix)/get-ticks?\(userOrEmail)&startPos=\(startPos ?? 0)&key=\(Constants.mpApiKey)"

        mpQuery(url: url, type: MPTickList.self) { tickList in
            completion(tickList)
        }
    }

    func getToDos(userId: String? = nil, email: String? = nil, startPos: Int? = nil, completion: @escaping (_ user: MPToDoList) -> Void) {
        if (userId == nil && email == nil) || (userId != nil && email != nil) { return }
        let userOrEmail = "\(userId != nil ? "userId=\(userId ?? "")" : "email=\(email ?? "")")"
        let url = "\(urlPrefix)/get-to-dos?\(userOrEmail)&startPos=\(startPos ?? 0)&key=\(Constants.mpApiKey)"

        mpQuery(url: url, type: MPToDoList.self) { toDoList in
            completion(toDoList)
        }
    }

    private func mpQuery<T>(url: String, type: T.Type, completion: @escaping (_ results: T) -> Void) where T: Decodable {
        guard let dataUrl = URL(string: url) else { return }
        let request = URLRequest(url: dataUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15)
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data, let results = try? JSONDecoder().decode(T.self, from: data) else { return }
            completion(results)
        }
        task.resume()
    }

}
