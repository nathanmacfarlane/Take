//
//  EditARPhoto.swift
//  Take
//
//  Created by Family on 5/17/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit

class EditARPhoto: UIViewController {

    // IBOutlets
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    @IBOutlet weak var canvasView: UIView!
    
    // variables
    var theRoute: Route!
    var theImage: UIImage!
    var path = UIBezierPath()
    var startPoint = CGPoint()
    var touchPoint = CGPoint()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canvasView.clipsToBounds = true
        canvasView.isMultipleTouchEnabled = false
        
        self.myImageView.image = theImage
        self.backButton.roundButton(portion: 4)
        
    }
    
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
        
        // call draw
        draw()
    }
    
    func draw() {
        let strokeLayer = CAShapeLayer()
        strokeLayer.fillColor = nil
        strokeLayer.lineWidth = 5
        strokeLayer.strokeColor = UIColor.red.cgColor
        strokeLayer.path = path.cgPath
        self.canvasView.layer.addSublayer(strokeLayer)
        self.canvasView.setNeedsDisplay()
    }
    
    @IBAction func goBack(_ sender: Any) {
        if self.theRoute.ardiagrams == nil {
            self.theRoute.ardiagrams = [ARDiagram(bgImage: self.myImageView.image!, diagram: self.canvasView.asImage())]
        } else {
            self.theRoute.ardiagrams?.append(ARDiagram(bgImage: self.myImageView.image!, diagram: self.canvasView.asImage()))
        }
        self.removeLines()
        self.dismiss(animated: true, completion: nil)
    }
    
    func removeLines() {
        path.removeAllPoints()
        canvasView.layer.sublayers = nil
        canvasView.setNeedsDisplay()
    }
    
}
