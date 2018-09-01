//
//  RouteFirestoreExtension.swift
//  Take
//
//  Created by Nathan Macfarlane on 8/31/18.
//  Copyright © 2018 N8. All rights reserved.
//

import FirebaseFirestore
import FirebaseStorage
import Foundation
import UIKit

extension Route: RouteFirestore {
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

    func fsSaveAr(imageId: String, bgImage: UIImage, dgImage: UIImage) {
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
}
