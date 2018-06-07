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
    @IBOutlet weak var bgimageView: UIImageView!
    @IBOutlet weak var photoCV: UICollectionView!
    @IBOutlet weak var ARCV: UICollectionView!
    @IBOutlet weak var topRopeButton: TypeButton!
    @IBOutlet weak var sportButton: TypeButton!
    @IBOutlet weak var tradButton: TypeButton!
    @IBOutlet weak var boulderButton: TypeButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var feelsLikeField: UITextField!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var addARPhotoButton: UIButton!
    @IBOutlet weak var ARDiagramsLabel: UILabel!
    @IBOutlet weak var photosLabel: UILabel!
    
    // MARK: - variables
    var theRoute : Route!
    let imagePicker = UIImagePickerController()
    var selectedIndex: IndexPath!
    var sCV : UICollectionView!
    var username: String!
    var shouldEditPhoto : Bool!
//    var newImages: [UIImage] = []
//    var imageKeys: [String] = []
    var imgKeys : [String] = []
    var newImagesWithKeys : [String : UIImage] = [:]
    
    // MARK: - View load/unload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        self.setupButtons()
        self.descriptionTextView.text = theRoute.info ?? "N/A"
        self.feelsLikeField.text = theRoute.difficulty?.description ?? "N/A"
        
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
    }
    func addBlur() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.bgimageView.insertSubview(blurEffectView, at: 0)
    }
    
    // MARK: - TypeButton functions
    @IBAction func toggleButton(_ sender: TypeButton) {
        sender.setType(isType: !sender.isType)
    }
    
    // MARK: - IBActions
    @IBAction func addNewPhoto(_ sender: UIButton) {
        sCV = photoCV
        self.shouldEditPhoto = false
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func addNewARPhoto(_ sender: UIButton) {
        sCV = ARCV
        let alertController = UIAlertController(title: nil, message: "Edit a photo or upload a previously created diagram.", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let editPhoto = UIAlertAction(title: "Edit Photo", style: .default) { action in
            self.shouldEditPhoto = true
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                self.imagePicker.sourceType = .savedPhotosAlbum;
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        let uploadDiagram = UIAlertAction(title: "Upload Diagram", style: .default) { action in
            self.shouldEditPhoto = false
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                self.imagePicker.sourceType = .savedPhotosAlbum;
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
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
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
                self.theRoute.ardiagrams!.remove(at: indexPath.row)
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! AddImageCell
            let itemKey = self.imgKeys[indexPath.row]
            cell.bgImageView.image = newImagesWithKeys[itemKey]
//            cell.bgImageView.image = self.theRoute.images![itemKey]
//            cell.bgImageView.image = self.theRoute.images![indexPath.row]
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ARCell", for: indexPath) as! AddARImageCell
//        cell.bgImageView.image = self.theRoute.ardiagrams?[indexPath.row].bgImage
        cell.setImage(ardiagram: self.theRoute.ardiagrams![indexPath.row])
        return cell
        
    }
    
    // MARK: - Action Sheet
    
    
    // MARK: - TextView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
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
    @objc internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        if sCV == photoCV {
//            self.images.insert(pickedImage!, at: 0)
            let instanceString = Date().instanceString()
//            self.newImages.append(pickedImage!)
//            self.imageKeys.append(instanceString)
            self.imgKeys.append(instanceString)
            self.newImagesWithKeys[instanceString] = pickedImage!
//            if self.theRoute.images == nil {
//                self.theRoute.images = [instanceString : pickedImage!]
//            } else {
//                self.theRoute.images![instanceString] = pickedImage!
//            }
        } else {
            
            if self.shouldEditPhoto == false {
//                self.arimages.insert(pickedImage!, at: 0)
                if self.theRoute.ardiagrams == nil {
                    self.theRoute.ardiagrams = [ARDiagram(bgImage: pickedImage!)]
                } else {
                    self.theRoute.ardiagrams?.insert(ARDiagram(bgImage: pickedImage!), at: 0)
                }
            }
            
        }
        self.photoCV.reloadData()
        self.ARCV.reloadData()
        dismiss(animated: true, completion: {
            if self.shouldEditPhoto == true {
                self.performSegue(withIdentifier: "presentEditARPhoto", sender: pickedImage!)
            }
        })
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    @IBAction func hitCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func hitSave(_ sender: UIButton) {
        //theRoute.feelsLike?.append(Rating(rating: self.feelsLikeField.text, username: username))
        theRoute.feelsLike?.append(Rating(desc: self.feelsLikeField.text!))
        theRoute.info = self.descriptionTextView.text
        theRoute.types = populateTypes()
//        theRoute.saveToFirebase(newImages: newImages, newKeys: imageKeys)
        theRoute.saveToFirebase(newImagesWithKeys: newImagesWithKeys)
        theRoute.saveToGeoFire()
        self.dismiss(animated: true, completion: nil)
    }
    func populateTypes() -> String {
        var types : [String] = []
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
            if image != nil {
                theImages.append(image!)
            }
        }
        return theImages
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentEditARPhoto" {
            let dc: EditARPhoto = segue.destination as! EditARPhoto
            dc.theImage = sender as! UIImage
            dc.theRoute = self.theRoute
        }
    }
}
