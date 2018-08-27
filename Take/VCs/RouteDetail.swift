//
//  RouteDetail.swift
//  Take
//
//  Created by Family on 5/4/18.
//  Copyright © 2018 N8. All rights reserved.
//

import CoreLocation
import FirebaseDatabase
import MapKit
import UIKit

class RouteDetail: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate {

    // MARK: - IBOutlets
    @IBOutlet private weak var bgimageView: UIImageView!
    @IBOutlet private weak var myCV: UICollectionView!
    @IBOutlet private weak var myARVC: UICollectionView!
    @IBOutlet private weak var topRopeButton: TypeButton!
    @IBOutlet private weak var sportButton: TypeButton!
    @IBOutlet private weak var tradButton: TypeButton!
    @IBOutlet private weak var boulderButton: TypeButton!
    @IBOutlet private weak var pitchesLabel: UILabel!
    @IBOutlet private weak var starVotersLabel: UILabel!
    @IBOutlet private weak var directionsButton: UIButton!
    @IBOutlet private weak var commentsButton: UIButton!
    @IBOutlet private weak var augmentedButton: UIButton!
    @IBOutlet private weak var routeNameLabel: UILabel!
    @IBOutlet private weak var routeDescriptionTV: UITextView!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var actualRatingLabel: UILabel!
    @IBOutlet private weak var beTheFirstLabel: UILabel!
    @IBOutlet private weak var imageSegControl: UISegmentedControl!
    @IBOutlet private weak var informationSegControl: UISegmentedControl!
    @IBOutlet private weak var pitchesSubLabel: UILabel!

    // MARK: - Variables
    var theRoute: Route!
    var bgImage: UIImage?
    var imageKeys: [String] = []
    var images: [String: UIImage] = [:]
    var imageRef: DatabaseReference = DatabaseReference()
    var locationManager: CLLocationManager = CLLocationManager()

    // MARK: - load/unloads
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        self.myCV.backgroundColor = UIColor.clear
        self.myARVC.backgroundColor = UIColor.clear
        self.myARVC.isHidden = true

        if let bgImage = self.bgImage {
            self.bgimageView.image = bgImage
        }

        self.theRoute.fsLoadImages { images in
            self.images = images
            for image in self.images {
                self.imageKeys.append(image.key)
            }
            DispatchQueue.main.async {
                if self.bgImage == nil {
                    if let firstImage = images.first {
                        self.bgimageView.image = firstImage.value
                        self.bgImage = firstImage.value
                    }
                }
                self.updateLabel()
                self.myCV.reloadData()
            }
        }

        addBlur()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.myARVC.reloadData()
        self.myCV.reloadData()

        if !self.theRoute.imageUrls.isEmpty {
            self.beTheFirstLabel.text = "Images loading"
        }

        self.pitchesLabel.text = "\(theRoute.pitches)"
        self.pitchesSubLabel.text = "Pitch\(Int(self.theRoute.pitches) > 1 ? "es" : "")"
        self.routeNameLabel.text = theRoute.name
        self.commentsButton.setTitle("\(theRoute.comments.count) Comments", for: .normal)
        self.actualRatingLabel.text = theRoute.rating ?? "N/A"
        self.routeDescriptionTV.text = theRoute.info ?? "N/A"
        if let averageStar = theRoute.averageStar?.rounded(toPlaces: 1) {
            self.starsLabel.text = "\(averageStar) ★"
        }
        self.starVotersLabel.text = "\(theRoute.stars.count) Reviews"

