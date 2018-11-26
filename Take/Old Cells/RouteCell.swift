//
//  SearchResultCell.swift
//  Take
//
//  Created by Family on 4/26/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import UIKit

class RouteCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var bgView: UIView!
    @IBOutlet private weak var theImageView: UIImageView!
    @IBOutlet private weak var locationImageView: UIImageView!
    @IBOutlet private weak var areaButton: UIButton!
    @IBOutlet private weak var difficultyLabel: UILabel!
    @IBOutlet private weak var typesLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLabel.textColor = .white
        self.difficultyLabel.textColor = .white
        self.typesLabel.textColor = .white
        self.theImageView.roundImage(portion: 2)
        self.theImageView.addBorder(color: .white, width: 1)
        self.locationImageView.roundImage(portion: 2)
        self.locationImageView.addBorder(color: .white, width: 1)
        // background
        self.backgroundColor = UIColor.clear
        self.bgView.backgroundColor = UIColor.black
        self.bgView.layer.cornerRadius = 10
        self.bgView.clipsToBounds = true
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }

    func setAreaAbrev(with newText: String) {
        self.areaButton.addAbrevText(text: newText)
    }
    
    func setAreaButtonTitle() {
        self.areaButton.setTitle("", for: .normal)
    }

    func setImage(with newImage: UIImage) {
        self.theImageView.image = newImage
    }

    func clearImage() {
        self.theImageView.image = nil
    }

    func getImage() -> UIImage? {
        return self.theImageView.image
    }

    func setAreaImage(with newImage: UIImage) {
        self.locationImageView.image = newImage
    }

    func setLocationImage(with newImage: UIImage) {
        self.locationImageView.image = newImage
    }

    func setLabels(name: String, types: String, difficulty: String) {
        self.nameLabel.text = name
        self.typesLabel.text = types
        self.difficultyLabel.text = difficulty
    }

}
