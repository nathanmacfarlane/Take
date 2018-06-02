//
//  SlideshowDiagramCell.swift
//  Take
//
//  Created by Family on 5/22/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit

class SlideshowDiagramCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var theImage:        UIImageView!
    @IBOutlet weak var diagramImage:    UIImageView!
    @IBOutlet weak var bgImageView:     UIImageView!
    
    // MARK: - variables
    var isZooming : Bool!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
        diagramImage.addGestureRecognizer(pinch)
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.bgImageView.addSubview(blurEffectView)
    }
    
    // Actions
    
    @IBAction func pinch(sender: UIPinchGestureRecognizer) {
        
        if sender.state == .began {
            let currentScale = self.diagramImage.frame.width / self.diagramImage.bounds.size.width
            let newScale = currentScale*sender.scale
            if newScale > 1 {
                self.isZooming = true
            }
        } else if sender.state == .changed {
            guard let view = sender.view else {return}
            let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX,
                                      y: sender.location(in: view).y - view.bounds.midY)
            let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: sender.scale, y: sender.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            let currentScale = self.diagramImage.frame.width / self.theImage.bounds.size.width
            var newScale = currentScale*sender.scale
            if newScale < 1 {
                newScale = 1
                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                self.diagramImage.transform = transform
                self.theImage.transform = transform
                sender.scale = 1
            }else {
                view.transform = transform
                self.theImage.transform = transform
                sender.scale = 1
            }
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            let center = self.bgImageView.center
            UIView.animate(withDuration: 0.3, animations: {
                self.diagramImage.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.diagramImage.center = center
                self.theImage.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.theImage.center = center
            }, completion: { _ in
                self.isZooming = false
            })
        }
        
    }
    
}
