import Foundation
import UIKit

extension UIView {
    func roundView(portion: CGFloat) {
        self.layer.cornerRadius = self.frame.height < self.frame.width ? self.frame.height / portion : self.frame.width / portion
        self.clipsToBounds = true
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    func addBorder(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    enum ViewSide {
        case left, right, top, bottom
    }
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {

        let border = CALayer()
        border.backgroundColor = color

        switch side {
        case .left:
            border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height)
        case .top:
            border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness)
        }

        layer.addSublayer(border)
    }
    func getOutsidePoint(side: ViewSide, padding: CGFloat) -> CGPoint {
        switch side {
        case .left:
            return CGPoint(x: frame.minX - padding, y: center.y)
        case .right:
            return CGPoint(x: frame.maxX + padding, y: center.y)
        case .top:
            return CGPoint(x: center.x, y: frame.minY - padding)
        case .bottom:
            return CGPoint(x: center.x, y: frame.maxY + padding)
        }
    }
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds

        layer.insertSublayer(gradientLayer, at: 0)
    }
}
