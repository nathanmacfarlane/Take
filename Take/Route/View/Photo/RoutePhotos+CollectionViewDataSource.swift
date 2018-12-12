import Foundation
import UIKit

extension RoutePhotosVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commentKeys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == myImagesCV, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoutePhotoCVCell", for: indexPath) as? RoutePhotosCVC,
            let comment = comments[commentKeys[indexPath.row]] {
            cell.imageView.image = images[comment.id]
            return cell
        }
        return UICollectionViewCell()
    }
}
