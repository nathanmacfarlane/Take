//
//  Route.swift
//  Take
//
//  Created by Family on 4/26/18.
//  Copyright © 2018 N8. All rights reserved.
//

import FirebaseDatabase
import FirebaseStorage
import Foundation
import GeoFire
import MapKit
import UIKit

class RouteService: Codable {
    var routes: [Route]!
}

class Route: NSObject, Comparable, Codable, MKAnnotation {
    // MARK: - properties
    var name: String
    var photoURL: String?
    var id: Int
    var types: String? // TR (Top Rope), Sport, and Trad, Boulder
    var stars: [Star]?
    var star: Double?
    var starVotes: Int?
    var pitches: Int?
    var localDesc: [String]?
    var comments: [Comment]?
    var info: String?
    var feelsLike: [Rating]?
    var images: [String: UIImage]?
    var ardiagrams: [ARDiagram]?
    var ref: DatabaseReference?
    var latitude: Double?
    var longitude: Double?
    var wall: String?
    var area: String?
    var city: String?

    var newARDiagrams: [ARDiagram]?

    //private stuff
    private var allImages: [String: String]?
    private var allDiagrams: [String: [String]]?
    private var rating: String?

    var difficulty: Rating? {
        if self.rating == nil {
            return nil
        }
        return Rating(desc: self.rating!)
    }

    // MARK: - Inits
    init(name: String, id: Int, lat: Double, long: Double) {
        self.name = name
        self.id = id
        self.latitude = lat
        self.longitude = long
    }
    init(snapshot: DataSnapshot) {
        id = Int(snapshot.key)!
        let snapval = snapshot.value            as! [String: AnyObject]
        name = snapval["name"]           as! String
        if let tempLoc = snapval["location"]       as? [Double] {
            latitude = tempLoc[0]
            longitude = tempLoc[1]
        }
        photoURL = snapval["photoURL"]       as? String
        types = snapval["types"]          as? String
        rating = snapval["difficulty"]     as? String
        star = snapval["stars"]          as? Double
        starVotes = snapval["starVotes"]      as? Int
        pitches = snapval["pitches"]        as? Int
        localDesc = snapval["localDesc"]      as? [String]
        if let tempComments = snapval["comments"]   as? [[String: Any]] {
            for tempComment in tempComments {
                comments?.append(Comment(anyObject: tempComment))
            }
        }
        info = snapval["info"]           as? String
        if let tempFeelsLike = snapval["feelsLike"] as? [[String: Any]] {
            for tempFeels in tempFeelsLike {
                if feelsLike == nil {
                    feelsLike = []
                }
                feelsLike?.append(Rating(anyObject: tempFeels))
            }
        }
        area = snapval["area"]           as? String
        allImages = snapval["allImages"]      as? [String: String]
        allDiagrams = snapval["allARDiagrams"]  as? [String: [String]]
        wall = snapval["wall"]           as? String
        city = snapval["city"]           as? String
        self.ref = snapshot.ref
    }

