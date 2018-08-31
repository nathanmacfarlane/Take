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
import GeoFire
import MapKit
import UIKit

class RouteService: Codable {
    var routes: [Route] = []
}

class Route: NSObject, Comparable, Codable, MKAnnotation, RouteFirebase {

    // MARK: - properties
    var name: String
    var keyword: String?
    var id: Int
    var pitches: Int
    var types: [String] = [] // TR (Top Rope), Sport, and Trad, Boulder
    var stars: [String: Int] = [:]
    var info: String?
    var protection: String?
    var area: String?
    var imageUrls: [String: String] = [:]
    var routeArUrls: [String: [String]] = [:]
    var rating: String?

    // not really implemented on the new model
    var comments: [Comment] = []
    var localDesc: [String] = []
    var ref: DatabaseReference?
    var latitude: Double?
    var longitude: Double?
    var wall: String?
    var city: String?
    // urls to images in storage

//    var newARDiagrams: [ARDiagram] = []
    var ardiagrams: [ARDiagram] = []

    enum CodingKeys: String, CodingKey {
        case name
        case keyword
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
    }

    //private stuff
    private var allDiagrams: [String: [String]] = [:]

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
    init(name: String, id: Int, lat: Double, long: Double, pitches: Int) {
        self.name = name
        self.id = id
        self.latitude = lat
        self.longitude = long
        self.pitches = pitches
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

    // MARK: - GeoFire
    func saveToGeoFire() {
        guard let theLat = self.latitude, let theLong = self.longitude else { return }
        let DBRef = Database.database().reference().child("GeoFireRouteKeys")
        let geoFire = GeoFire(firebaseRef: DBRef)
        geoFire.setLocation(CLLocation(latitude: theLat, longitude: theLong), forKey: "\(self.id)") { error in
            if error != nil {
                print("An error occured: \(String(describing: error))")
            } else {
                print("Saved location successfully!")
            }
        }
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
        Firestore.firestore().collection("routes").document("\(self.id)").setData(data)
    }

    func getArea(completion: @escaping (_ area: Area?) -> Void) {
        guard let areaName = self.area else { return }
        Firestore.firestore().query(type: Area.self, by: "name", with: areaName) { areas in
            guard let theArea = areas.first else { return }
            completion(theArea)
        }
    }

    // MARK: - Protocol
    func fsLoadImages(completion: @escaping (_ images: [String: UIImage]) -> Void) {
        var images: [String: UIImage] = [:]
        var count = 0
        for routeImage in imageUrls {
            guard let theURL = URL(string: routeImage.value) else { continue }
            URLSession.shared.dataTask(with: theURL) { data, _, _ in
                guard let theData = data, let theImage = UIImage(data: theData) else { return }
                images[routeImage.key] = theImage
                count += 1
                if count == self.imageUrls.count {
                    completion(images)
                }
            }
            .resume()
        }
    }

    func fsLoadAR(completion: @escaping ([String: [UIImage]]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            var arMap: [String: [UIImage]] = [:]
            var count = 0
            for routeAR in self.routeArUrls {
                guard let bgUrl = URL(string: routeAR.value[0]), let diagramUrl = URL(string: routeAR.value[1]) else { continue }
                URLSession.shared.dataTask(with: bgUrl) { data, _, _ in
                    guard let bgData = data, let bgImage = UIImage(data: bgData) else { return }
                    if var ar = arMap[routeAR.key] {
                        ar.insert(bgImage, at: 0)
                        arMap.updateValue(ar, forKey: routeAR.key)
                    } else {
                        arMap.updateValue([bgImage], forKey: routeAR.key)
                    }
                    DispatchQueue.main.async {
                        count += 1
                        if count == self.routeArUrls.count * 2 {
                            completion(arMap)
                        }
                    }
                }
                .resume()
                URLSession.shared.dataTask(with: diagramUrl) { data, _, _ in
                    guard let dgData = data, let dgImage = UIImage(data: dgData) else { return }
                    if var dg = arMap[routeAR.key] {
                        dg.append(dgImage)
                        arMap.updateValue(dg, forKey: routeAR.key)
                    } else {
                        arMap.updateValue([dgImage], forKey: routeAR.key)
                    }
                    DispatchQueue.main.async {
                        count += 1
                        if count == self.routeArUrls.count * 2 {
                            completion(arMap)
                        }
                    }
                }
                .resume()
            }
        }
    }

    func fsLoadFirstImage(completion: @escaping (_ key: String?, _ image: UIImage?) -> Void) {
        guard let routeImage = imageUrls.first, let theURL = URL(string: routeImage.value) else {
            completion(nil, nil)
            return
        }
        URLSession.shared.dataTask(with: theURL) { data, _, _ in
            guard let theData = data, let theImage = UIImage(data: theData) else {
                completion(nil, nil)
                return
            }
            completion(routeImage.key, theImage)
        }
        .resume()
    }

    func fbSaveImages(images: [String: UIImage], completion: @escaping () -> Void) {
        let keys = Array(images.keys)
        for imageKey in keys {
            guard let image = images[imageKey],
                let largeImage = image.resizedToKB(numKB: 2048),
                let smallImage = image.resizedToKB(numKB: 2048)
                else { continue }
            savePhotoToFb(image: largeImage, size: "Large")
            savePhotoToFb(image: smallImage, size: "Thumbnail")
        }
    }

    func fsSaveAr(ar: [String: [UIImage]], completion: @escaping () -> Void) {
        let keys = Array(ar.keys)
        for arKey in keys {
            guard let arImage = ar[arKey], let bgImage = arImage[0].resizedToKB(numKB: 1024), let dgImage = arImage[1].resizedToKB(numKB: 1024) else { continue }
            saveArToFb(imageId: arKey, bgImage: bgImage, dgImage: dgImage)
        }
    }

    func saveArToFb(imageId: String, bgImage: UIImage, dgImage: UIImage) {
        let imageRef = Storage.storage().reference().child("Routes/\(self.id)")
        guard let bgData = UIImageJPEGRepresentation(bgImage, 0.25) as NSData?, let dgData = UIImagePNGRepresentation(dgImage) as NSData? else { return }

        var bgUrl: String = ""
        var dgUrl: String = ""

        _ = imageRef.child("\(imageId)-bgImage.png").putData(bgData as Data, metadata: nil) { metadata, _ in
            guard metadata != nil else { return }
            imageRef.child("\(imageId)-bgImage.png").downloadURL { url, _ in
                guard let downloadURL = url else { return }
                bgUrl = "\(downloadURL)"
                print("bgUrl: \(bgUrl)")
                if !dgUrl.isEmpty {
                    self.routeArUrls[imageId] = [bgUrl, dgUrl]
                    Firestore.firestore().collection("routes").document("\(self.id)").setData(["routeArUrls": self.routeArUrls], merge: true)
                }
            }
        }

        _ = imageRef.child("\(imageId)-dgImage.png").putData(dgData as Data, metadata: nil) { metadata, _ in
            guard metadata != nil else { return }
            imageRef.child("\(imageId)-dgImage.png").downloadURL { url, _ in
                guard let downloadURL = url else { return }
                dgUrl = "\(downloadURL)"
                print("dgUrl: \(dgUrl)")
                if !bgUrl.isEmpty {
                    self.routeArUrls[imageId] = [bgUrl, dgUrl]
                    Firestore.firestore().collection("routes").document("\(self.id)").setData(["routeArUrls": self.routeArUrls], merge: true)
                }
            }
        }

    }

    private func savePhotoToFb(image: UIImage, size: String) {
        let imageRef = Storage.storage().reference().child("Routes/\(self.id)")
        guard let data = UIImagePNGRepresentation(image) as NSData? else { return }
        let imageId = UUID().uuidString
        _ = imageRef.child("\(imageId)-\(size).png").putData(data as Data, metadata: nil) { metadata, _ in
            guard metadata != nil else { return }
            imageRef.child("\(imageId)-\(size).png").downloadURL { url, _ in
                guard let downloadURL = url else { return }
                self.ref?.child("images").updateChildValues([imageId: downloadURL])
            }

        }
    }

}
