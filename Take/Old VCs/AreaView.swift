//
//  AreaView.swift
//  Take
//
//  Created by Family on 5/27/18.
//  Copyright © 2018 N8. All rights reserved.
//

import FirebaseFirestore
import UIKit

class AreaView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - IBOutlets
    @IBOutlet private weak var routeNameLabel: UILabel!
    @IBOutlet private weak var informationTextView: UITextView!
    @IBOutlet private weak var photosCV: UICollectionView!
    @IBOutlet private weak var routesContainer: UIView!
    @IBOutlet private weak var difficultyContainer: UIView!
    @IBOutlet private weak var typesContainer: UIView!

    // MARK: - Variables
    var areaImage: UIImage?
    var theArea: Area!
    var routes: [Route] = []
    var images: [String: UIImage] = [:]
    var imageKeys: [String] = []
    var selectedImage: UIImage?
    var routesCV: RoutesList?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.photosCV.backgroundColor = .clear
        self.difficultyContainer.isHidden = true
        self.typesContainer.isHidden = true

        Firestore.firestore().query(type: Route.self, by: "areaId", with: theArea.id) { routes in
            DispatchQueue.main.async {
                if let routesCV = self.routesCV {
                    routesCV.routes = routes
                    routesCV.reloadTV()
                }
            }
            self.routes = routes
            var count = 0
            for route in self.routes {
                route.fsLoadImages { images in
                    for image in images {
                        self.images[image.key] = image.value
                        self.imageKeys.append(image.key)
                    }
                    count += 1
                    if count == self.routes.count {
                        DispatchQueue.main.async {
                            self.photosCV.reloadData()
                        }
                    }
                }
            }
        }

        informationTextView.text = theArea.description
        routeNameLabel.text = theArea.name
    }

    // MARK: - SegControl
    @IBAction private func informationSegChanged(_ sender: UISegmentedControl) {
        self.informationTextView.text = sender.selectedSegmentIndex == 0 ? theArea.description : theArea.directions
    }
    @IBAction private func routesSegChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.difficultyContainer.isHidden = true
            self.routesContainer.isHidden = false
            self.typesContainer.isHidden = true
        case 1:
            self.difficultyContainer.isHidden = false
            self.routesContainer.isHidden = true
            self.typesContainer.isHidden = true
//            if let difficultyCV = self.difficultyCV { difficultyCV.reload() }
        case 2:
            self.difficultyContainer.isHidden = true
            self.routesContainer.isHidden = true
            self.typesContainer.isHidden = false
//            if let typesCV = self.typesCV { typesCV.animateChart() }
        default:
            print("un-accounted for seg stuff")
        }
    }

    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageKeys.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tempCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        guard let cell = tempCell as? DetailImagesCell else { return tempCell }
        guard let cellImage = self.images[self.imageKeys[indexPath.row]] else { return tempCell }
        cell.setImage(with: cellImage)
        cell.clearDgImage()
        return cell
    }

    // MARK: - Navigation
    func goToRoute(route: Route, image: UIImage?) {
        self.selectedImage = image
        self.performSegue(withIdentifier: "goToDetail", sender: route)
    }
    @IBAction private func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "routesList" {
            guard let dct = segue.destination as? RoutesList else { return }
            routesCV = dct
            dct.routes = self.routes
            dct.areaImage = self.areaImage
            dct.theArea = self.theArea
        } else if segue.identifier == "goToDetail" {
            guard let dct = segue.destination as? RouteDetail else { return }
            guard let theRoute = sender as? Route else { return }
            dct.theRoute = theRoute
            dct.bgImage = selectedImage
        }
    }

}
