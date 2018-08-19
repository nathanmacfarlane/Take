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
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var colorSegControl: UISegmentedControl!

    // MARK: - variables
    var theRoute: Route!
    var theImage: UIImage!
    var path = UIBezierPath()
    var startPoint = CGPoint()
    var touchPoint = CGPoint()
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
    @IBAction func colorSegChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.paintColor = .red
        case 1:
            self.paintColor = .blue
        default: break
        }
    }

    // MARK: - Navigation
    @IBAction func goBackWithoutSave(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func goBack(_ sender: Any) {

        if self.theRoute.newARDiagrams == nil {
            self.theRoute.newARDiagrams = [ARDiagram(bgImage: self.myImageView.image!, diagram: self.canvasView.asImage())]
        } else {
            self.theRoute.newARDiagrams?.append(ARDiagram(bgImage: self.myImageView.image!, diagram: self.canvasView.asImage()))
        }
        self.removeLines()
        self.dismiss(animated: true, completion: nil)
    }

}
