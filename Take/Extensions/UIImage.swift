//
//  UIImave.swift
//  Take
//
//  Created by Family on 5/18/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Firebase
import Foundation
import UIKit

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

    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func saveToFb(route: Route, completion: @escaping (_ url: URL?) -> Void) {
        guard let data = UIImageJPEGRepresentation(self, 0.1) else { return }
        let imageRef = Storage.storage().reference().child("Routes/\(route.getId())")
        let imageId = UUID().uuidString
        _ = imageRef.child(imageId).putData(data, metadata: nil) { metadata, _ in
            guard metadata != nil else {
                return
            }
            imageRef.child(imageId).downloadURL { url, _ in
                completion(url)
            }

        }
    }

}
