import Foundation
import Lightbox
import UIKit

extension RoutePhotosViewController: LightboxControllerPageDelegate, LightboxControllerDismissalDelegate {
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {}
    func lightboxControllerWillDismiss(_ controller: LightboxController) {}
}
