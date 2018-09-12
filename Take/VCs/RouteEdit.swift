//
//  RouteEdit.swift
//  Take
//
//  Created by Family on 5/9/18.
//  Copyright © 2018 N8. All rights reserved.
//

import CodableFirebase
import Firebase
import FirebaseFirestore
import UIKit

class RouteEdit: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate {

    // MARK: - IBOutlets
    @IBOutlet private weak var addRatingLabel: UILabel!
    @IBOutlet private weak var bgimageView: UIImageView!
    @IBOutlet private weak var photoCV: UICollectionView!
    @IBOutlet private weak var ARCV: UICollectionView!
    @IBOutlet private weak var topRopeButton: TypeButton!
    @IBOutlet private weak var sportButton: TypeButton!
    @IBOutlet private weak var tradButton: TypeButton!
    @IBOutlet private weak var boulderButton: TypeButton!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var addPhotoButton: UIButton!
    @IBOutlet private weak var addARPhotoButton: UIButton!
    @IBOutlet private weak var ARDiagramsLabel: UILabel!
    @IBOutlet private weak var photosLabel: UILabel!
    @IBOutlet private weak var starsSlider: UISlider!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var ratingTextField: UITextField!
    @IBOutlet private weak var pitchStepper: UIStepper!
    @IBOutlet private weak var pitchLabel: UILabel!
    @IBOutlet private weak var informationSegControl: UISegmentedControl!
    @IBOutlet private weak var locationButton: UIButton!

    // MARK: - variables
    var theRoute: Route!
    var bgImage: UIImage?
    var imagePicker: UIImagePickerController!
    var selectedIndex: IndexPath!
    var selectedCV: UICollectionView!
    var username: String = ""

    // ar
    var selectedAr: [String: [UIImage]] = [:]
    var arKeys: [String] = []
    var newArKeys: [String] = []

    // images
    var selectedImages: [String: UIImage] = [:]
    var imageKeys: [String] = []
    var newImageKeys: [String] = []

    // general information
    var newDescription: String?
    var newProtection: String?

    // MARK: - View load/unload
    override func viewDidLoad() {
        super.viewDidLoad()

        if theRoute == nil {
            theRoute = Route()
        }

        self.nameTextField.underlined()
        self.nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        self.ratingTextField.underlined()
        self.ratingTextField.attributedPlaceholder = NSAttributedString(string: "Rating", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])

        self.nameTextField.text = self.theRoute.name
        self.ratingTextField.text = self.theRoute.rating
        self.pitchLabel.text = "\(Int(self.theRoute.pitches)) Pitch\(Int(self.theRoute.pitches) > 1 ? "es" : "")"
        self.pitchStepper.value = Double(self.theRoute.pitches)

        if let bgImage = self.bgImage {
            self.bgimageView.image = bgImage
        }

        self.newDescription = self.theRoute.info
        self.newProtection = self.theRoute.protection

        imageKeys = Array(selectedImages.keys)
        arKeys = Array(selectedAr.keys)

        if !selectedImages.isEmpty {
            self.photosLabel.text = ""
        }

        if !selectedAr.isEmpty {
            self.ARDiagramsLabel.text = ""
        }

        if let userId = Auth.auth().currentUser?.uid, let userRating = self.theRoute.stars[userId] {
            self.addRatingLabel.text = "\(userRating) ★"
            self.starsSlider.setValue(Float(userRating), animated: true)
        }

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary

        self.setupButtons()
        self.descriptionTextView.text = theRoute.info ?? ""

        photoCV.backgroundColor = .clear
        ARCV.backgroundColor = .clear
        locationButton.roundButton(portion: 2)

