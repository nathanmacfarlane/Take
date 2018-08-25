//
//  UIImave.swift
//  Take
//
//  Created by Family on 5/18/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension UIImage {
    convenience init?(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let currentContext = UIGraphicsGetCurrentContext() else { return nil }
        view.layer.render(in: currentContext)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let theImage = image?.cgImage else { return nil }
        self.init(cgImage: theImage)
    }

    func overlayWith(image: UIImage, posX: CGFloat, posY: CGFloat) -> UIImage {
        let newWidth = size.width < posX + image.size.width ? posX + image.size.width : size.width
        let newHeight = size.height < posY + image.size.height ? posY + image.size.height : size.height
        let newSize = CGSize(width: newWidth, height: newHeight)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        image.draw(in: CGRect(origin: CGPoint(x: posX, y: posY), size: image.size))
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()

        return newImage
    }

    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func resizedToKB(numKB: Double) -> UIImage? {
        guard let imageData = UIImagePNGRepresentation(self) else { return nil }

        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / numKB // ! Or devide for 1024 if you need KB but not kB

        while imageSizeKB > numKB { // ! Or use 1024 if you need KB but not kB
            guard let resizedImage = resizingImage.resized(withPercentage: 0.9),
                let imageData = UIImagePNGRepresentation(resizedImage)
                else { return nil }

            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / numKB // ! Or devide for 1024 if you need KB but not kB
        }

        return resizingImage
    }

    func addTextToImage(drawText: String, atPoint: CGPoint) -> UIImage {

        // Setup the font specific variables
        let textColor = UIColor.white
        guard let textFont = UIFont(name: "Helvetica Bold", size: 200) else { return UIImage() }

        // Setup the image context using the passed image
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)

        // Setup the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            kCTFontAttributeName: textFont,
            kCTForegroundColorAttributeName: textColor
        ]

        // Put the image into a rectangle as large as the original image
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))

        // Create a point within the space that is as bit as the image
        let rect = CGRect(x: atPoint.x, y: atPoint.y, width: self.size.width, height: self.size.height)

        // Draw the text into an image
        drawText.draw(in: rect, withAttributes: textFontAttributes as [NSAttributedStringKey: Any])

        // Create a new image out of the images we have created
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }

        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        return newImage
    }

    func textToImage(drawText text: String, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.white
        guard let textFont = UIFont(name: "Helvetica Bold", size: 50) else { return UIImage() }

        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)

        let textFontAttributes = [
            NSAttributedStringKey.font: textFont,
            NSAttributedStringKey.foregroundColor: textColor
        ] as [NSAttributedStringKey: Any]
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))

        let rect = CGRect(origin: point, size: self.size)
        text.draw(in: rect, withAttributes: textFontAttributes)

        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()

        return newImage
    }

    func saveToFb(route: Route) {
        let imageRef = Storage.storage().reference().child("Routes/\(route.id)")
        guard let theImage = self.resizedToKB(numKB: 1024) else { return }
        let imageId = UUID().uuidString
        guard let data = UIImagePNGRepresentation(theImage) as NSData? else { return }
        _ = imageRef.child("\(imageId)-large.png").putData(data as Data, metadata: nil) { metadata, _ in
            guard metadata != nil else {
                return
            }
            imageRef.child("\(imageId)-large.png").downloadURL { url, _ in
                guard let downloadURL = url else { return }
                route.ref?.child("imageUrls").updateChildValues([imageId: downloadURL])
            }

        }

//        var imageUrls: [String: String] = [:]
//        let sizes: [[String: Any]] = [["sizeString": "Thumbnail", "sizeInt": 400.0], ["sizeString": "Large", "sizeInt": 2048.0]]
//        for i in 0...1 {
//            let imageId = UUID().uuidString
//            guard let sizeString = sizes[i]["sizeString"] as? String,
//                let sizeInt = sizes[i]["sizeInt"] as? Double,
//                let theImage = self.resizedToKB(numKB: sizeInt)
//                else { return }
//            guard let data = UIImagePNGRepresentation(theImage) as NSData? else { return }
//            _ = imageRef.child("\(imageId)-\(sizeString).png").putData(data as Data, metadata: nil) { metadata, _ in
//                guard metadata != nil else {
//                    return
//                }
//                imageRef.child("\(imageId)-\(sizeString).png").downloadURL { url, _ in
//                    guard let downloadURL = url else {
//                        return
//                    }
//                    imageUrls[sizeString] = "\(downloadURL)"
//                    if imageUrls.keys.count == 2 {
//                        route.ref?.child("imageUrls").updateChildValues([imageId: imageUrls])
//                    }
//                }
//
//            }
//        }
    }

}
