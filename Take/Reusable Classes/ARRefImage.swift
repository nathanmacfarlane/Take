import ARKit
import Foundation

class ARRefImage: ARReferenceImage {
    var route: Route?
    var index: Int?

    override init(_ image: CGImage, orientation: CGImagePropertyOrientation, physicalWidth: CGFloat) {
        super.init(image, orientation: orientation, physicalWidth: physicalWidth)
    }
    convenience init(_ image: CGImage, orientation: CGImagePropertyOrientation, physicalWidth: CGFloat, route: Route, index: Int) {
        self.init(image, orientation: orientation, physicalWidth: physicalWidth)
        self.route = route
        self.index = index
    }
}
