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
    var routes: [Route] = []
}

class Route: NSObject, Comparable, Codable, MKAnnotation {
    // MARK: - properties
    var name: String
    var photoURL: String?
    var id: Int
    var types: String? // TR (Top Rope), Sport, and Trad, Boulder
    var stars: [Star] = []
    var star: Double?
    var starVotes: Int?
    var pitches: Int?
    var localDesc: [String] = []
    var comments: [Comment] = []
    var info: String?
    var feelsLike: [Rating] = []
    var images: [String: UIImage] = [:]
    var ardiagrams: [ARDiagram] = []
    var ref: DatabaseReference?
    var latitude: Double?
    var longitude: Double?
    var wall: String?
    var area: String?
    var city: String?

    var newARDiagrams: [ARDiagram] = []

    //private stuff
    private var allImages: [String: String] = [:]
    private var allDiagrams: [String: [String]] = [:]
    private var rating: String?

    var difficulty: Rating? {
        if let tempRating = self.rating {
            return Rating(desc: tempRating)
        }
        return nil
    }

    // MARK: - Inits
    init(name: String, id: Int, lat: Double, long: Double) {
        self.name = name
        self.id = id
        self.latitude = lat
        self.longitude = long
    }
    init?(snapshot: DataSnapshot) {
        self.id = Int(snapshot.key) ?? 0
        guard let snapval = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        guard let tempName = snapval["name"] as? String, let tempLoc = snapval["location"] as? [Double] else {
            return nil
        }
        name = tempName
        latitude = tempLoc[0]
        longitude = tempLoc[1]
        photoURL = snapval["photoURL"] as? String
        types = snapval["types"] as? String
        rating = snapval["difficulty"] as? String
        star = snapval["stars"] as? Double
        starVotes = snapval["starVotes"] as? Int
        pitches = snapval["pitches"] as? Int
        guard let tempLocalDesc = snapval["localDesc"] as? [String] else {
            return nil
        }
        localDesc = tempLocalDesc
        if let tempComments = snapval["comments"] as? [[String: Any]] {
            for tempComment in tempComments {
                comments.append(Comment(anyObject: tempComment))
            }
        }
        info = snapval["info"] as? String
        if let tempFeelsLike = snapval["feelsLike"] as? [[String: Any]] {
            for tempFeels in tempFeelsLike {
                feelsLike.append(Rating(anyObject: tempFeels))
            }
        }
        area = snapval["area"] as? String
        if let tempAllImages = snapval["allImages"] as? [String: String] {
            allImages = tempAllImages
        }
        if let tempAllDiagrams = snapval["allARDiagrams"]  as? [String: [String]] {
            allDiagrams = tempAllDiagrams
        }
        wall = snapval["wall"]           as? String
        city = snapval["city"]           as? String
        self.ref = snapshot.ref
    }

