//
//  RouteEdit.swift
//  Take
//
//  Created by Family on 5/9/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit

class RouteEdit: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate {

    // MARK: - IBOutlets
    @IBOutlet private weak var bgimageView: UIImageView!
    @IBOutlet private weak var photoCV: UICollectionView!
    @IBOutlet private weak var ARCV: UICollectionView!
    @IBOutlet private weak var topRopeButton: TypeButton!
    @IBOutlet private weak var sportButton: TypeButton!
    @IBOutlet private weak var tradButton: TypeButton!
    @IBOutlet private weak var boulderButton: TypeButton!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var feelsLikeField: UITextField!
    @IBOutlet private weak var addPhotoButton: UIButton!
    @IBOutlet private weak var addARPhotoButton: UIButton!
    @IBOutlet private weak var ARDiagramsLabel: UILabel!
    @IBOutlet private weak var photosLabel: UILabel!
    @IBOutlet private weak var feelsLikeABG: UILabel!
    @IBOutlet private weak var starsButton: UIButton!

    // MARK: - variables
    var theRoute: Route = Route(name: "", id: 0, lat: 0, long: 0)
    var imagePicker: UIImagePickerController!
    var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    var sCV: UICollectionView!
    var username: String = ""
    var shouldEditPhoto: Bool = false
    var starRating: Int = 0
    //    var newImages: [UIImage] = []
    //    var imageKeys: [String] = []
    var imgKeys: [String] = []
    var newImagesWithKeys: [String: UIImage] = [:]

    // MARK: - View load/unload
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary

        self.setupButtons()
        self.descriptionTextView.text = theRoute.info ?? ""
        self.feelsLikeField.placeholder = "ex: \(theRoute.difficulty?.description ?? "")"

        photoCV.backgroundColor = .clear
        ARCV.backgroundColor = .clear

