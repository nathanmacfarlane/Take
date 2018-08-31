//
//  DetailImages.swift
//  Take
//
//  Created by Family on 5/4/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit

class DetailImagesCell: UICollectionViewCell {
    @IBOutlet private weak var bgImageView: UIImageView!
    @IBOutlet private weak var dgImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
    }

    func setImage(with newImage: UIImage) {
        self.bgImageView.image = newImage
    }
    func setDgImage(with newDiagram: UIImage) {
        self.dgImageView.image = newDiagram
    }
    func clearDgImage() {
        self.dgImageView.image = nil
    }
}
