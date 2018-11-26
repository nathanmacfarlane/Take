//
//  AreaCell.swift
//  Take
//
//  Created by Nathan Macfarlane on 8/8/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit

class AreaCell: UITableViewCell {

    @IBOutlet private weak var areaLabel: UILabel!
    @IBOutlet private weak var bgImage: UIImageView!
    @IBOutlet private weak var bgView: UIView!

    func setAreaLabel(with newText: String) {
        self.areaLabel.text = newText
    }

    func setBgImage(with newImage: UIImage) {
        self.bgImage.image = newImage
    }

    func getImage() -> UIImage? {
        return bgImage.image
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 10
        self.bgView.clipsToBounds = true
    }

}