        addBlur()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //print("ar image count: \(self.theRoute.ardiagrams?.count)")
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
        self.feelsLikeABG.roundView(portion: 5)
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
    @IBAction private func tappedStars(_ sender: UIButton) {
        self.starRating = self.starRating < 4 ? self.starRating + 1 : 0
        if self.starRating == 0 {
            self.starsButton.setTitle("", for: .normal)
        } else {
            self.starsButton.setTitle("\(String(repeating: "⭑", count: self.starRating))\(String(repeating: "⭒", count: 4 - self.starRating))", for: .normal)
        }
    }
    @IBAction private func addNewPhoto(_ sender: UIButton) {
        sCV = photoCV
        self.shouldEditPhoto = false
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction private func addNewARPhoto(_ sender: UIButton) {
        sCV = ARCV
        let alertController = UIAlertController(title: nil, message: "Edit a photo or upload a previously created diagram.", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let editPhoto = UIAlertAction(title: "Edit Photo", style: .default) { _ in
            self.shouldEditPhoto = true
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        let uploadDiagram = UIAlertAction(title: "Upload Diagram", style: .default) { _ in
            self.shouldEditPhoto = false
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        alertController.addAction(cancel)
        alertController.addAction(editPhoto)
        alertController.addAction(uploadDiagram)
        self.present(alertController, animated: true)
    }

    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let alertController = UIAlertController(title: nil, message: "Delete image?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            if collectionView == self.photoCV {
                let itemKey = self.imgKeys[indexPath.row]
                self.newImagesWithKeys.removeValue(forKey: itemKey)
                self.imgKeys.remove(at: indexPath.row)
                //                let itemKey = self.imageKeys[indexPath.row]
                //                self.theRoute.images!.removeValue(forKey: itemKey)
                //                self.theRoute.images!.remove(at: indexPath.row)
                //                self.theRoute.deleteImageFromFB(indexOfDeletion: indexPath.row, imageURL: self.theRoute.allImages![indexPath.row]) {
                //                    print("finished deleting")
                //                }
                self.photoCV.reloadData()
            } else {
                self.theRoute.ardiagrams.remove(at: indexPath.row)
                self.ARCV.reloadData()
            }
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true)

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView == photoCV {
            return self.imgKeys.count
        } else {
            return 0
        }

        //        if collectionView == photoCV {
        ////            if self.images.count > 0 {
        //            if self.theRoute.images?.count ?? 0 > 0 {
        //                self.photosLabel.isHidden = true
        //            } else {
        //                self.photosLabel.isHidden = false
        //            }
        //            return self.theRoute.images?.count ?? 0
        ////            return self.images.count
        //        } else {
        ////            if self.arimages.count > 0 {
        //            if self.theRoute.ardiagrams?.count ?? 0 > 0 {
        //                self.ARDiagramsLabel.isHidden = true
        //            } else {
        //                self.ARDiagramsLabel.isHidden = false
        //            }
        //            return self.theRoute.ardiagrams?.count ?? 0
        ////            return self.arimages.count
        //        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == photoCV {
            let tempCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
            let itemKey = self.imgKeys[indexPath.row]
            guard let cell = tempCell as? AddImageCell, let newImage = newImagesWithKeys[itemKey] else { return tempCell }
            cell.setImage(with: newImage)
            //            cell.bgImageView.image = self.theRoute.images![itemKey]
            //            cell.bgImageView.image = self.theRoute.images![indexPath.row]
            return cell
        }
        let tempCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ARCell", for: indexPath)
        guard let cell = tempCell as? AddARImageCell else { return tempCell }
        //        cell.bgImageView.image = self.theRoute.ardiagrams?[indexPath.row].bgImage
        cell.setImage(ardiagram: self.theRoute.ardiagrams[indexPath.row])
        return cell

    }

    // MARK: - Action Sheet

    // MARK: - TextView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }

    // MARK: - TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - Image Picker
    @objc
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {

        let pickedImage: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage ?? UIImage()
        if sCV == photoCV {
            let instanceString = Date().instanceString()
            self.imgKeys.append(instanceString)
            self.newImagesWithKeys[instanceString] = pickedImage
        } else if self.shouldEditPhoto == false {
            self.theRoute.ardiagrams.insert(ARDiagram(bgImage: pickedImage), at: 0)
        }
        self.photoCV.reloadData()
        self.ARCV.reloadData()
        dismiss(animated: true) {
            if self.shouldEditPhoto == true {
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
        for image in self.newImagesWithKeys {
            self.theRoute.images[image.key] = image.value
        }
        if let flft = self.feelsLikeField.text, !flft.isEmpty {
            theRoute.feelsLike.append(Rating(desc: flft))
        }
        if self.starRating > 0 {
            if theRoute.starVotes == nil || theRoute.star == nil {
                theRoute.starVotes = 0
                theRoute.star = 0
            }
            (theRoute.star, theRoute.starVotes) = calculateNewAvg(count: theRoute.starVotes ?? 0, avg: theRoute.star ?? 0, new: self.starRating)
        }
        theRoute.info = self.descriptionTextView.text
        theRoute.types = populateTypes()
        DispatchQueue.global(qos: .background).async {
            self.theRoute.saveARImagesToFirebase()
            self.theRoute.saveToFirebase(newImagesWithKeys: self.newImagesWithKeys)
            self.theRoute.saveToGeoFire()
        }
        self.dismiss(animated: true, completion: nil)
    }
    func calculateNewAvg(count: Int, avg: Double, new: Int) -> (Double?, Int?) {
        var total = avg * Double(count)
        print("total: \(total)")
        total += Double(new)
        print("new total: \(total)")
        print("new calculated average: \(total / Double(count + 1))")
        return (total / Double(count + 1), count + 1)
    }
    func populateTypes() -> String {
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
        return types.joined(separator: ", ")
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
        if segue.identifier == "presentEditARPhoto", let dct: EditARPhoto = segue.destination as? EditARPhoto {
            if let theImage = sender as? UIImage {
                dct.theImage = theImage
            }
            dct.theRoute = self.theRoute
        }
    }
}
