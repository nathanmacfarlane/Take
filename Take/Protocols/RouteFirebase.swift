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

    var images: [String: UIImage] { get }

    func fbLoadImages(size: String, completion: @escaping () -> Void)
    func fbSaveImages(images: [String: UIImage], completion: @escaping () -> Void)
}
