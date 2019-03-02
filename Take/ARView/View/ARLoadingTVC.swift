import UIKit

class ARLoadingTVC: UITableViewCell {

    private var bgView: UILabel!
    var nameLabel: UILabel!
    var numberDiagramsLabel: UILabel!
    var progressBar: UIProgressView!
    var totalCount: Float?
    var currentCount: Float = 0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .clear

        nameLabel = UILabel()
        nameLabel.textColor = UIColor(hex: "#202226")
        nameLabel.font = UIFont(name: "Avenir-Medium", size: 17)

        numberDiagramsLabel = UILabel()
        numberDiagramsLabel.textColor = UIColor(hex: "#202226")
        numberDiagramsLabel.font = UIFont(name: "Avenir-Medium", size: 17)
        numberDiagramsLabel.textAlignment = .right

        progressBar = UIProgressView(progressViewStyle: .bar)
        progressBar.setProgress(0.0, animated: true)
        progressBar.trackTintColor = UIColor(named: "#202226")
        progressBar.tintColor = UIColor(named: "PinkAccentDark")

        bgView = UILabel()
        bgView.backgroundColor = .white

        addSubview(bgView)
        addSubview(nameLabel)
        addSubview(numberDiagramsLabel)
        addSubview(progressBar)

        let padding: CGFloat = 30.0

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: progressBar, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .trailing, relatedBy: .equal, toItem: numberDiagramsLabel, attribute: .leading, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .bottom, relatedBy: .equal, toItem: progressBar, attribute: .top, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: bgView, attribute: .top, multiplier: 1, constant: 10).isActive = true

        numberDiagramsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: numberDiagramsLabel, attribute: .trailing, relatedBy: .equal, toItem: progressBar, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: numberDiagramsLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: numberDiagramsLabel, attribute: .bottom, relatedBy: .equal, toItem: progressBar, attribute: .top, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: numberDiagramsLabel, attribute: .top, relatedBy: .equal, toItem: bgView, attribute: .top, multiplier: 1, constant: 10).isActive = true

        progressBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: progressBar, attribute: .leading, relatedBy: .equal, toItem: bgView, attribute: .leading, multiplier: 1, constant: padding).isActive = true
        NSLayoutConstraint(item: progressBar, attribute: .trailing, relatedBy: .equal, toItem: bgView, attribute: .trailing, multiplier: 1, constant: -padding).isActive = true
        NSLayoutConstraint(item: progressBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 2).isActive = true
        NSLayoutConstraint(item: progressBar, attribute: .bottom, relatedBy: .equal, toItem: bgView, attribute: .bottom, multiplier: 1, constant: -20).isActive = true

        bgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: bgView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bgView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bgView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: bgView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10).isActive = true

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.clipsToBounds = true
        bgView.layer.cornerRadius = 10
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
