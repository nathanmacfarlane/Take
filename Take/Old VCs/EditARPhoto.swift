import SwiftyDraw
import UIKit

class EditARPhoto: UIViewController, SwiftyDrawViewDelegate {

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
    var hamButtonTitles: [String] = []
    var hamButtons: [(icon: String, color: UIColor, selector: Selector)] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()

        canvasView.delegate = self
        let randomInt = Int(top: hamButtons.count, bottom: 0)
//        canvasView.lineColor = hamButtons[randomInt].color

        dragHamburger = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))

        bgImageView.image = theImage
        mainImageView.image = theImage

    }

    func setupButtons() {
        hamButtons = [("undo", UIColor(red: 0.19, green: 0.57, blue: 1, alpha: 1), #selector(undo)),
        ("close", UIColor(red: 0.96, green: 0.23, blue: 0.21, alpha: 1), #selector(cancel)),
        ("done", UIColor(red: 0.23, green: 0.60, blue: 0.29, alpha: 1), #selector(save)),
        ("eraser", UIColor(red: 1, green: 0.39, blue: 0, alpha: 1), #selector(clear))]
    }

    // MARK: - Menu Buttons
    @objc
    func undo() {
//        canvasView.removeLastLine()
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
//        canvasView.clearCanvas()
    }

    // MARK: - SwiftyDraw
    func SwiftyDrawDidBeginDrawing(view: SwiftyDrawView) {

    }
    func SwiftyDrawIsDrawing(view: SwiftyDrawView) {

    }

    func SwiftyDrawDidFinishDrawing(view: SwiftyDrawView) {

    }

    func SwiftyDrawDidCancelDrawing(view: SwiftyDrawView) {

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

    // MARK: - PanGesture
    @objc
    func handleDrag(sender: UIPanGestureRecognizer? = nil) {
        
    }

}
