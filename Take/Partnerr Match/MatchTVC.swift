//
//  MatchTVC.swift
//  Take
//
//  Created by Raquel Bonilla on 4/9/19.
//  Copyright © 2019 N8. All rights reserved.
//

import Foundation
import UIKit

class MatchTVC: UITableViewCell {
    
    var usernameLabel = UILabel()
    let container = UIView()
    var indent = CGFloat(100)
    var profPic: TypeButton!
    var trLabel = UILabel()
    var tradLabel = UILabel()
    var sportLabel = UILabel()
    var boulderLabel = UILabel()

    var widthConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!

//    var bgColor = UISettings.shared.colorScheme.backgroundPrimary

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        setup()
    }

//    convenience init(style: UITableViewCell.CellStyle, bgColor: UIColor, reuseIdentifier: String?) {
//        self.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.bgColor = bgColor
//    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.backgroundColor = UISettings.shared.colorScheme.backgroundCell
        
        
        usernameLabel.textColor = .white
        usernameLabel.font = UIFont(name: "Avenir-Heavy", size: 18)
        
        self.selectionStyle = .none
        
        
        container.backgroundColor = UISettings.shared.colorScheme.backgroundPrimary
        container.isUserInteractionEnabled = false
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 8
        
        profPic = TypeButton()
        profPic.addBorder(width: 1)
        profPic.layer.cornerRadius = 8
        profPic.clipsToBounds = true
        profPic.contentMode = .scaleAspectFit
        profPic.isUserInteractionEnabled = false
        
        let trButton = UIButton()
        trButton.setTitle("TR", for: .normal)
        trButton.setTitleColor(.white, for: .normal)
        trButton.backgroundColor = UIColor(hex: "#0E4343")
        trButton.layer.cornerRadius = 8
        trButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 16)
        trButton.isUserInteractionEnabled = false
        
        trLabel = UILabel()
        trLabel.font = UIFont(name: "Avenir-Heavy", size: 16)
        trLabel.textColor = UISettings.shared.colorScheme.textSecondary
        trLabel.textAlignment = .center
        
        let tradButton = UIButton()
        tradButton.setTitle("T", for: .normal)
        tradButton.setTitleColor(.white, for: .normal)
        tradButton.backgroundColor = UIColor(hex: "#0E4343")
        tradButton.layer.cornerRadius = 8
        tradButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 16)
        tradButton.isUserInteractionEnabled = false
        
        tradLabel = UILabel()
        tradLabel.font = UIFont(name: "Avenir-Heavy", size: 16)
        tradLabel.textColor = UISettings.shared.colorScheme.textSecondary
        tradLabel.textAlignment = .center
        
        let sportButton = UIButton()
        sportButton.setTitle("S", for: .normal)
        sportButton.setTitleColor(.white, for: .normal)
        sportButton.backgroundColor = UIColor(hex: "#0E4343")
        sportButton.layer.cornerRadius = 8
        sportButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 14)
        sportButton.isUserInteractionEnabled = false
        
        sportLabel = UILabel()
        sportLabel.font = UIFont(name: "Avenir-Heavy", size: 14)
        sportLabel.textColor = UISettings.shared.colorScheme.textSecondary
        sportLabel.textAlignment = .center
        
        let boulderButton = UIButton()
        boulderButton.setTitle("B", for: .normal)
        boulderButton.setTitleColor(.white, for: .normal)
        boulderButton.backgroundColor = UIColor(hex: "#0E4343")
        boulderButton.layer.cornerRadius = 8
        boulderButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 14)
        boulderButton.isUserInteractionEnabled = false
        
        boulderLabel = UILabel()
        boulderLabel.font = UIFont(name: "Avenir-Heavy", size: 14)
        boulderLabel.textColor = UISettings.shared.colorScheme.textSecondary
        boulderLabel.textAlignment = .center
        
        
        addSubview(container)
        addSubview(usernameLabel)
        addSubview(profPic)
        addSubview(trButton)
        addSubview(trLabel)
        addSubview(tradButton)
        addSubview(tradLabel)
        addSubview(sportButton)
        addSubview(sportLabel)
        addSubview(boulderButton)
        addSubview(boulderLabel)
        
        profPic.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: profPic, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: profPic, attribute: .centerY, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: profPic, attribute: .width, relatedBy: .equal, toItem: profPic, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: profPic, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 3 / 5, constant: 0).isActive = true
        
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: container, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: container, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        heightConstraint = NSLayoutConstraint(item: container, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: -18)
        widthConstraint = NSLayoutConstraint(item: container, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: -18)
        heightConstraint.isActive = true
        widthConstraint.isActive = true

        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: usernameLabel, attribute: .leading, relatedBy: .equal, toItem: profPic, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: usernameLabel, attribute: .bottom, relatedBy: .equal, toItem: trButton, attribute: .top, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: usernameLabel, attribute: .width, relatedBy: .equal, toItem: container, attribute: .width, multiplier: 2 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: usernameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        trButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: trButton, attribute: .leading, relatedBy: .equal, toItem: usernameLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: trButton, attribute: .centerY, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: trButton, attribute: .width, relatedBy: .equal, toItem: container, attribute: .width, multiplier: 1 / 7, constant: 0).isActive = true
        NSLayoutConstraint(item: trButton, attribute: .height, relatedBy: .equal, toItem: container, attribute: .height, multiplier: 1 / 4, constant: 0).isActive = true
        
        trLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: trLabel, attribute: .centerX, relatedBy: .equal, toItem: trButton, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: trLabel, attribute: .top, relatedBy: .equal, toItem: trButton, attribute: .bottom, multiplier: 1, constant: 3).isActive = true
        NSLayoutConstraint(item: trLabel, attribute: .width, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: trLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        tradButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tradButton, attribute: .leading, relatedBy: .equal, toItem: trButton, attribute: .trailing, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: tradButton, attribute: .centerY, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: tradButton, attribute: .width, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradButton, attribute: .height, relatedBy: .equal, toItem: trButton, attribute: .height, multiplier: 1, constant: 0).isActive = true
        
        tradLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tradLabel, attribute: .centerX, relatedBy: .equal, toItem: tradButton, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradLabel, attribute: .top, relatedBy: .equal, toItem: tradButton, attribute: .bottom, multiplier: 1, constant: 3).isActive = true
        NSLayoutConstraint(item: tradLabel, attribute: .width, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        sportButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: sportButton, attribute: .leading, relatedBy: .equal, toItem: tradButton, attribute: .trailing, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: sportButton, attribute: .centerY, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: sportButton, attribute: .width, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sportButton, attribute: .height, relatedBy: .equal, toItem: trButton, attribute: .height, multiplier: 1, constant: 0).isActive = true
//
        sportLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: sportLabel, attribute: .centerX, relatedBy: .equal, toItem: sportButton, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sportLabel, attribute: .top, relatedBy: .equal, toItem: sportButton, attribute: .bottom, multiplier: 1, constant: 3).isActive = true
        NSLayoutConstraint(item: sportLabel, attribute: .width, relatedBy: .equal, toItem: sportButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sportLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
//
        boulderButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: boulderButton, attribute: .leading, relatedBy: .equal, toItem: sportButton, attribute: .trailing, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: boulderButton, attribute: .centerY, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: boulderButton, attribute: .width, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: boulderButton, attribute: .height, relatedBy: .equal, toItem: trButton, attribute: .height, multiplier: 1, constant: 0).isActive = true
//
        boulderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: boulderLabel, attribute: .centerX, relatedBy: .equal, toItem: boulderButton, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: boulderLabel, attribute: .top, relatedBy: .equal, toItem: boulderButton, attribute: .bottom, multiplier: 1, constant: 3).isActive = true
        NSLayoutConstraint(item: boulderLabel, attribute: .width, relatedBy: .equal, toItem: boulderButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: boulderLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
    }
    
}
