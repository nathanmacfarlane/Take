//
//  DiagramSlideshow.swift
//  Take
//
//  Created by Family on 5/22/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit

class DiagramSlideshow: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - IBOutlets
    @IBOutlet private weak var myARCV: UICollectionView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var pageController: UIPageControl!

    // MARK: - Variables
    var ardiagrams: [ARDiagram] = []
    var selectedImage: Int = 0
    var collectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

    // MARK: - View load/unload
    override func viewDidLoad() {
        super.viewDidLoad()

        self.closeButton.roundButton(portion: 4)
        self.pageController.numberOfPages = ardiagrams.count
        if let cvfl = myARCV.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewFlowLayout = cvfl
        }
        self.myARCV.scrollToItem(at: IndexPath(item: selectedImage, section: 0), at: .centeredHorizontally, animated: true)
        self.pageController.currentPage = selectedImage

    }

    // MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ardiagrams.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tempCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        guard let cell = tempCell as? SlideshowDiagramCell else { return tempCell }
        cell.setBgImage(with: ardiagrams[indexPath.row].bgImage)
        cell.setImage(with: ardiagrams[indexPath.row].bgImage)
        if let theDiagram = ardiagrams[indexPath.row].diagram {
            cell.setDiagramImage(with: theDiagram)
        }
//        cell.bgImageView.image = ardiagrams[indexPath.row].bgImage
//        cell.theImage.image = ardiagrams[indexPath.row].bgImage
//        cell.diagramImage.image = ardiagrams[indexPath.row].diagram
        return cell
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let scv = scrollView as? UICollectionView {
            snapToNearestCell(scv)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let scv = scrollView as? UICollectionView {
            snapToNearestCell(scv)
        }
    }
    func snapToNearestCell(_ collectionView: UICollectionView) {
        for i in 0..<collectionView.numberOfItems(inSection: 0) {

            let itemWithSpaceWidth = collectionViewFlowLayout.itemSize.width + collectionViewFlowLayout.minimumLineSpacing
            let itemWidth = collectionViewFlowLayout.itemSize.width

            if collectionView.contentOffset.x <= CGFloat(i) * itemWithSpaceWidth + itemWidth / 2 {
                let indexPath = IndexPath(item: i, section: 0)
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                self.pageController.currentPage = indexPath.row
                break
            }
        }
    }

    // MARK: - Navigation
    @IBAction private func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
