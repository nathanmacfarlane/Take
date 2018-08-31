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

protocol RouteFirebase: class {

    func fsLoadFirstImage(completion: @escaping (_ key: String?, _ image: UIImage?) -> Void)
    func fsLoadImages(completion: @escaping (_ images: [String: UIImage]) -> Void)
    func fbSaveImages(images: [String: UIImage], completion: @escaping () -> Void)
    func fsSaveAr(ar: [String: [UIImage]], completion: @escaping () -> Void)
    func fsLoadAR(completion: @escaping (_ ar: [String: [UIImage]]) -> Void)
}