    // MARK: - MKAnnotation
    var coordinate: CLLocationCoordinate2D {
        if let lat = self.latitude, let long = self.longitude {
            return CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
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
        var desc = "\(name) \(id)"
        if let tempTypes = types {
            desc += " \(tempTypes)"
        }
        if !localDesc.isEmpty {
            desc += " \(localDesc)"
        }
        return desc
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

    // MARK: - Firebase
    func getWall(completion: @escaping (_ wall: Wall) -> Void) {
        if let wallName = self.wall {
            let wallsRoot = Database.database().reference(withPath: "walls")
            let query = wallsRoot.queryOrdered(byChild: "name").queryEqual(toValue: wallName)
            query.observeSingleEvent(of: .value) { snapshot in
                for item in snapshot.children {
                    guard let item = item as? DataSnapshot else { return }
                    completion(Wall(snapshot: item))
                }
            }
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
        for arDiagram in self.allDiagrams {
            guard let theDiagram = URL(string: arDiagram.value[0]) else { continue }
            URLSession.shared.dataTask(with: theDiagram) { bgImageData, _, _ in

                guard let bgData = bgImageData else { return }
                guard let theURL = URL(string: arDiagram.value[1]) else { return }
                guard let bgImage = UIImage(data: bgData) else { return }
                URLSession.shared.dataTask(with: theURL) { diagramData, _, _ in

                    guard let dData = diagramData else { return }
                    guard let dImage = UIImage(data: dData) else { return }
                    let newDiagram = ARDiagram(bgImage: bgImage, diagram: dImage)
                    self.ardiagrams.append(newDiagram)
                    count += 1
                    if count == self.allDiagrams.count {
                        completion()
                    }
                }
                .resume()

            }
            .resume()
        }
    }
    func observeImageFromFirebase(completion: @escaping (_ snapshot: DataSnapshot, _ ref: DatabaseReference) -> Void) {
        let imagesRef = Database.database().reference().child("Routes/\(self.id)/allImages")
        imagesRef.observe(.childAdded) { snapshot in
            completion(snapshot, imagesRef)
        }
    }
    func getImagesFromFirebase(completion: @escaping () -> Void) {
        self.images = [:]
        var count = 0
        for imgURL in self.allImages {
            guard let theURL = URL(string: imgURL.value) else { continue }
            URLSession.shared.dataTask(with: theURL) { data, _, _ in
                guard let theData = data, let theImage = UIImage(data: theData) else { return }
                self.images[imgURL.key] = theImage
                count += 1
                if count == self.allImages.count {
                    completion()
                }
            }
            .resume()
        }
    }
    func getFirstImageFromFirebase(completion: @escaping (_ image: UIImage?) -> Void) {
        if self.allImages.values.first == nil {
            completion(#imageLiteral(resourceName: "noImages.png"))
            return
        }
        guard let firstImageKey = self.allImages.values.first, let theURL = URL(string: firstImageKey) else { return }
        URLSession.shared.dataTask(with: theURL) { data, _, _ in
            guard let theData = data else { return }
            completion(UIImage(data: theData))
        }
        .resume()
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

            guard let imageFromKey = newImagesWithKeys[imageKey], let resizedImage = imageFromKey.resizedToKB(numKB: 1024) else { return }
            guard let data = UIImagePNGRepresentation(resizedImage) as NSData? else { return }
            let imageID = UUID().uuidString
            //save to firebase
            _ = imageRef.child("\(imageID).png").putData(data as Data, metadata: nil) { metadata, error in
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
                    self.allImages[imageKey] = "\(downloadURL)"
                }

            }
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
        print("going to save ar diagrms")
        for arDiagram in self.newARDiagrams {
            print("in for loop")
            self.ardiagrams.append(arDiagram)
            guard let resizedBGImage = arDiagram.bgImage.resizedToKB(numKB: 1024) else { return }
            guard let bgData = UIImagePNGRepresentation(resizedBGImage) as NSData? else { return }

            guard let theDiagram = arDiagram.diagram, let resizedDiagram = theDiagram.resizedToKB(numKB: 1024) else { return }
            let diagramData = UIImagePNGRepresentation(resizedDiagram) as NSData?
            let bgImageID = UUID().uuidString
            let diagramID = UUID().uuidString

            //save bg image to firebase
            _ = arRef.child("\(bgImageID).png").putData(bgData as Data, metadata: nil) { metadata, error in
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
                    guard let dData = diagramData else { return }
                    _ = arRef.child("\(diagramID).png").putData(dData as Data, metadata: nil) { metadata, error in
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

                    }
                }

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

    // MARK: - functions
    func averageRating() -> String? {
        var sum: Int = 0
        for rating in feelsLike {
            sum += rating.intDiff
        }
        let avg = sum / feelsLike.count
        let countedSet: NSCountedSet = []
        for rating in feelsLike where rating.intDiff == avg {
            countedSet.add(rating.buffer ?? "")
        }
        let mostFrequent = "\(countedSet.max { countedSet.count(for: $0) < countedSet.count(for: $1) } ?? "")"
        if feelsLike.first?.type == .boulder {
            return "V\(avg)\(mostFrequent)"
        } else {
            return "5.\(avg)\(mostFrequent)"
        }
    }
    func averageStar() -> Int? {
        var sum: Double = 0
        for star in stars {
            sum += star.star
        }
        return Int(sum) / (stars.count)
    }
    func isTR() -> Bool {
        guard theTypes = self.types else { return false }
        return theTypes.contains("TR") ?? false
    }
    func isSport() -> Bool {
        guard theTypes = self.types else { return false }
        return theTypes.contains("Sport") ?? false
    }
    func isTrad() -> Bool {
        guard theTypes = self.types else { return false }
        return theTypes.contains("Trad") ?? false
    }
    func isBoulder() -> Bool {
        guard theTypes = self.types else { return false }
        return theTypes.contains("Boulder") ?? false
    }
    func toString() -> String {
        return "'\(name)' - Difficulty: '\(difficulty?.description ?? "N/A")', Types: \(types ?? "N/A")"
    }
    func toAnyObject() -> Any {
        var any: [String: Any] = [:]
        any["name"] = name
        if latitude != nil {
            any["location"] = [latitude, longitude]
        }
        if photoURL != nil {
            any["photoURL"] = photoURL
        }
        any["id"] = id
        if types != nil {
            any["types"] = types
        }
        if rating != nil {
            any["difficulty"] = rating
        }
        if star != nil {
            any["stars"] = star
        }
        if starVotes != nil {
            any["starVotes"] = starVotes
        }
        if pitches != nil {
            any["pitches"] = pitches
        }
        if !localDesc.isEmpty {
            any["localDesc"] = localDesc
        }
        if !comments.isEmpty {
            var commentsAnyArr: [Any] = []
            for comment in comments {
                commentsAnyArr.append(comment.toAnyObject())
            }
            any["comments"] = commentsAnyArr
        }
        if info != nil {
            any["info"] = info
        }
        if !feelsLike.isEmpty {
            var feelsLikeAnyArr: [Any] = []
            for feels in feelsLike {
                feelsLikeAnyArr.append(feels.toAnyObject())
            }
            any["feelsLike"] = feelsLikeAnyArr
        }
        if area != nil {
            any["area"] = area
        }
        if !allImages.isEmpty {
            any["allImages"] = allImages
        }

        return any
    }

}