        setupButtons()

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        imageRef.removeAllObservers()
    }

    // MARK: - initial functions
    func setupButtons() {
        self.topRopeButton.setType(isType: theRoute.isTR())
        self.sportButton.setType(isType: theRoute.isSport())
        self.tradButton.setType(isType: theRoute.isTrad())
        self.boulderButton.setType(isType: theRoute.isBoulder())
        self.topRopeButton.addBorder(width: 2)
        self.sportButton.addBorder(width: 2)
        self.tradButton.addBorder(width: 2)
        self.boulderButton.addBorder(width: 2)
        self.topRopeButton.roundButton()
        self.sportButton.roundButton()
        self.tradButton.roundButton()
        self.boulderButton.roundButton()

        self.commentsButton.roundButton(portion: 4)
        self.directionsButton.roundButton(portion: 4)
        self.augmentedButton.roundButton(portion: 4)
    }
    func updateLabel() {
        if self.imageSegControl.selectedSegmentIndex == 0 {
            if self.images.isEmpty {
                self.beTheFirstLabel.text = "Be the first to add an image"
                self.beTheFirstLabel.isHidden = false
            } else {
                self.beTheFirstLabel.isHidden = true
            }
        } else {
            if self.theRoute.ardiagrams.isEmpty {
                self.beTheFirstLabel.text = "Be the first to add a diagram"
                self.beTheFirstLabel.isHidden = false
            } else {
                self.beTheFirstLabel.isHidden = true
            }
        }
    }
    func addBlur() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.bgimageView.insertSubview(blurEffectView, at: 0)
    }

    // MARK: - IBActions
    @IBAction private func informationSegChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.routeDescriptionTV.text = self.theRoute.info
        } else if sender.selectedSegmentIndex == 1 {
            self.routeDescriptionTV.text = self.theRoute.protection
        }
    }
    @IBAction private func hitEditButton(_ sender: Any) {
        self.performSegue(withIdentifier: "pushToEdit", sender: nil)
    }

    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.myCV {
            return self.imageKeys.count
        } else {
            return theRoute.ardiagrams.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.myCV {
            let tempCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            guard let cell = tempCell as? DetailImagesCell, let cellImage = self.images[self.imageKeys[indexPath.row]] else { return tempCell }
            cell.setImage(with: cellImage)
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 2
            return cell
        }
        let tempCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ARCell", for: indexPath)
        guard let cell = tempCell as? AddARImageCell else { return tempCell }
        cell.setImage(ardiagram: theRoute.ardiagrams[indexPath.row])
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 2
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.myCV {
            self.performSegue(withIdentifier: "presentAllImages", sender: indexPath.row)
        } else if collectionView == self.myARVC {
            self.performSegue(withIdentifier: "presentAllIDiagrams", sender: indexPath.row)
        }
    }

    // MARK: - Seg Control
    @IBAction private func imageSegChanged(_ sender: UISegmentedControl) {
        self.updateLabel()
        checkStatus()
    }
    func checkStatus() {
        if imageSegControl.selectedSegmentIndex == 0 {
            self.myARVC.isHidden = true
            self.myCV.reloadData()
            self.myCV.isHidden = false
        } else {
            self.myCV.isHidden = true
            self.myARVC.reloadData()
            self.myARVC.isHidden = false
        }
    }

    // MARK: - Navigation
    @IBAction private func goToARView(_ sender: UIButton) {
        if let localMngLcl = locationManager.location, let routeLocation = theRoute.location, localMngLcl.distance(from: routeLocation) < 100.0 {
            self.performSegue(withIdentifier: "presentARView", sender: nil)
        } else {
            let alertController = UIAlertController(title: "Oh no...", message: "You're too far from the route to view it in AR. Would you like to get directions to the crag?", preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: "No", style: .cancel)
            let getDirections = UIAlertAction(title: "Yes", style: .default) { _ in
                self.goToDirections()
            }
            let overwriteForTesting = UIAlertAction(title: "I AM TESTING", style: .default) { _ in
                self.performSegue(withIdentifier: "presentARView", sender: nil)
            }
            alertController.addAction(cancel)
            alertController.addAction(getDirections)
            alertController.addAction(overwriteForTesting)
            self.present(alertController, animated: true)
        }
    }
    func goToDirections() {
        guard let routeLocal = theRoute.location else { return }
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: routeLocal.coordinate.latitude, longitude: routeLocal.coordinate.longitude), addressDictionary: nil))
        mapItem.name = theRoute.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }

    @IBAction private func goGetDirections(_ sender: UIButton) {
        goToDirections()
    }
    @IBAction private func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "pushToComments" {
            if let dct: Comments = segue.destination as? Comments {
                dct.theRoute = self.theRoute
            }
        } else if segue.identifier == "pushToEdit" {
            if let dct: RouteEdit = segue.destination as? RouteEdit {
                dct.selectedImages = self.images
                dct.bgImage = self.bgImage
                dct.theRoute = self.theRoute
            }
        } else if segue.identifier == "presentAllImages" {
            if let dct: ImageSlideshow = segue.destination as? ImageSlideshow {
                dct.images = Array(self.images.values)
                dct.bgImage = self.bgImage
                if let selectedImage = sender as? Int {
                    dct.selectedImage = selectedImage
                }
            }
        } else if segue.identifier == "presentAllIDiagrams" {
            if let dct: DiagramSlideshow = segue.destination as? DiagramSlideshow {
                dct.ardiagrams = self.theRoute.ardiagrams
                if let selectedImage = sender as? Int {
                    dct.selectedImage = selectedImage
                }
            }
        } else if segue.identifier == "goToArea" {
            //            let dc: AreaView = segue.destination as! AreaView
            //            dc.areaName = sender as! String
            //            dc.areaArr = self.theRoute.localDesc
        } else if segue.identifier == "presentARView" {
            if let dct: ARView = segue.destination as? ARView {
                dct.theRoute = self.theRoute
            }
        }

    }

}
