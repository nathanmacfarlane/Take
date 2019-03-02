import UIKit

class RouteAddImagesPresentrVC: UIViewController {

    var delegate: AddImagesDelegate?
    var route: Route?

    override func viewDidLoad() {
        super.viewDidLoad()

        let addPhotos = UIButton()
        addPhotos.setTitle("Add Photos", for: .normal)
        addPhotos.titleLabel?.font = UIFont(name: "Avenir-Black", size: 25)
        addPhotos.setTitleColor(UIColor(named: "PinkAccentDark"), for: .normal)
        addPhotos.addTarget(self, action: #selector(hitAddPhotos), for: .touchUpInside)

        let addDiagrams = UIButton()
        addDiagrams.setTitle("Add Diagrams", for: .normal)
        addDiagrams.titleLabel?.font = UIFont(name: "Avenir-Black", size: 25)
        addDiagrams.setTitleColor(UIColor(named: "PinkAccentDark"), for: .normal)
        addDiagrams.backgroundColor = UIColor(hex: "#F2F2F2")
        addDiagrams.addTarget(self, action: #selector(hitAddAr), for: .touchUpInside)

        view.addSubview(addPhotos)
        view.addSubview(addDiagrams)

        addPhotos.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: addPhotos, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addPhotos, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addPhotos, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addPhotos, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true

        addDiagrams.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: addDiagrams, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addDiagrams, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addDiagrams, attribute: .top, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addDiagrams, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

        view.clipsToBounds = true
        view.backgroundColor = .white
    }

    @objc
    func hitAddAr() {
        dismiss(animated: true) {
            self.delegate?.hitAddAr()
        }
    }

    @objc
    func hitAddPhotos() {
        dismiss(animated: true) {
            self.delegate?.hitAddPhotos()
        }
    }
}

protocol AddImagesDelegate: class {
    func hitAddAr()
    func hitAddPhotos()
}
