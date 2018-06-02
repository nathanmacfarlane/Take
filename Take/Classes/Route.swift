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

class RouteService: Codable {
    var routes : [Route]!
}

class Route : /*NSObject, NSCoding, */Comparable, Codable {
    
    // MARK: - properties
    var name        : String
    var location    : CLLocation?
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
    var images      : [UIImage]?
    var ardiagrams  : [ARDiagram]?
    var area        : String?
    var allImages   : [String]?
    var ref         : DatabaseReference?
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case types = "type"
        case localDesc = "location"
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
    
    
//    // MARK: - NSObject
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(self.name,        forKey: "name")
//        aCoder.encode(self.location,    forKey: "location")
//        aCoder.encode(self.photoURL,    forKey: "photoURL")
//        aCoder.encode(self.id,          forKey: "id")
//        aCoder.encode(self.types,       forKey: "types")
//        aCoder.encode(self.difficulty,  forKey: "rating")
//        aCoder.encode(self.stars,       forKey: "stars")
//        aCoder.encode(self.pitches,     forKey: "pitches")
//        aCoder.encode(self.localDesc,   forKey: "localDesc")
////        aCoder.encode(self.ref,         forKey: "ref")
//    }

    
    
//    required init?(coder aDecoder: NSCoder) {
//        self.name =                     aDecoder.decodeObject(forKey: "name")       as! String
//        self.location =                 aDecoder.decodeObject(forKey: "location")   as? CLLocation
//        self.photoURL =                 aDecoder.decodeObject(forKey: "photoURL")   as? String
//        self.id =                       aDecoder.decodeObject(forKey: "id")         as! String
//        self.types =                    aDecoder.decodeObject(forKey: "types")      as? String
//        self.difficulty =               aDecoder.decodeObject(forKey: "rating")     as? Rating
//        self.stars =                    aDecoder.decodeObject(forKey: "stars")      as? [Star]
//        self.pitches =                  aDecoder.decodeObject(forKey: "pitches")    as? Int
//        self.localDesc =                aDecoder.decodeObject(forKey: "localDesc")  as? [String]
//        self.comments =                 aDecoder.decodeObject(forKey: "comments")   as? [Comment]
//        self.info =                     aDecoder.decodeObject(forKey: "info")       as? String
//        self.feelsLike =                aDecoder.decodeObject(forKey: "feelsLike")  as? [Rating]
//        self.images =                   aDecoder.decodeObject(forKey: "images")     as? [UIImage]
//        self.ardiagrams =               aDecoder.decodeObject(forKey: "ardiagrams") as? [ARDiagram]
//        self.area =                     aDecoder.decodeObject(forKey: "area")       as? String
//        self.allImages =                aDecoder.decodeObject(forKey: "allImages")  as? [String]
//        self.ref =                      aDecoder.decodeObject(forKey: "ref")        as? DatabaseReference
//    }
    
    
    // MARK: - Firebase
    func getImagesFromFirebase(completion: @escaping () -> Void) {
        self.images = []
        for _ in self.allImages ?? [] {
            self.images?.append(UIImage())
        }
        var count = 0
        for imgURL in self.allImages ?? [] {
            URLSession.shared.dataTask(with: URL(string: imgURL)!) { data, response, error in
                self.images?.append(UIImage(data: data!)!)
                count += 1
                if count == self.allImages?.count {
                    completion()
                }
            }.resume()
        }
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
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: imageURL)
        storageRef.delete { error in
            if let error = error {
                print(error)
            } else {
                completion()
            }
        }
        self.allImages?.remove(at: indexOfDeletion)
        self.saveToFirebase()
    }
    func saveToFirebase(newImages: [UIImage]) {
        saveToFirebase()
        self.saveImagesToFirebase(newImages: newImages)
    }
    func addImageURLToFirebase(imageURL: String) {
        if self.allImages == nil {
            self.allImages = [imageURL]
        } else {
            self.allImages?.append(imageURL)
        }
        self.ref?.child("allImages").setValue(self.allImages)
    }
    func saveImagesToFirebase(newImages: [UIImage]) {
        let storeRef = Storage.storage().reference()
        let imageRef = storeRef.child("routes/\(self.id)")
        for img in newImages {
            let data = UIImagePNGRepresentation(img.resizedToKB(numKB: 2048)!) as NSData?
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
        if location != nil {
            a["location"] = [self.location!.coordinate.latitude, self.location!.coordinate.longitude]
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
    
    // MARK: - constructor
    init (Name: String, Location: CLLocation?, PhotoURL: String?, Id: String, Types: String?, Difficulty: String?, Stars: [Star]?, Pitches: Int?, LocalDescrip: [String]?, Info: String?, FeelsRating: [Rating]?, Comments: [Comment]?, Images: [UIImage]?, ARDiagrams: [ARDiagram]?) {
        name        = Name
        location    = Location
        photoURL    = PhotoURL
        id          = Int(Id)!
        types       = Types
        difficulty  = Rating(desc: Difficulty!)
        stars       = Stars
        pitches     = Pitches
        localDesc   = LocalDescrip
        comments    = Comments
        info        = Info
        feelsLike   = FeelsRating
        images      = Images
        ardiagrams  = ARDiagrams
        area        = self.localDesc?.dropLast(2).last
        ref         = nil
    }
    
     init(snapshot: DataSnapshot) {
        id          = Int(snapshot.key)!
        let snapval = snapshot.value            as! [String : AnyObject]
        name        = snapval["name"]           as! String
        if let tempLoc = snapval["location"]       as? [Double] {
            location = CLLocation(latitude: tempLoc[0], longitude: tempLoc[1])
        } else {
            location = nil
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
        allImages   = snapval["allImages"]      as? [String]
        self.ref    = snapshot.ref
     }
    
}
