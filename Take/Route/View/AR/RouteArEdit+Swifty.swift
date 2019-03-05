import Presentr
import SwiftyDraw
import UIImageColors
import UIKit

extension RouteArEditVC: SwiftyDrawViewDelegate, RouteArEditMenuProtocol {

    func routeArEditMenuHitUndo() {
        canvasView.undo()
    }

    func routeArEditMenuHitClear() {
        canvasView.clear()
    }

    func routeArEditMenuChangedColor(color: UIColor?) {
        guard let color = color else { return }
        canvasView.brush.color = color
    }

    func routeArEditMenuHitSave() {
        self.dismiss(animated: true) {
            self.delegate?.finishedEditingAr(image: self.bgImageView.image, diagram: self.canvasView.asImage())
        }
    }

    func routeArEditMenuHitCancel() {
        self.dismiss(animated: true) {
            self.delegate?.canceledEditingAr()
        }
    }

    @objc
    func longPressed() {
        let presenter = Presentr(presentationType: .alert)
        presenter.cornerRadius = 15
        presenter.backgroundColor = .white
        presenter.backgroundOpacity = 0.5
        presenter.transitionType = .crossDissolve
        presenter.dismissAnimated = false
        let routeArEditMenu = RouteArEditMenu()
        routeArEditMenu.delegate = self
        routeArEditMenu.backgroundColor = self.backgroundColor
        routeArEditMenu.primaryColor = self.primaryColor
        routeArEditMenu.secondaryColor = self.secondaryColor
        routeArEditMenu.detailColor = self.detailColor
        self.customPresentViewController(presenter, viewController: routeArEditMenu, animated: true) {
            self.canvasView.undo()
        }

    }

    func swiftyDraw(shouldBeginDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) -> Bool {
        return true
    }

    func swiftyDraw(didBeginDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) {

    }

    func swiftyDraw(isDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) {

    }

    func swiftyDraw(didFinishDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) {

    }

    func swiftyDraw(didCancelDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) {

    }

}

protocol RouteArEditProtocol {
    func finishedEditingAr(image: UIImage?, diagram: UIImage?)
    func canceledEditingAr()
}
