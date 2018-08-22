//
//  AreaExpandableCell.swift
//  Take
//
//  Created by Nathan Macfarlane on 8/11/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit

class AreaExpandableCell: UITableViewCell {

    @IBOutlet private weak var bgView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!

    func setTitleLabel(with newString: String) {
        self.titleLabel.text = newString
    }
    func setTitleColor(with color: UIColor) {
        self.titleLabel.textColor = color
    }
    func roundBG() {
        self.bgView.roundView(portion: 2)
    }

    //    override var frame: CGRect {
    //        get {
    //            return super.frame
    //        }
    //        set (newFrame) {
    //            var frame =  newFrame
    //            frame.origin.y += 4
    //            frame.size.height -= 2 * 5
    //            super.frame = frame
    //        }
    //    }
}
