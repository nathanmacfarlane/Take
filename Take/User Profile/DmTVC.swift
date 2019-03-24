import UIKit

class DmTVC: UITableViewCell {
    
//    var routeViewModel: RouteViewModel!
    
    var nameLabel: UILabel!
    var messageLabel: UILabel!
    
    var profPic: TypeButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = UISettings.shared.colorScheme.backgroundCell
        self.selectionStyle = .default
        
        nameLabel = UILabel()
        nameLabel.textColor = UISettings.shared.colorScheme.textPrimary
        nameLabel.font = UIFont(name: "Avenir-Black", size: 20)
        
        messageLabel = UILabel()
        messageLabel.textColor = UISettings.shared.colorScheme.textSecondary
        messageLabel.font = UIFont(name: "Avenir", size: 16)
        
        
        profPic = TypeButton()
        profPic.addBorder(width: 1)
        profPic.layer.cornerRadius = 8
        profPic.clipsToBounds = true
        profPic.contentMode = .scaleAspectFit
        
        self.addSubview(profPic)
        self.addSubview(nameLabel)
        self.addSubview(messageLabel)
        
        profPic.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: profPic, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: profPic, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: profPic, attribute: .width, relatedBy: .equal, toItem: profPic, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: profPic, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 2 / 3, constant: 0).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: profPic, attribute: .trailing, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: profPic, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -10).isActive = true
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: messageLabel, attribute: .leading, relatedBy: .equal, toItem: nameLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: messageLabel, attribute: .trailing, relatedBy: .equal, toItem: nameLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: messageLabel, attribute: .bottom, relatedBy: .equal, toItem: profPic, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: messageLabel, attribute: .height, relatedBy: .equal, toItem: nameLabel, attribute: .height, multiplier: 1, constant: 0).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
