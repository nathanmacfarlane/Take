//
//  RouteDetail.swift
//  Take
//
//  Created by Family on 5/4/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit
import MapKit

class RouteDetail: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - IBOutlets
    @IBOutlet weak var bgimageView:             UIImageView!
    @IBOutlet weak var myCV:                    UICollectionView!
    @IBOutlet weak var myARVC:                  UICollectionView!
    @IBOutlet weak var topRopeButton:           TypeButton!
    @IBOutlet weak var sportButton:             TypeButton!
    @IBOutlet weak var tradButton:              TypeButton!
    @IBOutlet weak var boulderButton:           TypeButton!
    @IBOutlet weak var directionsButton:        UIButton!
    @IBOutlet weak var augmentedButton:         UIButton!
    @IBOutlet weak var routeNameLabel:          UILabel!
    @IBOutlet weak var routeLocationButton:     UIButton!
    @IBOutlet weak var routeDescriptionTV:      UITextView!
    @IBOutlet weak var commentsButton:          UIButton!
    @IBOutlet weak var starsLabel:              UILabel!
    @IBOutlet weak var actualRatingLabel:       UILabel!
    @IBOutlet weak var feelsLikeRatingLabel:    UILabel!
    @IBOutlet weak var beTheFirstLabel:         UILabel!
    @IBOutlet weak var imageSegControl:         UISegmentedControl!
    
    // MARK: - Variables
    var theRoute : Route!
    var mainImg  : UIImage?
    
    // MARK: - load/unloads
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        self.myARVC.isHidden = true
        self.myCV.backgroundColor = UIColor.clear
        self.myARVC.backgroundColor = UIColor.clear
        if mainImg != nil {
            self.bgimageView.image = mainImg!
        }
        
        theRoute.getImagesFromFirebase {
            DispatchQueue.main.async {
                self.updateLabel()
                self.myCV.reloadData()
            }
        }
        
        addBlur()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.myCV.reloadData()
        self.myARVC.reloadData()
        
        self.routeNameLabel.text = theRoute.name
        self.routeLocationButton.setTitle(theRoute.localDesc?.last ?? "N/A", for: .normal)
        self.commentsButton.setTitle("\(theRoute.comments?.count ?? 0) 💬", for: .normal)
        self.starsLabel.text = "\(String(repeating: "★", count: theRoute.averageStar()))\(String(repeating: "☆", count: 5 - theRoute.averageStar()))"
        self.actualRatingLabel.text = theRoute.difficulty?.description ?? "N/A"
        self.routeDescriptionTV.text = theRoute.info ?? "N/A"
        self.feelsLikeRatingLabel.text = theRoute.averageRating() ?? "N/A"
        
        self.updateLabel()
        
        setupButtons()
        
        if theRoute.images == nil && theRoute.ardiagrams != nil {
            imageSegControl.selectedSegmentIndex = 1
            checkStatus()
        }
        
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
        
        self.directionsButton.roundButton(portion: 4)
        self.augmentedButton.roundButton(portion: 4)
    }
    func updateLabel() {
        if self.imageSegControl.selectedSegmentIndex == 0 {
            if self.theRoute.images == nil || self.theRoute.images?.count == 0 {
                self.beTheFirstLabel.text = "Be the first to add an image"
                self.beTheFirstLabel.isHidden = false
            } else {
                self.beTheFirstLabel.isHidden = true
            }
        } else {
            if self.theRoute.ardiagrams == nil || self.theRoute.ardiagrams?.count == 0 {
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
    @IBAction func TappedAreaButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: "Areas", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        for area in self.theRoute.localDesc ?? [] {
            let areaAction = UIAlertAction(title: "\(area)", style: .default) { action in
                self.performSegue(withIdentifier: "goToArea", sender: area)
            }
            alertController.addAction(areaAction)
        }
        
        alertController.addAction(cancel)
        self.present(alertController, animated: true)
    }
    
    
    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.myCV {
            return theRoute.images?.count ?? 0
        } else {
            return theRoute.ardiagrams?.count ?? 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.myCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DetailImagesCell
            cell.theImage.image = theRoute.images?[indexPath.row]
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 2
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ARCell", for: indexPath) as! AddARImageCell
            cell.setImage(ardiagram: theRoute.ardiagrams![indexPath.row])
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 2
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.myCV {
            self.performSegue(withIdentifier: "presentAllImages", sender: indexPath.row)
        } else if collectionView == self.myARVC {
            self.performSegue(withIdentifier: "presentAllIDiagrams", sender: indexPath.row)
        }
    }
    
    // MARK: - Seg Control
    @IBAction func imageSegChanged(_ sender: UISegmentedControl) {
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
    @IBAction func goToARView(_ sender: UIButton) {
        self.performSegue(withIdentifier: "presentARView", sender: nil)
    }
    @IBAction func goGetDirections(_ sender: UIButton) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: theRoute.location!.coordinate.latitude, longitude: theRoute.location!.coordinate.longitude), addressDictionary:nil))
        mapItem.name = theRoute.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "pushToComments" {
            let dc: Comments = segue.destination as! Comments
            dc.theRoute = self.theRoute
        } else if segue.identifier == "pushToEdit" {
            let dc: RouteEdit = segue.destination as! RouteEdit
            dc.theRoute = self.theRoute
        } else if segue.identifier == "presentAllImages" {
            let dc: ImageSlideshow = segue.destination as! ImageSlideshow
            dc.images = self.theRoute.images!
            dc.selectedImage = sender as! Int  
        } else if segue.identifier == "presentAllIDiagrams" {
            let dc: DiagramSlideshow = segue.destination as! DiagramSlideshow
            dc.ardiagrams = self.theRoute.ardiagrams!
            dc.selectedImage = sender as! Int
        } else if segue.identifier == "goToArea" {
            let dc: AreaView = segue.destination as! AreaView
            dc.areaName = sender as! String
            dc.areaArr = self.theRoute.localDesc
        }
        
    }
    
}
