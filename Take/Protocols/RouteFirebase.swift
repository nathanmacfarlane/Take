//
//  TestProtocol.swift
//  Take
//
//  Created by Nathan Macfarlane on 8/23/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Firebase
import Foundation
import UIKit

protocol RouteFirestore: class {
    func fsLoadFirstImage(completion: @escaping (_ key: String?, _ image: UIImage?) -> Void)
    func fsLoadImages(completion: @escaping (_ images: [String: UIImage]) -> Void)
    func fsSaveAr(imageId: String, bgImage: UIImage, dgImage: UIImage)
    func fsLoadAR(completion: @escaping (_ ar: [String: [UIImage]]) -> Void)
}
