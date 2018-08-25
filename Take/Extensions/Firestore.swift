//
//  Firebase.swift
//  Take
//
//  Created by Nathan Macfarlane on 8/24/18.
//  Copyright © 2018 N8. All rights reserved.
//

import CodableFirebase
import Firebase
import FirebaseFirestore
import Foundation

extension Firestore {
    func getRoutesBy(_ property: String, withValue value: Any, completion: @escaping (_ routes: [Route]) -> Void) {
        var routes: [Route] = []
        let settings = self.settings
        settings.areTimestampsInSnapshotsEnabled = true
        self.settings = settings
        self.collection("routes").whereField("name", isEqualTo: "Camel").getDocuments { querySnapshot, err in
            if let err = err {
                print("Error getting routes: \(err)")
            } else {
                guard let snap = querySnapshot else { return }
                for document in snap.documents {
                    let route = try! FirebaseDecoder().decode(Route.self, from: document.data())
                    routes.append(route)
//                    do {
//                        let route = try FirebaseDecoder().decode(Route.self, from: document.data())
//                        routes.append(route)
//                    } catch let error {
//                        print(error)
//                    }
                }
                completion(routes)
            }
        }
    }

    func query<T>(type: T.Type, by field: String, with value: Any, completion: @escaping (_ results: [T]) -> Void) {
        if type == Route.self {
            queryRoutes(by: field, with: value) { routes in
                guard let routes = routes as? [T] else {
                    completion([])
                    return
                }
                completion(routes)
            }
        } else if type == Area.self {
            queryAreas(by: field, with: value) { areas in
                guard let areas = areas as? [T] else {
                    completion([])
                    return
                }
                completion(areas)
            }
        }
    }

    func queryAreas(by field: String, with value: Any, completion: @escaping (_ areas: [Area]) -> Void) {
        var areas: [Area] = []
        self.query(collection: "areas", by: field, with: value) { documents in
            for doc in documents {
                guard let area = try? FirebaseDecoder().decode(Area.self, from: doc.data() as Any) else {
                    print("couldn't get area")
                    continue
                }
                areas.append(area)
            }
            completion(areas)
        }
    }

    func queryRoutes(by field: String, with value: Any, completion: @escaping (_ routes: [Route]) -> Void) {
        var routes: [Route] = []
        self.query(collection: "routes", by: field, with: value) { documents in
            for doc in documents {
                guard let route = try? FirebaseDecoder().decode(Route.self, from: doc.data() as Any) else {
                    print("couldn't get route")
                    continue
                }
                routes.append(route)
            }
            completion(routes)
        }
    }

    private func query(collection: String, by field: String, with value: Any, completion: @escaping (_ results: [QueryDocumentSnapshot]) -> Void) {
        let settings = self.settings
        settings.areTimestampsInSnapshotsEnabled = true
        self.settings = settings
        self.collection(collection).whereField(field, isEqualTo: value).getDocuments { snapshot, err in
            guard err == nil, let snap = snapshot else { return }
            completion(snap.documents)
        }
    }
}
