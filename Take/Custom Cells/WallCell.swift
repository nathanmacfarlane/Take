//
//  WallCell.swift
//  Take
//
//  Created by Nathan Macfarlane on 8/7/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit

class WallCell: UITableViewCell {

    @IBOutlet private weak var bgView: UIView!
    @IBOutlet private weak var bgImage: UIImageView!
    @IBOutlet private weak var wallLabel: UILabel!

    func setBgImage(with newImage: UIImage) {
        self.bgImage.image = newImage
    }

    func setWallLabel(with newText: String) {
        self.wallLabel.text = newText
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 10
        self.bgView.clipsToBounds = true
    }

}
