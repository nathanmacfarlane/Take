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
    @IBOutlet private weak var theImage: UIImageView!

    func setImage(with newImage: UIImage) {
        self.theImage.image = newImage
    }

    // MARK: - variables
//    var isZooming: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(sender:)))
        theImage.addGestureRecognizer(longPress)
//        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
//        theImage.addGestureRecognizer(pinch)
    }

    @IBAction private func longPress(sender: UIPinchGestureRecognizer) {
        if sender.state == .began {



//        } else if sender.state == .changed {
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {

        }
    }

//    @IBAction private func pinch(sender: UIPinchGestureRecognizer) {
//
//        if sender.state == .began {
//            let currentScale = self.theImage.frame.width / self.theImage.bounds.size.width
//            let newScale = currentScale * sender.scale
//            if newScale > 1 {
//                self.isZooming = true
//            }
//        } else if sender.state == .changed {
//            guard let view = sender.view else { return }
//            let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX,
//                                      y: sender.location(in: view).y - view.bounds.midY)
//            let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
//                .scaledBy(x: sender.scale, y: sender.scale)
//                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
//            let currentScale = self.theImage.frame.width / self.theImage.bounds.size.width
//            var newScale = currentScale * sender.scale
//            print("new scale: \(newScale)")
//            if newScale <= 1 {
//                newScale = 1
//                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
//                self.theImage.transform = transform
//                toggleStuff(alpha: 1)
//                sender.scale = 1
//            } else {
//                view.transform = transform
//                toggleStuff(alpha: 0)
//                sender.scale = 1
//            }
//        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
//            //            let center = self.bgImageView.center
//            //            UIView.animate(withDuration: 0.3, animations: {
//            //                self.theImage.transform = CGAffineTransform(scaleX: 1, y: 1)
//            //                self.theImage.center = center
//            //            }, completion: { _ in
//            //                self.isZooming = false
//            //            })
//        }
//
//    }

}
