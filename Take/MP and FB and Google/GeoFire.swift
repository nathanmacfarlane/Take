//
//  GeoFire.swift
//  Take
//
//  Created by Nathan Macfarlane on 6/6/18.
//  Copyright © 2018 N8. All rights reserved.
//

import FirebaseDatabase
import Foundation
import GeoFire
import MapKit

func getIdsFromGeoFire(for key: String, from region: MKCoordinateRegion, completion: @escaping (_ IDs: [String: CLLocation]) -> Void) {
    let DBRef = Database.database().reference()
    let geofire = GeoFire(firebaseRef: DBRef.child(key))
    var routeIDs: [String: CLLocation] = [:]

    let regionQuery = geofire.query(with: region)
    regionQuery.observe(.keyEntered) { key, location in
        routeIDs[key] = location
    }
    regionQuery.observeReady {
        completion(routeIDs)
    }
}

//func getAreaFromGeoFire(for key: String, from center: CLLocation, with radius: Double, completion: @escaping (_ IDs: [String : CLLocation])->()) {
//    let DBRef = Database.database().reference()
//    let geoFire = GeoFire(firebaseRef: DBRef.child(key))
//
//    let circleQuery = geoFire.query(at: center, withRadius: radius)
//    circleQuery.observe(.keyEntered, with: { (key, location) in
//        print("snapshot: \(key), \(location)")
//        completion([:])
//        let userRef = DBRef.child(key)
//        userRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
//            print("snapshot: \(snapshot)")
//            completion([:])
//        })
//    })
//
//}

//
//import FirebaseStorage
//
//func saveImage() {
//    let storeRef = Storage.storage().reference().child("whatever_path_you_want")
//
//    // get image or could get from picker view
//    let myImage = UIImage(named: "image.png")!
//    // convert to data
//    let data = UIImagePNGRepresentation(myImage) as NSData?
//    //give your image a name
//    let imageName = "myImage01.png"
//
//    //save image to storage
//    storeRef.child(imageName).putData(data! as Data, metadata: nil, completion: { (metadata, error) in
//        guard metadata != nil else {
//            print("oh shoot... error occured: \(String(describing: error))")
//            return
//        }
//        //get download url from that save to storage
//        storeRef.child(imageName).downloadURL { (url, error) in
//            guard let downloadURL = url else {
//                print("error occured: \(String(describing: error))")
//                return
//            }
//            //downloadURL is your url so once you have that, you might want to store it in your database so that next time you need to download the image, you can use this URL
//            print("downloadURL: \(downloadURL)")
//        }
//
//    })
//}
