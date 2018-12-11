import Foundation
import Lightbox
import UIKit

extension RoutePhotosVC: LightboxControllerPageDelegate, LightboxControllerDismissalDelegate {
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {}
    func lightboxControllerWillDismiss(_ controller: LightboxController) {}
}
