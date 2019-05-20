import Foundation
import UIKit

class MapPreviewView: UIView {

    var nameLabel: UILabel!
    var movement: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }

    func initViews() {
        backgroundColor = .white

        let line = UILabel()
        line.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.7764705882, blue: 0.7764705882, alpha: 1)

        let lineBg = UILabel()
        lineBg.isUserInteractionEnabled = true
        let drag = UIPanGestureRecognizer(target: self, action: #selector(drugLine))
        lineBg.addGestureRecognizer(drag)

        nameLabel = LabelAvenir(size: 25, type: .Black, color: #colorLiteral(red: 0.2470588235, green: 0.2470588235, blue: 0.2509803922, alpha: 1))

        addSubview(line)
        addSubview(lineBg)
        addSubview(nameLabel)

        line.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: line, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: line, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: line, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 4).isActive = true
        NSLayoutConstraint(item: line, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true

        lineBg.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: lineBg, attribute: .bottom, relatedBy: .equal, toItem: line, attribute: .bottom, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: lineBg, attribute: .top, relatedBy: .equal, toItem: line, attribute: .top, multiplier: 1, constant: -25).isActive = true
        NSLayoutConstraint(item: lineBg, attribute: .leading, relatedBy: .equal, toItem: line, attribute: .leading, multiplier: 1, constant: -25).isActive = true
        NSLayoutConstraint(item: lineBg, attribute: .trailing, relatedBy: .equal, toItem: line, attribute: .trailing, multiplier: 1, constant: 25).isActive = true

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -25).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
    }

    @objc
    func drugLine(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: self)
        if movement + translation.y >= 0 {
            movement += translation.y
            center = CGPoint(x: center.x, y: center.y + translation.y)
            panGesture.setTranslation(.zero, in: self)
        }

        if panGesture.state == .ended {
            let closest = PreviewSize.large.rawValue - movement
            let large = PreviewSize.large.rawValue - closest
            let medium = PreviewSize.medium.rawValue - closest
            let small = PreviewSize.small.rawValue - closest

            var m = large
            if abs(medium) < abs(large) && abs(medium) < abs(small) {
                m = medium
            } else if abs(small) < abs(medium) && abs(small) < abs(large) {
                m = small
            }

            UIView.animate(withDuration: 0.2) {
                self.center = CGPoint(x: self.center.x, y: self.center.y - m)
                self.movement -= m
            }
        }
    }
}
