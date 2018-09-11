//
//  EditARPhoto.swift
//  Take
//
//  Created by Family on 5/17/18.
//  Copyright © 2018 N8. All rights reserved.
//

import CircleMenu
import SwiftyDraw
import UIKit

class EditARPhoto: UIViewController, CircleMenuDelegate, SwiftyDrawViewDelegate {

    // MARK: - IBOutlets
    @IBOutlet private weak var bgImageView: UIImageView!
    @IBOutlet private weak var canvasView: SwiftyDrawView!
    @IBOutlet weak var mainImageView: UIImageView!

    // MARK: - variables
    var theRoute: Route!
    var theImage: UIImage!
    var path: UIBezierPath!
    var startPoint: CGPoint!
    var touchPoint: CGPoint!
    let paintColor: UIColor = UIColor(hexString: "A6D7FF")
    var dragHamburger: UIPanGestureRecognizer!
    var hamburgerButton: CircleMenu!
    var hamButtonTitles: [String] = []
    var hamButtons: [(icon: String, color: UIColor, selector: Selector)] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()

        canvasView.delegate = self
        let randomInt = Int(top: hamButtons.count, bottom: 0)
        canvasView.lineColor = hamButtons[randomInt].color

        dragHamburger = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))

        hamburgerButton = CircleMenu(
            frame: CGRect(x: 0, y: 0, width: 50, height: 50),
            normalIcon: "hamburgerMenuIcon",
            selectedIcon: "closeMenuIcon",
            buttonsCount: hamButtons.count,
            duration: 0.3,
            distance: 100)
        hamburgerButton.center = self.view.center
        hamburgerButton.delegate = self
        hamburgerButton.roundView(portion: 2)
        hamburgerButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        hamburgerButton.addGestureRecognizer(dragHamburger)
        view.addSubview(hamburgerButton)

        bgImageView.image = theImage
        mainImageView.image = theImage

    }

    func setupButtons() {
        hamButtons = [("undo", UIColor(red: 0.19, green: 0.57, blue: 1, alpha: 1), #selector(undo)),
        ("close", UIColor(red: 0.96, green: 0.23, blue: 0.21, alpha: 1), #selector(cancel)),
        ("done", UIColor(red: 0.23, green: 0.60, blue: 0.29, alpha: 1), #selector(save)),
        ("eraser", UIColor(red: 1, green: 0.39, blue: 0, alpha: 1), #selector(clear))]
    }

    // MARK: - CircleMenu
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        guard let buttonImage = UIImage(named: hamButtons[atIndex].icon) else { return }
        button.set(image: buttonImage, with: .white)
        button.backgroundColor = hamButtons[atIndex].color
        button.addTarget(self, action: hamButtons[atIndex].selector, for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }

    // MARK: - Menu Buttons
    @objc
    func undo() {
        canvasView.removeLastLine()
    }
    @objc
    func save() {
        if let presenter = presentingViewController as? RouteEdit {
            let imageId = UUID().uuidString
            presenter.newArKeys.append(imageId)
            presenter.arKeys.append(imageId)
            presenter.selectedAr.updateValue([theImage, self.canvasView.asImage()], forKey: imageId)
        }
        self.dismiss(animated: true, completion: nil)
    }
    @objc
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc
    func clear() {
        canvasView.clearCanvas()
    }

    // MARK: - SwiftyDraw
    func SwiftyDrawDidBeginDrawing(view: SwiftyDrawView) {
        hamburgerButton.hideButtons(0.0)
    }
    func SwiftyDrawIsDrawing(view: SwiftyDrawView) {

    }

    func SwiftyDrawDidFinishDrawing(view: SwiftyDrawView) {

    }

    func SwiftyDrawDidCancelDrawing(view: SwiftyDrawView) {

    }

    // MARK: - PanGesture
    @objc
    func handleDrag(sender: UIPanGestureRecognizer? = nil) {
        if sender?.state == .began {
            hamburgerButton.hideButtons(0.0)
        }
        hamburgerButton.center = sender?.location(in: self.view) ?? hamburgerButton.center
    }

}
