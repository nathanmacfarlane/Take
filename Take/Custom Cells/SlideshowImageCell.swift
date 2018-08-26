//
//  SlideshowImageCell.swift
//  Take
//
//  Created by Family on 5/21/18.
//  Copyright © 2018 N8. All rights reserved.
//

import PBImageView
import UIKit

class SlideshowImageCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var theImage: UIImageView!
    @IBOutlet private weak var pbImageView: PBImageView!

    func setImage(with newImage: UIImage) {
        self.pbImageView.image = newImage
        self.pbImageView.contentMode = .scaleAspectFill
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(sender:)))
        pbImageView.addGestureRecognizer(longPress)
    }

    @IBAction private func longPress(sender: UIPinchGestureRecognizer) {
        if sender.state == .began {
            UIView.animate(withDuration: 0.2) {
                self.pbImageView.contentMode = .scaleAspectFit
            }
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            UIView.animate(withDuration: 0.2) {
                self.pbImageView.contentMode = .scaleAspectFill
            }
        }
    }

}
