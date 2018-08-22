//
//  ImageSlideshow.swift
//  Take
//
//  Created by Family on 5/21/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit

class ImageSlideshow: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - IBOutlets
    @IBOutlet private weak var myImageCV: UICollectionView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var imageNumberLabel: UILabel!

    // MARK: - Variables
    var images: [UIImage] = []
    var selectedImage: Int = 0
    var collectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

    // View load/unload
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.pageController.numberOfPages = images.count
        self.imageNumberLabel.text = "Image \(selectedImage + 1) of \(images.count)"
        self.closeButton.roundButton(portion: 4)
        if let cvfl = myImageCV.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewFlowLayout = cvfl
        }
        self.myImageCV.scrollToItem(at: IndexPath(item: selectedImage, section: 0), at: .centeredHorizontally, animated: true)
        //        self.pageController.currentPage = selectedImage
    }

    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tempCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        guard let cell = tempCell as? SlideshowImageCell else { return tempCell }
        cell.setImage(with: images[indexPath.row])
        return cell
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let scv = scrollView as? UICollectionView else { return }
        snapToNearestCell(scv)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let scv = scrollView as? UICollectionView else { return }
        snapToNearestCell(scv)
    }
    func snapToNearestCell(_ collectionView: UICollectionView) {
        for i in 0..<collectionView.numberOfItems(inSection: 0) {

            let itemWithSpaceWidth = collectionViewFlowLayout.itemSize.width + collectionViewFlowLayout.minimumLineSpacing
            let itemWidth = collectionViewFlowLayout.itemSize.width

            if collectionView.contentOffset.x <= CGFloat(i) * itemWithSpaceWidth + itemWidth / 2 {
                let indexPath = IndexPath(item: i, section: 0)
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                self.imageNumberLabel.text = "Image \(indexPath.row + 1) of \(images.count)"
                //                self.pageController.currentPage = indexPath.row
                break
            }
        }
    }

    // MARK: - Navigation
    @IBAction private func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
