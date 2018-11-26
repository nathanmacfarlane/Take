//
//  CityCell.swift
//  Take
//
//  Created by Nathan Macfarlane on 8/8/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {

    @IBOutlet private weak var bgImage: UIImageView!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var bgView: UIView!

    func setCityLabel(with newText: String) {
        self.cityLabel.text = newText
    }

    func setBgImage(with newImage: UIImage) {
        self.bgImage.image = newImage
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 10
        self.bgView.clipsToBounds = true
    }

}
