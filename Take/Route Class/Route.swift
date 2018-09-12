//
//  Route.swift
//  Take
//
//  Created by Family on 4/26/18.
//  Copyright © 2018 N8. All rights reserved.
//

import CodableFirebase
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage
import Foundation
import Geofirestore
import MapKit
import UIKit

class RouteService: Codable {
    var routes: [Route] = []
}

class Route: NSObject, Comparable, Codable, MKAnnotation {

    // MARK: - properties
    var name: String
    var id: String
    var pitches: Int
    var types: [String] = [] // TR (Top Rope), Sport, and Trad, Boulder
    var stars: [String: Int] = [:]
    var info: String?
    var protection: String?
    var area: String?
    var imageUrls: [String: String] = [:]
    var routeArUrls: [String: [String]] = [:]
    var rating: String?
    var commentIds: [String] = []
    var latitude: Double?
    var longitude: Double?

    // not really implemented on the new model
    var localDesc: [String] = []
    var wall: String?
    var city: String?

    enum CodingKeys: String, CodingKey {
        case name
        case id
        case types
        case latitude
        case longitude
        case area
        case info
        case protection
        case imageUrls
        case stars
        case pitches
        case rating
        case routeArUrls
        case commentIds
    }

    var averageStar: Double? {
        if stars.isEmpty { return nil }
        var sum: Double = 0
        for star in stars.values {
            sum += Double(star)
        }
        return sum / Double(stars.count)
    }

    var difficulty: Rating? {
        if let tempRating = self.rating {
            return Rating(desc: tempRating)
        }
        return nil
    }

    var typesString: String {
        var types: [String] = []
        for type in self.types {
            types.append("\(type)")
        }
        return types.joined(separator: ", ")
    }

    // MARK: - Inits
    init(name: String, id: String, lat: Double, long: Double, pitches: Int) {
        self.name = name
        self.id = id
        self.latitude = lat
        self.longitude = long
        self.pitches = pitches
    }
    override init() {
        self.name = ""
        self.id = UUID().uuidString
        self.pitches = 1
    }

    // MARK: - MKAnnotation
    var coordinate: CLLocationCoordinate2D {
        if let lat = self.latitude, let long = self.longitude {
            return CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        return CLLocationCoordinate2D(latitude: -1, longitude: -1)
    }
    var title: String? {
        return self.name
    }
    var subtitle: String? {
        return self.difficulty?.description
    }

    var location: CLLocation? {
        if let lat = latitude, let long = longitude {
            return CLLocation(latitude: lat, longitude: long)
        }
        return CLLocation(latitude: -1, longitude: -1)
    }

    // MARK: - equatable
    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? Route else {
            return false
        }
        return rhs.id == self.id
    }
    static func == (lhs: Route, rhs: Route) -> Bool {
        return lhs.id == rhs.id
    }
    static func != (lhs: Route, rhs: Route) -> Bool {
        return lhs.id != rhs.id
    }

    // MARK: - comparable
    static func < (lhs: Route, rhs: Route) -> Bool {
        /* TODO */
        return true
    }

    func isTR() -> Bool {
        return self.types.contains("TR")
    }
    func isSport() -> Bool {
        return self.types.contains("Sport")
    }
    func isTrad() -> Bool {
        return self.types.contains("Trad")
    }
    func isBoulder() -> Bool {
        return self.types.contains("Boulder")
    }
    func toString() -> String {
        return "'\(name)' - Difficulty: '\(difficulty?.description ?? "N/A")'"
    }

    func fsSave() {
        guard let data = try! FirebaseEncoder().encode(self) as? [String: Any] else { return }
        let collection = Firestore.firestore().collection("routes")
        collection.document("\(self.id)").setData(data)
        guard let routeLocation = self.location else { return }
        let geoFirestore = GeoFirestore(collectionRef: collection)
        geoFirestore.setLocation(location: routeLocation, forDocumentWithID: self.id)
    }

    func getArea(completion: @escaping (_ area: Area?) -> Void) {
        guard let areaName = self.area else { return }
        Firestore.firestore().query(type: Area.self, by: "name", with: areaName) { areas in
            guard let theArea = areas.first else { return }
            completion(theArea)
        }
    }

    func getComments(completion: @escaping (_ comments: [Comment]) -> Void) {
        var comments: [Comment] = []
        var count = 0
        for commentId in self.commentIds {
            Firestore.firestore().getComment(id: commentId) { comment in
                comments.append(comment)
                count += 1
                if count == self.commentIds.count {
                    completion(comments)
                }
            }
        }
    }
}
