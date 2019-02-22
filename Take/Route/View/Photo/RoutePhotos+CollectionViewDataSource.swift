import Foundation
import UIKit

extension RoutePhotosVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == myImagesCV, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoutePhotoCVCell", for: indexPath) as? RoutePhotosCVC {
            let comment = images[indexPath.row]
            cell.bgImageView.image = nil
            cell.dgImageView.image = nil
            DispatchQueue.global(qos: .background).async {
                comment.image.bgImage?.getImage { image in
                    DispatchQueue.main.async {
                        cell.bgImageView.image = image
                    }
                }
                comment.image.dgImage?.getImage { image in
                    DispatchQueue.main.async {
                        cell.dgImageView.image = image
                    }
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
