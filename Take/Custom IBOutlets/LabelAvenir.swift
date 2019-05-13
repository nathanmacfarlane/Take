import Foundation
import UIKit

enum AvenirFont: String {
    case Black = "-Black", Medium = "-Medium", Heavy = "-Heavy", Book = "-Book"
}
/// Simple Label subclass that has font Avenir
/// - All paramters are optional except size
/// - Non-specified paramters will be assigned default values
class LabelAvenir: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    convenience init(size: CGFloat, type: AvenirFont? = nil, color: UIColor? = nil, alignment: NSTextAlignment? = nil) {
        self.init(frame: .zero)
        textColor = color ?? UISettings.shared.colorScheme.textPrimary
        textAlignment = alignment ?? .left
        font = UIFont(name: "Avenir\(type?.rawValue ?? "")", size: size)
    }
}
