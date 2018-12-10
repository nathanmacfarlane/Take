import Foundation
import TwicketSegmentedControl
import UIKit

extension RouteDetailViewController: TwicketSegmentedControlDelegate {

    func didSelect(_ segmentIndex: Int) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.infoLabel.alpha = 0.0
        }, completion: { _ in
            self.infoLabel.text = segmentIndex == 0 ? self.routeViewModel.info : self.routeViewModel.protection
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.view.layoutIfNeeded()
            }, completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.infoLabel.alpha = 1.0
                }
            })
        })
    }
}
