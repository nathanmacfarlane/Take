import Foundation
import TwicketSegmentedControl
import UIKit

extension RouteDetailVC: TwicketSegmentedControlDelegate {

    func didSelect(_ segmentIndex: Int) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.infoTextView.alpha = 0.0
        }, completion: { _ in
            self.infoTextView.text = segmentIndex == 0 ? self.routeViewModel.info : self.routeViewModel.protection
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.view.layoutIfNeeded()
            }, completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.infoTextView.alpha = 1.0
                }
            })
        })
    }
}
