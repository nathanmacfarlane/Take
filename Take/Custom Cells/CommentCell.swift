//
//  CommentCell.swift
//  Take
//
//  Created by Family on 5/7/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet private weak var bgView: UILabel!

    func setNameLabel(with newText: String) {
        self.nameLabel.text = newText
    }
    func setDateLabel(with newText: String) {
        self.dateLabel.text = newText
    }
    func setCommentLabel(with newText: String) {
        self.commentLabel.text = newText
    }
    func setUserImage(with newImage: UIImage) {
        self.userImage.image = newImage
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userImage.roundImage(portion: 2)
        self.userImage.addBorder(color: UIColor(hexString: "#2A313B"), width: 2)
        self.bgView.layer.cornerRadius = 10
    }

}
