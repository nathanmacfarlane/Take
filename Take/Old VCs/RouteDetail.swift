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
    @IBOutlet private weak var mySegController: UISegmentedControl!
    @IBOutlet private weak var informationSegControl: UISegmentedControl!
    @IBOutlet private weak var pitchesSubLabel: UILabel!
    @IBOutlet private weak var myMapView: MKMapView!

    // MARK: - Variables
    var theRoute: Route!
    var bgImage: UIImage?
    var imageKeys: [String] = []
    var images: [String: UIImage] = [:]
    var diagramKeys: [String] = []
    var diagrams: [String: [UIImage]] = [:]
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
        myCV.backgroundColor = UIColor.clear
        myMapView.isHidden = true

        if let bgImage = self.bgImage {
            self.bgimageView.image = bgImage
        }

        self.theRoute.fsLoadAR { diagrams in
            self.diagrams = diagrams
            DispatchQueue.global(qos: .background).async {
                for diagram in self.diagrams {
                    self.diagramKeys.append(diagram.key)
                }
                DispatchQueue.main.async {
                    self.myCV.reloadData()
                }
            }
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
                self.myCV.reloadData()
            }
        }

        addBlur()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.myCV.reloadData()

        self.pitchesLabel.text = "\(theRoute.pitches)"
        self.pitchesSubLabel.text = "Pitch\(Int(self.theRoute.pitches) > 1 ? "es" : "")"
        self.routeNameLabel.text = theRoute.name
        self.commentsButton.setTitle("\(theRoute.commentIds.count) \(theRoute.commentIds.count != 1 ? "Comments" : "Comment")", for: .normal)
        self.actualRatingLabel.text = theRoute.rating ?? "N/A"
        self.routeDescriptionTV.text = theRoute.info ?? "N/A"
        if let averageStar = theRoute.averageStar?.rounded(toPlaces: 1) {
            self.starsLabel.text = "\(averageStar) ★"
        }
        self.starVotersLabel.text = "\(theRoute.stars.count) Reviews"

        if let routeLocal = theRoute.location {
            myMapView.removeAllAnnotations()
            myMapView.centerMapOn(routeLocal)
            myMapView.addPin(from: theRoute)
        }

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
        self.topRopeButton.roundView(portion: 2)
        self.sportButton.roundView(portion: 2)
        self.tradButton.roundView(portion: 2)
        self.boulderButton.roundView(portion: 2)

        self.commentsButton.roundButton(portion: 4)
        self.directionsButton.roundButton(portion: 4)
        self.augmentedButton.roundButton(portion: 4)
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
        if mySegController.selectedSegmentIndex == 0 {
            return self.imageKeys.count
        } else {
            return self.diagramKeys.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tempCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        guard let cell = tempCell as? DetailImagesCell else { return tempCell }
        if mySegController.selectedSegmentIndex == 0 {
            guard let cellImage = self.images[self.imageKeys[indexPath.row]] else { return tempCell }
            cell.setImage(with: cellImage)
            cell.clearDgImage()
            return cell
        } else {
            let arKey = diagramKeys[indexPath.row]
            guard let theImage = self.diagrams[arKey] else { return tempCell }
            cell.setImage(with: theImage[0])
            cell.setDgImage(with: theImage[1])
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "presentAllImages", sender: indexPath.row)
    }

    // MARK: - Gesture Recognizer
    @IBAction func tappedMap(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "showMap", sender: nil)
    }

    // MARK: - Seg Control
    @IBAction private func imageSegChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex < 2 {
            self.myCV.reloadData()
            self.myMapView.isHidden = true
        } else {
            self.myMapView.isHidden = false
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

        switch segue.identifier {
        case "showMap":
            guard let dct: DetailMapView = segue.destination as? DetailMapView else { return }
            dct.theRoute = self.theRoute
        case "pushToComments":
            guard let dct: Comments = segue.destination as? Comments else { return }
            dct.theRoute = self.theRoute
        case "pushToEdit":
            guard let dct: RouteEdit = segue.destination as? RouteEdit else { return }
            dct.selectedImages = self.images
            dct.selectedAr = self.diagrams
            dct.bgImage = self.bgImage
            dct.theRoute = self.theRoute
        case "presentAllImages":
            guard let dct: ImageSlideshow = segue.destination as? ImageSlideshow else { return }
            if self.mySegController.selectedSegmentIndex == 0 {
                // images
                var images: [[UIImage]] = []
                for image in self.images.values {
                    images.append([image])
                }
                dct.images = images
                dct.bgImage = self.bgImage
                guard let selectedImage = sender as? Int else { return }
                dct.selectedImage = selectedImage
            } else {
                dct.images = Array(self.diagrams.values)
                dct.isAr = true
                dct.bgImage = self.bgImage
                guard let selectedImage = sender as? Int else { return }
                dct.selectedImage = selectedImage
            }
        case "goToArea":
//            let dc: AreaView = segue.destination as! AreaView
//            dc.areaName = sender as! String
//            dc.areaArr = self.theRoute.localDesc
            return
        case "presentARView":
            guard let dct: ARView = segue.destination as? ARView else { return }
            dct.theRoute = self.theRoute
        default:
            print("bad segue identifier")
        }

    }

    func combineImages(image1: UIImage, image2: UIImage) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: image1.size.width, height: image1.size.height)
        let renderer = UIGraphicsImageRenderer(size: image1.size)

        return renderer.image { _ in
            image1.draw(in: rect, blendMode: .normal, alpha: 1)
            image2.draw(in: rect, blendMode: .normal, alpha: 1)
        }
    }

}
