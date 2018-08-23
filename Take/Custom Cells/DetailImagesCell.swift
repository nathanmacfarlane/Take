//
//  DetailImages.swift
//  Take
//
//  Created by Family on 5/4/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit

class DetailImagesCell: UICollectionViewCell {
    @IBOutlet private weak var theImage: UIImageView!

    func setImage(with newImage: UIImage) {
        self.theImage.image = newImage
    }
}
