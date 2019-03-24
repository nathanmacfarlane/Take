import UIKit

class RouteArEditMenu: UIViewController {

    // injections
    var delegate: RouteArEditMenuProtocol?
    var backgroundColor: UIColor?
    var primaryColor: UIColor?
    var secondaryColor: UIColor?
    var detailColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let colorButton1 = ArColorButton(color: backgroundColor)
        colorButton1.addTarget(self, action: #selector(selectedColorButton(sender:)), for: .touchUpInside)
        let colorButton2 = ArColorButton(color: primaryColor)
        colorButton2.addTarget(self, action: #selector(selectedColorButton(sender:)), for: .touchUpInside)
        let colorButton3 = ArColorButton(color: secondaryColor)
        colorButton3.addTarget(self, action: #selector(selectedColorButton(sender:)), for: .touchUpInside)
        let colorButton4 = ArColorButton(color: detailColor)
        colorButton4.addTarget(self, action: #selector(selectedColorButton(sender:)), for: .touchUpInside)

        let undoButton = ArActionButton(color: UIColor(named: "BluePrimaryDark"), title: "Undo")
        undoButton.addTarget(self, action: #selector(goUndo), for: .touchUpInside)

        let clearButton = ArActionButton(color: UIColor(named: "PinkAccentDark"), title: "Clear")
        clearButton.addTarget(self, action: #selector(goClear), for: .touchUpInside)

        let cancelButton = UIButton()
        cancelButton.setTitle("Close", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 18)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.addTarget(self, action: #selector(goCancel), for: .touchUpInside)

        let saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 18)
        saveButton.setTitleColor(UIColor(named: "PinkAccentDark"), for: .normal)
        saveButton.addTarget(self, action: #selector(goSave), for: .touchUpInside)

        view.addSubview(cancelButton)
        view.addSubview(saveButton)
        view.addSubview(undoButton)
        view.addSubview(clearButton)
        view.addSubview(colorButton1)
        view.addSubview(colorButton2)
        view.addSubview(colorButton3)
        view.addSubview(colorButton4)

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: cancelButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: cancelButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: cancelButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: cancelButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -10).isActive = true

        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: saveButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -10).isActive = true

        // action buttons
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: undoButton, attribute: .centerX, relatedBy: .equal, toItem: cancelButton, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: undoButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120).isActive = true
        NSLayoutConstraint(item: undoButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: undoButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 10).isActive = true

        clearButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: clearButton, attribute: .centerX, relatedBy: .equal, toItem: saveButton, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: clearButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120).isActive = true
        NSLayoutConstraint(item: clearButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: clearButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 10).isActive = true

        // color buttons
        colorButton1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: colorButton1, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: colorButton1, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: colorButton1, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35).isActive = true
        NSLayoutConstraint(item: colorButton1, attribute: .width, relatedBy: .equal, toItem: colorButton1, attribute: .height, multiplier: 1, constant: 0).isActive = true

        colorButton2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: colorButton2, attribute: .leading, relatedBy: .equal, toItem: colorButton1, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: colorButton2, attribute: .top, relatedBy: .equal, toItem: colorButton1, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: colorButton2, attribute: .height, relatedBy: .equal, toItem: colorButton1, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: colorButton2, attribute: .width, relatedBy: .equal, toItem: colorButton1, attribute: .width, multiplier: 1, constant: 0).isActive = true

        colorButton3.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: colorButton3, attribute: .leading, relatedBy: .equal, toItem: colorButton2, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: colorButton3, attribute: .top, relatedBy: .equal, toItem: colorButton1, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: colorButton3, attribute: .height, relatedBy: .equal, toItem: colorButton1, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: colorButton3, attribute: .width, relatedBy: .equal, toItem: colorButton1, attribute: .width, multiplier: 1, constant: 0).isActive = true

        colorButton4.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: colorButton4, attribute: .leading, relatedBy: .equal, toItem: colorButton3, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: colorButton4, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: colorButton4, attribute: .top, relatedBy: .equal, toItem: colorButton1, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: colorButton4, attribute: .height, relatedBy: .equal, toItem: colorButton1, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: colorButton4, attribute: .width, relatedBy: .equal, toItem: colorButton1, attribute: .width, multiplier: 1, constant: 0).isActive = true
    }

    @objc
    func goClear() {
        self.delegate?.routeArEditMenuHitClear()
        self.dismiss(animated: true, completion: nil)
    }

    @objc
    func goUndo() {
        self.delegate?.routeArEditMenuHitUndo()
        self.dismiss(animated: true, completion: nil)
    }

    @objc
    func selectedColorButton(sender: ArColorButton) {
        self.delegate?.routeArEditMenuChangedColor(color: sender.backgroundColor)
        self.dismiss(animated: true, completion: nil)
    }

    @objc
    func goSave() {
        self.dismiss(animated: true) {
            self.delegate?.routeArEditMenuHitSave()
        }
    }

    @objc
    func goCancel() {
        self.dismiss(animated: true) {
            self.delegate?.routeArEditMenuHitCancel()
        }
    }
}

protocol RouteArEditMenuProtocol {
    func routeArEditMenuHitClear()
    func routeArEditMenuHitUndo()
    func routeArEditMenuHitSave()
    func routeArEditMenuHitCancel()
    func routeArEditMenuChangedColor(color: UIColor?)
}
