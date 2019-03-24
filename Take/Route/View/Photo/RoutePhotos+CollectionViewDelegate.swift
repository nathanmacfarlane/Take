import Foundation
import UIKit

extension RoutePhotosVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RoutePhotosCVC else { return }
        let photoViewer = PhotoViewerVC()
        photoViewer.bgImage = cell.bgImageView.image
        photoViewer.dgImage = cell.dgImageView.image
        photoViewer.message = images[indexPath.row].comment
        present(photoViewer, animated: true, completion: nil)
    }
}