        addBlur()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.photoCV.reloadData()
        self.ARCV.reloadData()
    }

    // MARK: - initial functions
    func setupButtons() {
        self.addPhotoButton.roundButton(portion: 2)
        self.addARPhotoButton.roundButton(portion: 2)
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
    }
    func addBlur() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.bgimageView.insertSubview(blurEffectView, at: 0)
    }

    // MARK: - TypeButton functions
    @IBAction private func toggleButton(_ sender: TypeButton) {
        sender.setType(isType: !sender.isType)
    }

    // MARK: - IBActions
    @IBAction private func pitchStepperChanged(_ sender: UIStepper) {
        self.pitchLabel.text = "\(Int(sender.value)) Pitch\(Int(sender.value) > 1 ? "es" : "")"
    }
    @IBAction private func starsSliderChanged(_ sender: UISlider) {
        if sender.value < 1 {
            self.addRatingLabel.text = "No Rating"
        } else {
            self.addRatingLabel.text = "\(Int(sender.value)) ★"
        }
    }
    @IBAction private func informationSegChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.descriptionTextView.text = self.newDescription
        } else if sender.selectedSegmentIndex == 1 {
            self.descriptionTextView.text = self.newProtection
        }
        self.descriptionTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
    }
    @IBAction private func addNewPhoto(_ sender: UIButton) {
        selectedCV = photoCV
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction private func addNewARPhoto(_ sender: UIButton) {
        selectedCV = ARCV
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.imagePicker.allowsEditing = false
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }

    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

//        let alertController = UIAlertController(title: nil, message: "Delete image?", preferredStyle: .actionSheet)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
//            if collectionView == self.photoCV {
//                let itemKey = self.imgKeys[indexPath.row]
//                self.newImagesWithKeys.removeValue(forKey: itemKey)
//                self.imgKeys.remove(at: indexPath.row)
//                //                let itemKey = self.imageKeys[indexPath.row]
//                //                self.theRoute.images!.removeValue(forKey: itemKey)
//                //                self.theRoute.images!.remove(at: indexPath.row)
//                //                self.theRoute.deleteImageFromFB(indexOfDeletion: indexPath.row, imageURL: self.theRoute.allImages![indexPath.row]) {
//                //                    print("finished deleting")
//                //                }
//                self.photoCV.reloadData()
//            } else {
//                self.theRoute.ardiagrams.remove(at: indexPath.row)
//                self.ARCV.reloadData()
//            }
//            let generator = UIImpactFeedbackGenerator(style: .heavy)
//            generator.impactOccurred()
//        }
//        alertController.addAction(cancelAction)
//        alertController.addAction(deleteAction)
//        self.present(alertController, animated: true)

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView == photoCV {
            return self.selectedImages.count
        } else {
            return self.selectedAr.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == photoCV {
            let tempCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
            guard let cell = tempCell as? AddImageCell else { return tempCell }
            let imageKey = self.imageKeys[indexPath.row]
            guard let image = self.selectedImages[imageKey] else { return tempCell }
            cell.setImage(with: image)
            return cell
        } else {
            let tempCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ARCell", for: indexPath)
            guard let cell = tempCell as? AddARImageCell else { return tempCell }
            let arKey = self.arKeys[indexPath.row]
            guard let ar = self.selectedAr[arKey] else { return tempCell }
            cell.setImage(bg: ar[0], diagram: ar[1])
            return cell
        }
    }

    // MARK: - Action Sheet

    // MARK: - TextView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        if self.informationSegControl.selectedSegmentIndex == 0 {
            self.newDescription = textView.text
        } else if self.informationSegControl.selectedSegmentIndex == 1 {
            self.newProtection = textView.text
        }
    }

    // MARK: - TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    var alertTextField: UITextField?

    func configurationTextField(textField: UITextField) {
        self.alertTextField = textField
        self.alertTextField?.placeholder = "Description"
    }

    // MARK: - Image Picker
    @objc
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {

        let pickedImage: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage ?? UIImage()
        if selectedCV == photoCV {
            let imageId = UUID().uuidString
            self.selectedImages[imageId] = pickedImage
            self.imageKeys.append(imageId)
            self.newImageKeys.append(imageId)
            self.photosLabel.text = ""
            self.photoCV.reloadData()
        }
        dismiss(animated: true) {
            if self.selectedCV == self.ARCV {
                self.performSegue(withIdentifier: "presentEditARPhoto", sender: pickedImage)
            }
        }

    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Navigation
    @IBAction private func hitCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction private func hitSave(_ sender: UIButton) {
        if let userId = Auth.auth().currentUser?.uid {
            let starValue = Int(self.starsSlider.value)
            if starValue < 1 {
                // remove rating
                self.theRoute.stars.removeValue(forKey: userId)
            } else {
                // add or update rating
                self.theRoute.stars[userId] = starValue
            }
        }
        if let name = self.nameTextField.text {
            theRoute.name = name
        }
        if let rating = self.ratingTextField.text {
            theRoute.rating = rating
        }
        theRoute.pitches = Int(self.pitchStepper.value)
        theRoute.info = self.newDescription
        theRoute.protection = self.newProtection
        theRoute.types = populateTypes()

        //save images
        for imageKey in self.newImageKeys {
            guard let newImage = self.selectedImages[imageKey] else { continue }
            newImage.saveToFb(route: self.theRoute)
        }
        for arKey in self.newArKeys {
            guard let newAr = self.selectedAr[arKey] else { continue }
            self.theRoute.fsSaveAr(imageId: arKey, bgImage: newAr[0], dgImage: newAr[1])
        }

        DispatchQueue.global(qos: .background).async {
            self.theRoute.fsSave()
        }

        if let presenter = presentingViewController as? RouteDetail {
            presenter.imageKeys = self.imageKeys
            presenter.images = self.selectedImages
            presenter.diagramKeys = self.arKeys
            presenter.diagrams = self.selectedAr
        }

        self.dismiss(animated: true, completion: nil)
    }

    func calculateNewAvg(count: Int, avg: Double, new: Int) -> (Double?, Int?) {
        var total = avg * Double(count)
        total += Double(new)
        return (total / Double(count + 1), count + 1)
    }
    func populateTypes() -> [String] {
        var types: [String] = []
        if topRopeButton.isType {
            types.append("TR")
        }
        if sportButton.isType {
            types.append("Sport")
        }
        if tradButton.isType {
            types.append("Trad")
        }
        if boulderButton.isType {
            types.append("Boulder")
        }
        return types
    }
    func populateImages(imageArr: [UIImage?]) -> [UIImage] {
        var theImages: [UIImage] = []
        for image in imageArr {
            guard let theImage = image else { continue }
            theImages.append(theImage)
        }
        return theImages
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "presentEditARPhoto":
            guard let dct: EditARPhoto = segue.destination as? EditARPhoto else { return }
            if let theImage = sender as? UIImage {
                dct.theImage = theImage
            }
            dct.theRoute = self.theRoute
        case "pushToMap":
            guard let dct: DetailMapView = segue.destination as? DetailMapView else { return }
            dct.editMode = true
            dct.theRoute = self.theRoute
        default:
            fatalError("segue with unaccounted for identifier")
        }
    }
}
