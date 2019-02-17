import ARKit
import UIKit

class RouteArViewVC: UIViewController, ARSCNViewDelegate {

    // MARK: - IBOutlets
    var sceneView: ARSCNView!

    // MARK: - Variables
    var route: Route?
    var diagrams: [UIImage] = []

    // MARK: - View load/unload
    override func viewDidLoad() {
        super.viewDidLoad()

        var refImageArr: [ARReferenceImage] = []
        var count = 0

        sceneView = ARSCNView(frame: view.frame)
        view.addSubview(sceneView)

        if let route = route {
            let arKeys = Array(route.routeArUrls.keys)
            for key in arKeys {
                guard let urls = route.routeArUrls[key] else { continue }
                urls[1].getImage { image in
                    if let image = image, let cgImage = image.cgImage {
                        self.diagrams.append(image)
                        let refImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 10)
                        refImage.name = "\(count)"
                        refImageArr.append(refImage)
                        count += 1
                        if count == arKeys.count {
                            let referenceImages = Set(refImageArr)
                            let configuration = ARWorldTrackingConfiguration()
                            configuration.detectionImages = referenceImages
                            self.sceneView.session.run(configuration)
                        }
                    }
                }
            }
        }

//        for image in theRoute?.ardiagrams ?? [] {
//            guard let cgImage = image.bgImage.cgImage else { continue }
//            let refImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 10)
//            refImage.name = "\(count)"
//            refImageArr.append(refImage)
//            count += 1
//        }

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
//            guard let route = self.route else { return }
            let diagram = self.diagrams[index]
//            var theImage = self.imageByCombiningImage(firstImage: diagram, withImage: route.ardiagrams[index].bgImage)
            //            plane.materials[0].diffuse.contents = theImage
            //            var theImage = self.theRoute!.ardiagrams![index].diagram!
            //            theImage = theImage.addTextToImage(drawText: self.theRoute!.name, atPoint: CGPoint(x: 20, y: 20))
//            theImage = theImage.textToImage(drawText: route.name, atPoint: CGPoint(x: 20, y: 20))
            plane.materials[0].diffuse.contents = diagram
            self.rotatePlane(planeMaterial: plane.materials[0])

            let planeNode = SCNNode(geometry: plane)
            planeNode.opacity = 1.0
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)
            //            self.planes.removeAll()
            //            self.planes.append(planeNode)
        }
    }

    func rotatePlane(planeMaterial: SCNMaterial) {
        let translation = SCNMatrix4MakeTranslation(0, -1, 0)
        let rotation = SCNMatrix4MakeRotation(Float.pi / 2, 0, 0, 1)
        let transform = SCNMatrix4Mult(translation, rotation)
        planeMaterial.diffuse.contentsTransform = transform
    }

    func imageByCombiningImage(firstImage: UIImage, withImage secondImage: UIImage) -> UIImage {
        let size = CGSize(width: 300, height: 300)
        UIGraphicsBeginImageContext(size)
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        firstImage.draw(in: areaSize)
        secondImage.draw(in: areaSize, blendMode: .destinationAtop, alpha: 1.0)
        guard let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return newImage
    }
}

