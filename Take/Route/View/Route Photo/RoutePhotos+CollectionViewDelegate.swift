import Foundation
import Lightbox
import UIKit

extension RoutePhotosViewController: UICollectionViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == myImagesCV && isAddingComment {
            toggleCommentView()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lightboxController = LightboxController(images: lightboxImages, startIndex: indexPath.row)
        lightboxController.pageDelegate = self
        lightboxController.dismissalDelegate = self
        lightboxController.dynamicBackground = true
        present(lightboxController, animated: true, completion: nil)
    }
}
