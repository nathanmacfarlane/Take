import ARKit
import SceneKit
import UIKit

class RouteArViewVC: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    // MARK: - IBOutlets
    var sceneView: ARSCNView!

    // MARK: - Variables
    var route: Route?
    var diagrams: [UIImage] = []
    var configuration: ARWorldTrackingConfiguration?
//    var diagrams: [ARReferenceImage] = []

    // MARK: - View load/unload
    override func viewDidLoad() {
        super.viewDidLoad()

//        var refImageArr: [ARReferenceImage] = []
//        var count = 0

        sceneView = ARSCNView()
        sceneView.delegate = self
        sceneView.session.delegate = self
        view.addSubview(sceneView)

//        let referenceImages = Set(diagrams)
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.detectionImages = referenceImages
//        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        var refImageArr: [ARReferenceImage] = []
        var count = 0

        let config = ARImageTrackingConfiguration()
        sceneView.session.run(config)

//        if let route = route {
//            let arKeys = Array(route.routeArUrls.keys)
//            for key in arKeys {
//                guard let urls = route.routeArUrls[key] else { continue }
//                urls[1].getImage { image in
//                    if let image = image, let cgImage = image.cgImage {
//                        self.diagrams.append(image)
//                        let refImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 10)
//                        refImage.name = "\(count)"
//                        refImageArr.append(refImage)
//                        count += 1
//                        if count == arKeys.count {
//                            let referenceImages = Set(refImageArr)
//                            self.configuration = ARWorldTrackingConfiguration()
//                            guard let configuration = self.configuration else { return }
//                            configuration.detectionImages = referenceImages
//                            DispatchQueue.main.async {
//                                self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
//                            }
//                        }
//                    }
//                }
//            }
//        }

    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        DispatchQueue.global(qos: .background).async {
            let plane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height)
            guard let referenceName = referenceImage.name, let index = Int(referenceName) else { return }
            let diagram = self.diagrams[index]
            plane.materials[0].diffuse.contents = diagram
            self.rotatePlane(planeMaterial: plane.materials[0])

            let planeNode = SCNNode(geometry: plane)
            planeNode.opacity = 1.0
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)
        }
    }

    func rotatePlane(planeMaterial: SCNMaterial) {
        let translation = SCNMatrix4MakeTranslation(0, -1, 0)
        let rotation = SCNMatrix4MakeRotation(Float.pi / 2, 0, 0, 1)
        let transform = SCNMatrix4Mult(translation, rotation)
        planeMaterial.diffuse.contentsTransform = transform
    }
}
