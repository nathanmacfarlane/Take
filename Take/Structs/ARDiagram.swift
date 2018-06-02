//
//  ARImage.swift
//  Take
//
//  Created by Family on 5/20/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import UIKit

struct ARDiagram {
    var bgImage:    UIImage
    var diagram:    UIImage?
    
    init(bgImage: UIImage) {
        self.bgImage    = bgImage
        self.diagram    = nil
    }
    
    init(bgImage: UIImage, diagram: UIImage) {
        self.bgImage = bgImage
        self.diagram = diagram
    }
}
