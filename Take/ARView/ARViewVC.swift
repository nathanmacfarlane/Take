import ARKit
import SceneKit
import UIKit

class ARViewVC: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    var sceneView: ARSCNView!

    var route: Route?
    var diagrams: [ArImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView = ARSCNView()
        sceneView.delegate = self
        sceneView.session.delegate = self
        view.addSubview(sceneView)

        var referenceImages: [ARReferenceImage] = []
        for (i, diagram) in diagrams.enumerated() {
            guard let bgImage = diagram.bgImage, let cgImage = bgImage.cgImage else { return }
            let refImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 10)
            refImage.name = "\(i)"
            referenceImages.append(refImage)
        }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = Set(referenceImages)
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        sceneView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: sceneView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sceneView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sceneView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sceneView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        DispatchQueue.global(qos: .background).async {
            let plane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height)
            guard let referenceName = referenceImage.name, let index = Int(referenceName) else { return }
            let diagram = self.diagrams[index].dgImage
            plane.materials[0].diffuse.contents = diagram

            let planeNode = SCNNode(geometry: plane)
            planeNode.opacity = 1.0
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)
            //            self.planes.removeAll()
            //            self.planes.append(planeNode)
        }
    }
}
