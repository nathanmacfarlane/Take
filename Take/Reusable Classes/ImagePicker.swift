import Foundation
import UIKit

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var picker = UIImagePickerController()
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback: ((UIImage) -> Void)?

    override init() {
        super.init()
    }

    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> Void)) {
        pickImageCallback = callback
        self.viewController = viewController

        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: .default) { _ in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in

        }

        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.viewController?.view
        viewController.present(alert, animated: true, completion: nil)
    }
    func openCamera() {
        alert.dismiss(animated: true, completion: nil)
        if UIImagePickerController .isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            self.viewController?.present(picker, animated: true, completion: nil)
        }
    }
    func openGallery() {
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController?.present(picker, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        pickImageCallback?(image)
    }

    @objc
    func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {

    }

}