    // MARK: - MKAnnotation
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
    }
    var title: String? {
        return self.name
    }
    var subtitle: String? {
        return self.difficulty?.description
    }

    var location: CLLocation? {
        if latitude == nil || longitude == nil {
            return nil
        }
        return CLLocation(latitude: latitude!, longitude: longitude!)
    }

    enum CodingKeys: String, CodingKey {
        case name
        case id
        case types      = "type"
        case localDesc  = "location"
        case latitude
        case longitude
        case rating
        case star       = "stars"
        case starVotes
        case wall
        case city
        case area
    }

    func description() -> String {
        var desc = "\(name), \(id)"
        if types != nil {
            desc = "\(desc), \(types!)"
        }
        if localDesc != nil {
            desc = "\(desc), \(localDesc!)"
        }
        return desc
    }

    // MARK: - GeoFire
    func saveToGeoFire() {
        if self.latitude == nil || self.longitude == nil {
            return
        }
        let DBRef = Database.database().reference().child("GeoFireRouteKeys")
        let geoFire = GeoFire(firebaseRef: DBRef)
        geoFire.setLocation(CLLocation(latitude: self.latitude!, longitude: self.longitude!), forKey: "\(self.id)") { error in
            if (error != nil) {
                print("An error occured: \(String(describing: error))")
            } else {
                print("Saved location successfully!")
            }
        }
    }

    // MARK: - Firebase
    func getWall(completion: @escaping (_ wall: Wall) -> Void) {
        if let wallName = self.wall {
            let wallsRoot = Database.database().reference(withPath: "walls")
            let query = wallsRoot.queryOrdered(byChild: "name").queryEqual(toValue: wallName)
            query.observeSingleEvent(of: .value, with: { snapshot in
                for item in snapshot.children {
                    completion(Wall(snapshot: item as! DataSnapshot))
                }
            })
        }
    }
    //    func getArea(completion: @escaping (_ area: RouteArea) -> Void) {
    //        if let areaName = self.area {
    //            let areasRoot = Database.database().reference(withPath: "areas")
    //            let query = areasRoot.queryOrdered(byChild: "name").queryEqual(toValue: areaName)
    //            query.observeSingleEvent(of: .value, with: { (snapshot) in
    //                for item in snapshot.children {
    //                    completion(RouteArea(snapshot: item as! DataSnapshot))
    //                }
    //            })
    //        }
    //    }
    func getARImagesFromFirebase(completion: @escaping () -> Void) {
        self.ardiagrams = []
        var count = 0
        for arDiagram in self.allDiagrams ?? [:] {
            URLSession.shared.dataTask(with: URL(string: arDiagram.value[0])!) { bgImageData, _, _ in

                URLSession.shared.dataTask(with: URL(string: arDiagram.value[1])!) { diagramData, _, _ in
                    let newDiagram = ARDiagram(bgImage: UIImage(data: bgImageData!)!, diagram: UIImage(data: diagramData!)!)
                    self.ardiagrams?.append(newDiagram)
                    count += 1
                    if count == self.allDiagrams?.count {
                        completion()
                    }
                    }.resume()

                }.resume()
        }
    }
    func observeImageFromFirebase(completion: @escaping (_ snapshot: DataSnapshot, _ ref: DatabaseReference) -> Void) {
        let imagesRef = Database.database().reference().child("Routes/\(self.id)/allImages")
        imagesRef.observe(.childAdded, with: { snapshot in
            completion(snapshot, imagesRef)
        })
    }
    func getImagesFromFirebase(completion: @escaping () -> Void) {
        self.images = [:]
        var count = 0
        for imgURL in self.allImages ?? [:] {
            URLSession.shared.dataTask(with: URL(string: imgURL.value)!) { data, _, _ in
                self.images?[imgURL.key] = UIImage(data: data!)!
                count += 1
                if count == self.allImages?.count {
                    completion()
                }
                }.resume()
        }
    }
    func getFirstImageFromFirebase(completion: @escaping (_ image: UIImage?) -> Void) {
        if self.allImages?.values.first == nil {
            completion(UIImage(named: "noImages.png"))
            return
        }
        let firstImageKey = self.allImages!.values.first!
        URLSession.shared.dataTask(with: URL(string: firstImageKey)!) { data, _, _ in
            completion(UIImage(data: data!))
            }.resume()
    }
    private func saveToFirebase() {
        if self.ref == nil {
            let ref = Database.database().reference().child("Routes/\(self.id)")
            ref.setValue(self.toAnyObject())
            self.ref = ref
        } else {
            ref?.setValue(self.toAnyObject())
        }
    }
    func deleteImageFromFB(indexOfDeletion: Int, imageURL: String, completion: @escaping () -> Void) {
        //        let storage = Storage.storage()
        //        let storageRef = storage.reference(forURL: imageURL)
        //        storageRef.delete { error in
        //            if let error = error {
        //                print(error)
        //            } else {
        //                completion()
        //            }
        //        }
        //        self.allImages?.remove(at: indexOfDeletion)
        //        self.saveToFirebase()
    }
    func saveToFirebase(newImagesWithKeys: [String: UIImage]) {
        saveToFirebase()
        self.saveImagesToFirebase(newImagesWithKeys: newImagesWithKeys)
    }
    func addImageURLToFirebase(imageURL: String) {
        let rightNow = Date().instanceString()
        self.ref?.child("allImages").updateChildValues([rightNow: imageURL])
        print("just saved image with key: '\(imageURL)'")
    }
    func saveImagesToFirebase(newImagesWithKeys: [String: UIImage]) {
        let storeRef = Storage.storage().reference()
        let imageRef = storeRef.child("Routes/\(self.id)")
        let keys = Array(newImagesWithKeys.keys)
        for imageKey in keys {
            let data = UIImagePNGRepresentation(newImagesWithKeys[imageKey]!.resizedToKB(numKB: 1024)!) as NSData?
            let imageID = UUID().uuidString
            //save to firebase
            _ = imageRef.child("\(imageID).png").putData(data! as Data, metadata: nil, completion: { metadata, error in
                guard metadata != nil else {
                    print("oh shoot... error occured: \(String(describing: error))")
                    return
                }
                imageRef.child("\(imageID).png").downloadURL { url, error in
                    guard let downloadURL = url else {
                        print("error occured: \(String(describing: error))")
                        return
                    }
                    self.addImageURLToFirebase(imageURL: "\(downloadURL)")
                    if self.allImages == nil {
                        self.allImages = [:]
                    }
                    self.allImages![imageKey] = "\(downloadURL)"
                }

            })
        }
    }
    func addARURLToFirebase(bgImageURL: String, diagramURL: String) {
        //        self.ref?.child("allARDiagrams").setValue([bgImageURL: diagramURL])
        let rightNow = Date().instanceString()
        self.ref?.child("allARDiagrams").updateChildValues([rightNow: [bgImageURL, diagramURL]])
        //        if self.allDiagrams == nil {
        //            self.allDiagrams = [:]
        //        }
        //        self.allDiagrams![rightNow] = [bgImageURL, diagramURL]
        self.ref?.child("allARDiagrmas").setValue(self.allDiagrams)
        print("just saved image with key: '\(bgImageURL)' and value: '\(diagramURL)'")
    }
    func saveARImagesToFirebase() {
        let storeRef = Storage.storage().reference()
        let arRef = storeRef.child("Routes/\(self.id)")
        if self.ardiagrams == nil {
            self.ardiagrams = []
        }
        print("going to save ar diagrms")
        for arDiagram in self.newARDiagrams ?? [] {
            print("in for loop")
            self.ardiagrams?.append(arDiagram)
            let bgData = UIImagePNGRepresentation(arDiagram.bgImage.resizedToKB(numKB: 1024)!) as NSData?
            let diagramData = UIImagePNGRepresentation(arDiagram.diagram!.resizedToKB(numKB: 1024)!) as NSData?
            let bgImageID = UUID().uuidString
            let diagramID = UUID().uuidString

            //save bg image to firebase
            _ = arRef.child("\(bgImageID).png").putData(bgData! as Data, metadata: nil, completion: { metadata, error in
                guard metadata != nil else {
                    print("oh shoot... error occured: \(String(describing: error))")
                    return
                }
                arRef.child("\(bgImageID).png").downloadURL { url, error in
                    guard let bgImageIDDownloadURL = url else {
                        print("error occured in bg image: \(String(describing: error))")
                        return
                    }

                    //save diagram to firebase
                    _ = arRef.child("\(diagramID).png").putData(diagramData! as Data, metadata: nil, completion: { metadata, error in
                        guard metadata != nil else {
                            print("oh shoot... error occured: \(String(describing: error))")
                            return
                        }
                        arRef.child("\(diagramID).png").downloadURL { url, error in
                            guard let diagramDownloadURL = url else {
                                print("error occured in diagram: \(String(describing: error))")
                                return
                            }
                            self.addARURLToFirebase(bgImageURL: "\(bgImageIDDownloadURL)", diagramURL: "\(diagramDownloadURL)")
                        }

                    })
                }

            })
        }
    }

    // MARK: - equatable
    open override func isEqual(_ object: Any?) -> Bool {
        guard let r = object as? Route else {
            return false
        }
        return r.id == self.id
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

    // MARK: - functions
    func averageRating() -> String? {
        var sum: Int = 0
        if feelsLike == nil {
            return nil
        }
        for rating in feelsLike! {
            sum += rating.intDiff
        }
        let avg = sum / feelsLike!.count
        let countedSet: NSCountedSet = []
        for rating in feelsLike! {
            if rating.intDiff == avg {
                countedSet.add(rating.buffer ?? "")
            }
        }
        let mostFrequent = "\(countedSet.max { countedSet.count(for: $0) < countedSet.count(for: $1) } ?? "")"
        if feelsLike!.first?.type == .boulder {
            return "V\(avg)\(mostFrequent)"
        } else {
            return "5.\(avg)\(mostFrequent)"
        }
    }
    func averageStar() -> Int? {
        if stars == nil {
            return nil
        }
        var sum: Double = 0
        for star in stars! {
            sum += star.star
        }
        return Int(sum) / (stars!.count)
    }
    func isTR() -> Bool {
        return (self.types?.contains("TR"))!
    }
    func isSport() -> Bool {
        return (self.types?.contains("Sport"))!
    }
    func isTrad() -> Bool {
        return (self.types?.contains("Trad"))!
    }
    func isBoulder() -> Bool {
        return (self.types?.contains("Boulder"))!
    }
    func toString() -> String {
        return "'\(name)' - Difficulty: '\(difficulty?.description ?? "N/A")', Types: \(types ?? "N/A")"
    }
    func toAnyObject() -> Any {
        var a: [String: Any] = [:]
        a["name"] = name
        if latitude != nil {
            a["location"] = [latitude, longitude]
        }
        if photoURL != nil {
            a["photoURL"] = photoURL
        }
        a["id"] = id
        if types != nil {
            a["types"] = types
        }
        if rating != nil {
            a["difficulty"] = rating
        }
        if star != nil {
            a["stars"] = star
        }
        if starVotes != nil {
            a["starVotes"] = starVotes
        }
        if pitches != nil {
            a["pitches"] = pitches
        }
        if localDesc != nil {
            a["localDesc"] = localDesc
        }
        if comments != nil {
            var commentsAnyArr: [Any] = []
            for comment in comments! {
                commentsAnyArr.append(comment.toAnyObject())
            }
            a["comments"] = commentsAnyArr
        }
        if info != nil {
            a["info"] = info
        }
        if feelsLike != nil {
            var feelsLikeAnyArr: [Any] = []
            for feels in feelsLike! {
                feelsLikeAnyArr.append(feels.toAnyObject())
            }
            a["feelsLike"] = feelsLikeAnyArr
        }
        if area != nil {
            a["area"] = area
        }
        if allImages != nil {
            a["allImages"] = allImages
        }

        return a
    }

}
