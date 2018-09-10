//
//  SlideshowImageCell.swift
//  Take
//
//  Created by Family on 5/21/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit

class SlideshowImageCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var dgImageView: UIImageView!
    @IBOutlet private weak var bgImageView: UIImageView!

    func setImage(with newImage: UIImage) {
        self.bgImageView.image = newImage
    }

    func setDiagram(with newDiagram: UIImage) {
        self.dgImageView.image = newDiagram
    }

    override func awakeFromNib() {
        super.awakeFromNib()
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(sender:)))
//        dgPbImageView.addGestureRecognizer(longPress)
    }

//    @IBAction private func longPress(sender: UIPinchGestureRecognizer) {
//        if sender.state == .began {
//            UIView.animate(withDuration: 0.2) {
//                self.dgPbImageView.alpha = 0
//                self.bgPbImageView.contentMode = .scaleAspectFit
//            }
//        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
//            UIView.animate(withDuration: 0.2) {
//                self.dgPbImageView.alpha = 1
//                self.bgPbImageView.contentMode = .scaleAspectFill
//            }
//        }
//    }

}
