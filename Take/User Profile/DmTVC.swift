import UIKit

class DmTVC: UITableViewCell {
    
//    var routeViewModel: RouteViewModel!
    
    var nameLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor(named: "BluePrimary")
        
        nameLabel = UILabel()
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: "Avenir-Black", size: 20)
        
        self.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        let nameLabelLeadingConst = NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let nameLabelTrailingConst = NSLayoutConstraint(item: nameLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let nameLabelBottomConst = NSLayoutConstraint(item: nameLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 5)
        NSLayoutConstraint.activate([nameLabelLeadingConst, nameLabelTrailingConst, nameLabelBottomConst])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
