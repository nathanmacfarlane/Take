//
//  SegueFromRight.swift
//  Take
//
//  Created by Nathan Macfarlane on 8/20/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import UIKit

class SegueFromRight: UIStoryboardSegue {
    override func perform() {
        let src = self.source
        let dst = self.destination

        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width * 2, y: 0) //Double the X-Axis
        UIView.animate(withDuration: 0.35, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { _ in
            src.present(dst, animated: false, completion: nil)
        }
    }
}
