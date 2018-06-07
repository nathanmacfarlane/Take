//
//  ROUTE.swift
//  Take
//
//  Created by Family on 4/26/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import FirebaseDatabase
import FirebaseStorage
import GeoFire

class RouteService: Codable {
    var routes : [Route]!
}

class Route : NSObject, Comparable, Codable, MKAnnotation {
    
    // MARK: - properties
    var name        : String
//    var location    : CLLocation?
    var photoURL    : String?
    var id          : Int
    var types       : String? // TR (Top Rope), Sport, and Trad, Boulder
    var difficulty  : Rating?
    var stars       : [Star]?
    var pitches     : Int?
    var localDesc   : [String]?
    var comments    : [Comment]?
    var info        : String?
    var feelsLike   : [Rating]?
    var images      : [String : UIImage]?
    var ardiagrams  : [ARDiagram]?
    var area        : String?
    var ref         : DatabaseReference?
    var latitude    : Double?
    var longitude   : Double?
    
    //MKAnnotation
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
    }
    var title: String? {
        return self.name
    }
    var subtitle: String? {
        return self.difficulty?.description
    }
    
    var location    : CLLocation? {
        if latitude == nil || longitude == nil {
            return nil
        }
        return CLLocation(latitude: latitude!, longitude: longitude!)
    }
    
    //private stuff
    private var allImages   : [String : String]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case types = "type"
        case localDesc = "location"
        case latitude
        case longitude
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
        geoFire.setLocation(CLLocation(latitude: self.latitude!, longitude: self.longitude!), forKey: "\(self.id)") { (error) in
            if (error != nil) {
                print("An error occured: \(String(describing: error))")
            } else {
                print("Saved location successfully!")
            }
        }
    }
    
    // MARK: - Firebase
    func getImagesFromFirebase(completion: @escaping () -> Void) {
        self.images = [:]
        var count = 0
        for imgURL in self.allImages ?? [:] {
            URLSession.shared.dataTask(with: URL(string: imgURL.value)!) { data, response, error in
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
        URLSession.shared.dataTask(with: URL(string: firstImageKey)!) { data, response, error in
            completion(UIImage(data: data!))
        }.resume()
    }
    private func assignArea() {
        if self.localDesc!.count >= 3 {
            self.area = self.localDesc!.dropLast(2).last
        } else if self.localDesc!.count >= 1 {
            self.area = self.localDesc!.last
        }
    }
    private func saveToFirebase() {
        if self.ref == nil {
            if self.localDesc != nil {
                assignArea()
                let areaRef = Database.database().reference()
                var strToAppend = "areas"
                for area in self.localDesc! {
                    strToAppend.append("/\(area)")
                    areaRef.child(strToAppend).updateChildValues(["\(self.id)": "\(self.id)"])
                }
            }
            let ref = Database.database().reference().child("routes/\(self.id)")
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
    }
    func saveImagesToFirebase(newImagesWithKeys: [String: UIImage]) {
        let storeRef = Storage.storage().reference()
        let imageRef = storeRef.child("routes/\(self.id)")
        let keys = Array(newImagesWithKeys.keys)
        for imageKey in keys {
            let data = UIImagePNGRepresentation(newImagesWithKeys[imageKey]!.resizedToKB(numKB: 1024)!) as NSData?
            let imageID = UUID().uuidString
            //save to firebase
            _ = imageRef.child("\(imageID).png").putData(data! as Data, metadata: nil, completion: { (metadata, error) in
                
                guard metadata != nil else {
                    print("oh shoot... error occured: \(String(describing: error))")
                    return
                }
                imageRef.child("\(imageID).png").downloadURL { (url, error) in
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
    
    //MARK: - equatable
    static func == (lhs: Route, rhs: Route) -> Bool {
        return lhs.id == rhs.id
    }
    //MARK: - comparable
    static func < (lhs: Route, rhs: Route) -> Bool {
        /* TODO */
        return true
    }
    
    // MARK: - functions
    func averageRating() -> String? {
        var sum : Int = 0
        if feelsLike == nil {
            return nil
        }
        for rating in feelsLike! {
            sum += rating.intDiff
        }
        let avg = sum/feelsLike!.count
        if feelsLike!.first?.type == .boulder {
            return "V\(avg)"
        } else {
            return "5.\(avg)"
        }
    }
    func averageStar() -> Int {
        if stars == nil {
            return 0
        }
        var sum : Double = 0
        for star in stars! {
            sum += star.star
        }
        return Int(sum)/(stars!.count)
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
        return "'\(name)'; \(difficulty!)"
    }
    func toAnyObject() -> Any {
        var a : [String : Any] = [:]
        a["name"] = name
//        if location != nil {
//            a["location"] = [self.location!.coordinate.latitude, self.location!.coordinate.longitude]
//        }
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
        if difficulty != nil {
            a["difficulty"] = difficulty!.toAnyObject()
        }
        if stars != nil {
            var starsAnyArr : [Any] = []
            for star in stars! {
                starsAnyArr.append(star.toAnyObject())
            }
            a["stars"] = starsAnyArr
        }
        if pitches != nil {
            a["pitches"] = pitches
        }
        if localDesc != nil {
            a["localDesc"] = localDesc
        }
        if comments != nil {
            var commentsAnyArr : [Any] = []
            for comment in comments! {
                commentsAnyArr.append(comment.toAnyObject())
            }
            a["comments"] = commentsAnyArr
        }
        if info != nil {
            a["info"] = info
        }
        if feelsLike != nil {
            var feelsLikeAnyArr : [Any] = []
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
    
    // MARK: - Inits
    init(name: String, id: Int, lat: Double, long: Double) {
        self.name       = name
        self.id         = id
        self.latitude   = lat
        self.longitude  = long
    }
    init(snapshot: DataSnapshot) {
        id          = Int(snapshot.key)!
        let snapval = snapshot.value            as! [String : AnyObject]
        name        = snapval["name"]           as! String
        if let tempLoc = snapval["location"]       as? [Double] {
            latitude = tempLoc[0]
            longitude = tempLoc[1]
        }
        photoURL    = snapval["photoURL"]       as? String
        types       = snapval["types"]          as? String
        if let tempDiff = snapval["difficulty"] as? [String: Any] {
            difficulty = Rating(anyObject: tempDiff)
        }
        if let tempStars = snapval["stars"]     as? [[String: Any]] {
            for tempStar in tempStars {
                stars?.append(Star(anyObject: tempStar))
            }
        }
        pitches     = snapval["pitches"]        as? Int
        localDesc   = snapval["localDesc"]      as? [String]
        if let tempComments = snapval["comments"] as? [[String: Any]] {
            for tempComment in tempComments {
                comments?.append(Comment(anyObject: tempComment))
            }
        }
        info        = snapval["info"]           as? String
        if let tempFeelsLike = snapval["feelsLike"] as? [[String: Any]] {
            for tempFeels in tempFeelsLike {
                feelsLike?.append(Rating(anyObject: tempFeels))
            }
        }
        area        = snapval["area"]           as? String
        allImages   = snapval["allImages"]      as? [String : String]
        self.ref    = snapshot.ref
     }
    
}
