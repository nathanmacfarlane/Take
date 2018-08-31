//
//  EditARPhoto.swift
//  Take
//
//  Created by Family on 5/17/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit

class EditARPhoto: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var myImageView: UIImageView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private var panGesture: UIPanGestureRecognizer!
    @IBOutlet private weak var canvasView: UIView!
    @IBOutlet private weak var colorSegControl: UISegmentedControl!

    // MARK: - variables
    var theRoute: Route!
    var theImage: UIImage = UIImage()
    var path: UIBezierPath = UIBezierPath()
    var startPoint: CGPoint = CGPoint()
    var touchPoint: CGPoint = CGPoint()
    var paintColor: UIColor = .red

    override func viewDidLoad() {
        super.viewDidLoad()

        canvasView.clipsToBounds = true
        canvasView.isMultipleTouchEnabled = false

        self.myImageView.image = theImage
        self.backButton.roundButton(portion: 4)

    }

    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.location(in: self.canvasView) {
            startPoint = point
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.location(in: self.canvasView) {
            touchPoint = point
        }

        path.move(to: startPoint)
        path.addLine(to: touchPoint)
        startPoint = touchPoint
        draw()
    }
    func draw() {
        let strokeLayer = CAShapeLayer()
        strokeLayer.fillColor = nil
        strokeLayer.lineWidth = 5
        strokeLayer.strokeColor = paintColor.cgColor
        strokeLayer.path = path.cgPath
        self.canvasView.layer.addSublayer(strokeLayer)
        self.canvasView.setNeedsDisplay()
    }
    func removeLines() {
        path.removeAllPoints()
        canvasView.layer.sublayers = nil
        canvasView.setNeedsDisplay()
    }

    // MARK: SegControl
    @IBAction private func colorSegChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.paintColor = .red
        case 1:
            self.paintColor = .blue
        default: break
        }
    }

    // MARK: - Navigation
    @IBAction private func goBackWithoutSave(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction private func goBack(_ sender: Any) {
        if let presenter = presentingViewController as? RouteEdit {
            let imageId = UUID().uuidString
            presenter.newArKeys.append(imageId)
            presenter.arKeys.append(imageId)
            presenter.selectedAr.updateValue([theImage, self.canvasView.asImage()], forKey: imageId)
        }
        self.removeLines()
        self.dismiss(animated: true, completion: nil)
    }

}
