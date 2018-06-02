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
    @IBOutlet weak var myARCV: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var pageController: UIPageControl!
    
    // MARK: - Variables
    var ardiagrams : [ARDiagram]!
    var selectedImage : Int!
    var collectionViewFlowLayout : UICollectionViewFlowLayout!

    // MARK: - View load/unload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.closeButton.roundButton(portion: 4)
        self.pageController.numberOfPages = ardiagrams.count
        collectionViewFlowLayout = myARCV.collectionViewLayout as! UICollectionViewFlowLayout
        self.myARCV.scrollToItem(at: IndexPath(item: selectedImage, section: 0), at: .centeredHorizontally, animated: true)
        self.pageController.currentPage = selectedImage
        
    }
    
    // MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ardiagrams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SlideshowDiagramCell
        cell.bgImageView.image  = ardiagrams[indexPath.row].bgImage
        cell.theImage.image     = ardiagrams[indexPath.row].bgImage
        cell.diagramImage.image = ardiagrams[indexPath.row].diagram
        return cell
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        snapToNearestCell(scrollView as! UICollectionView)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        snapToNearestCell(scrollView as! UICollectionView)
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
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
