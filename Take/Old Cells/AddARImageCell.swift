//
//  AddARImageCell.swift
//  Take
//
//  Created by Family on 5/9/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit

class AddARImageCell: UICollectionViewCell {
    @IBOutlet private weak var bgImageView: UIImageView!
    @IBOutlet private weak var diagramImageView: UIImageView!
    var hasImage: Bool = false

    func setImage(bg: UIImage, diagram: UIImage) {
        self.bgImageView.image = bg
        self.diagramImageView.image = diagram
        self.hasImage = true
    }

    func removeImage() {
        self.bgImageView.image = nil
        self.diagramImageView.image = nil
        self.hasImage = false
    }
}
