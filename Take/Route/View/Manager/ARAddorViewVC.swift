import UIKit

class ARAddorViewVC: UIViewController {

    var delegate: ARAddorViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewDiagrams = UIButton()
        viewDiagrams.setTitle("View Diagrams", for: .normal)
        viewDiagrams.titleLabel?.font = UIFont(name: "Avenir-Black", size: 25)
        viewDiagrams.setTitleColor(UIColor(named: "PinkAccentDark"), for: .normal)
        viewDiagrams.addTarget(self, action: #selector(hitView), for: .touchUpInside)

        let addDiagrams = UIButton()
        addDiagrams.setTitle("Add Diagrams", for: .normal)
        addDiagrams.titleLabel?.font = UIFont(name: "Avenir-Black", size: 25)
        addDiagrams.setTitleColor(UIColor(named: "PinkAccentDark"), for: .normal)
        addDiagrams.backgroundColor = UIColor(hex: "#F2F2F2")
        addDiagrams.addTarget(self, action: #selector(hitAdd), for: .touchUpInside)

        view.addSubview(viewDiagrams)
        view.addSubview(addDiagrams)

        viewDiagrams.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: viewDiagrams, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: viewDiagrams, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: viewDiagrams, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: viewDiagrams, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true

        addDiagrams.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: addDiagrams, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addDiagrams, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addDiagrams, attribute: .top, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addDiagrams, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

        view.clipsToBounds = true
        view.backgroundColor = .white
    }

    @objc
    func hitAdd() {
        dismiss(animated: true) {
            self.delegate?.hitAddAr()
        }
    }

    @objc
    func hitView() {
        dismiss(animated: true) {
            self.delegate?.hitViewAr()
        }
    }
}

protocol ARAddorViewDelegate {
    func hitAddAr()
    func hitViewAr()
}
