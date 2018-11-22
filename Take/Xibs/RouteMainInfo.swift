import Foundation
import TwicketSegmentedControl
import UIKit
import VerticalCardSwiper

class RouteMainInfo: CardCell, TwicketSegmentedControlDelegate {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var segControl: TwicketSegmentedControl!

    var info: String = ""
    var protection: String = ""

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        self.layer.cornerRadius = 12
        super.layoutSubviews()
        segControl.delegate = self
    }

    func didSelect(_ segmentIndex: Int) {
        infoLabel.text = segmentIndex == 0 ? info : protection
    }
}
