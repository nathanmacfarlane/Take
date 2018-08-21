//
//  AddImageCell.swift
//  Take
//
//  Created by Family on 5/9/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit

class AddImageCell: UICollectionViewCell {
    @IBOutlet private weak var bgImageView: UIImageView!
    var hasImage: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(heldCell(sender:)))
        self.addGestureRecognizer(longPress)

    }

    @objc
    func heldCell(sender: UITapGestureRecognizer) {
        if sender.state == .began && self.hasImage {
            self.removeImage()
        }
    }

    func setImage(image: UIImage) {
        self.bgImageView.image = image
        self.hasImage = true
    }
    func removeImage() {
        self.bgImageView.image = nil
        self.hasImage = false
    }

}
