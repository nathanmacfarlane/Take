//
//  LineView.swift
//  Take
//
//  Created by Family on 5/18/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit

class LineView: UIView {

    let size: CGFloat = 150
    let lineWidth: CGFloat = 3
    var fillColor: UIColor
    var path: UIBezierPath

    func randomColor() -> UIColor {
        let hue: CGFloat = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        return UIColor(hue: hue, saturation: 0.8, brightness: 1.0, alpha: 0.8)
    }

    func trianglePathInRect(rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()

        path.moveToPoint(CGPoint(x: rect.width / 2.0, y: rect.origin.y))
        path.addLineToPoint(CGPoint(x: rect.width, y: rect.height))
        path.addLineToPoint(CGPoint(x: rect.origin.x, y: rect.height))
        path.closePath()

        return path
    }

    func randomPath() -> UIBezierPath {

        let insetRect = self.bounds.insetBy(dx: lineWidth, dy: lineWidth)

        let shapeType = arc4random() % 3

        if shapeType == 0 {
            return UIBezierPath(roundedRect: insetRect, cornerRadius: 10.0)
        }

        if shapeType == 1 {
            return UIBezierPath(ovalInRect: insetRect)
        }

        return trianglePathInRect(insetRect)
    }

    init(origin: CGPoint) {

        super.init(frame: CGRect(x: 0.0, y: 0.0, width: size, height: size))

        self.fillColor = randomColor()
        self.path = randomPath()

        self.path = randomPath()

        self.center = origin

        self.backgroundColor = UIColor.clearColor()

        initGestureRecognizers()
    }

    func initGestureRecognizers() {
        let panGR = UIPanGestureRecognizer(target: self, action: "didPan:")
        addGestureRecognizer(panGR)

        let pinchGR = UIPinchGestureRecognizer(target: self, action: "didPinch:")
        addGestureRecognizer(pinchGR)

        let rotationGR = UIRotationGestureRecognizer(target: self, action: "didRotate:")
        addGestureRecognizer(rotationGR)
    }

    func didPan(panGR: UIPanGestureRecognizer) {

        guard let theSuperview = self.superview else { return }
        theSuperview.bringSubviewToFront(self)

        var translation = panGR.translationInView(self)

        translation = CGPointApplyAffineTransform(translation, self.transform)

        self.center.x += translation.x
        self.center.y += translation.y

        panGR.setTranslation(CGPoint.zero, inView: self)
    }

    func didPinch(pinchGR: UIPinchGestureRecognizer) {

        guard let theSuperview = self.superview else { return }
        theSuperview.bringSubviewToFront(self)

        let scale = pinchGR.scale

        self.transform = CGAffineTransformScale(self.transform, scale, scale)

        pinchGR.scale = 1.0
    }

    func didRotate(rotationGR: UIRotationGestureRecognizer) {

        guard let theSuperview = self.superview else { return }
        theSuperview.bringSubviewToFront(self)

        let rotation = rotationGR.rotation

        self.transform = CGAffineTransformRotate(self.transform, rotation)

        rotationGR.rotation = 0.0
    }

    @available(*, unavailable)
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(rect: CGRect) {

        self.fillColor.setFill()
        self.path.fill()

        self.path.lineWidth = self.lineWidth
        UIColor.blackColor().setStroke()
        self.path.stroke()
    }

}
