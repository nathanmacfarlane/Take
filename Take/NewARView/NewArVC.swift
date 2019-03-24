import ARKit
import Firebase
import FirebaseStorage
import Foundation
import UIKit

class NewArVC: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    // ui
    var sceneView: ARSCNView!

    // vars
    var startPoint: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        addDragGestureToSceneView()
        let configuration = ARWorldTrackingConfiguration()
        sceneView.showsStatistics = true
        sceneView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        sceneView.session.run(configuration, options: [])
    }

    func initViews() {
        view.backgroundColor = UISettings.shared.colorScheme.backgroundPrimary

        let saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(hitSave), for: .touchUpInside)

        let loadButton = UIButton()
        loadButton.setTitle("Load", for: .normal)
        loadButton.addTarget(self, action: #selector(loadAr), for: .touchUpInside)

        sceneView = ARSCNView(frame: view.frame, options: nil)
        sceneView.session.delegate = self
        sceneView.delegate = self

        view.addSubview(sceneView)
        view.addSubview(saveButton)
        view.addSubview(loadButton)

        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: saveButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 2, constant: 0).isActive = true

        loadButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: loadButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 2, constant: 0).isActive = true
        NSLayoutConstraint(item: loadButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: loadButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
    }

    @objc
    func loadAr() {
        let storageRef = Storage.storage().reference().child("arWorlds/someWorld")
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, _ in

            guard let data = data else { return }
            guard let wm = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [ARWorldMap.classForKeyedUnarchiver()], from: data) as? ARWorldMap else { return }
            guard let worldMap = wm else { return }

            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = .horizontal
            configuration.initialWorldMap = worldMap
            self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        }
    }

    @objc
    func hitSave() {
        sceneView.session.getCurrentWorldMap { worldMap, _ in
            guard let worldMap = worldMap else { return }
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: worldMap, requiringSecureCoding: true) else {
                print("Can't Encode Map")
                return
            }
            do {
                let storageRef = Storage.storage().reference().child("arWorlds/someWorld")
                _ = storageRef.putData(data, metadata: nil) { _, _ in
                    storageRef.downloadURL { url, _ in
                        guard let downloadURL = url else {
                            print("no url")
                            return
                        }
                        print("downloadURL: \(downloadURL)")
                    }
                }
            }
        }
    }

    func addDragGestureToSceneView() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragged(_:)))
        sceneView.addGestureRecognizer(panGestureRecognizer)
    }

    @objc
    func dragged(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: sceneView)
        switch sender.state {
        case .began:
            print("touches began: \(location)")
            startPoint = location
        case .ended:
            print("touches ended: \(location)")
        case .changed:
            print("touches changed: \(location)")
        default:
            print("not handled")
        }
        guard let hitTestResult = sceneView.hitTest(location, types: [.featurePoint, .estimatedHorizontalPlane]).first
            else { return }
        let anchor = ARAnchor(transform: hitTestResult.worldTransform)
        sceneView.session.add(anchor: anchor)
    }

    func generateSphereNode() -> SCNNode {
        let sphere = SCNSphere(radius: 0.05)
        sphere.firstMaterial?.diffuse.contents = UIColor.red
        let sphereNode = SCNNode()
        sphereNode.position.y += Float(sphere.radius)
        sphereNode.geometry = sphere
        return sphereNode
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    func resetTrackingConfiguration(with worldMap: ARWorldMap? = nil) {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]

        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]

        sceneView.debugOptions = [.showFeaturePoints]
        sceneView.session.run(configuration, options: options)
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
//        print("Found plane: \(planeAnchor)")

        guard !(anchor is ARPlaneAnchor) else { return }
        let sphereNode = generateSphereNode()
        DispatchQueue.main.async {
            node.addChildNode(sphereNode)
        }
    }
}





















































//let twoPointsNode1 = SCNNode()
//sceneView.scene.rootNode.addChildNode(twoPointsNode1.buildLineInTwoPointsWithRotation(
//    from: SCNVector3(0, -5, -10), to: SCNVector3(0, 0, 0), radius: 0.05, color: .cyan))
//
//extension SCNNode {
//
//    func normalizeVector(_ iv: SCNVector3) -> SCNVector3 {
//        let length = sqrt(iv.x * iv.x + iv.y * iv.y + iv.z * iv.z)
//        if length == 0 {
//            return SCNVector3(0.0, 0.0, 0.0)
//        }
//
//        return SCNVector3( iv.x / length, iv.y / length, iv.z / length)
//
//    }
//
//    func buildLineInTwoPointsWithRotation(from startPoint: SCNVector3,
//                                          to endPoint: SCNVector3,
//                                          radius: CGFloat,
//                                          color: UIColor) -> SCNNode {
//        let w = SCNVector3(x: endPoint.x - startPoint.x,
//                           y: endPoint.y - startPoint.y,
//                           z: endPoint.z - startPoint.z)
//        let l = CGFloat(sqrt(w.x * w.x + w.y * w.y + w.z * w.z))
//
//        if l == 0.0 {
//            // two points together.
//            let sphere = SCNSphere(radius: radius)
//            sphere.firstMaterial?.diffuse.contents = color
//            self.geometry = sphere
//            self.position = startPoint
//            return self
//
//        }
//
//        let cyl = SCNCylinder(radius: radius, height: l)
//        cyl.firstMaterial?.diffuse.contents = color
//
//        self.geometry = cyl
//
//        //original vector of cylinder above 0,0,0
//        let ov = SCNVector3(0, l / 2.0, 0)
//        //target vector, in new coordination
//        let nv = SCNVector3((endPoint.x - startPoint.x) / 2.0,
//                            (endPoint.y - startPoint.y) / 2.0,
//                            (endPoint.z - startPoint.z) / 2.0)
//
//        // axis between two vector
//        let av = SCNVector3((ov.x + nv.x) / 2.0, (ov.y + nv.y) / 2.0, (ov.z + nv.z) / 2.0)
//
//        //normalized axis vector
//        let av_normalized = normalizeVector(av)
//        let q0 = Float(0.0) //cos(angel/2), angle is always 180 or M_PI
//        let q1 = Float(av_normalized.x) // x' * sin(angle/2)
//        let q2 = Float(av_normalized.y) // y' * sin(angle/2)
//        let q3 = Float(av_normalized.z) // z' * sin(angle/2)
//
//        let r_m11 = q0 * q0 + q1 * q1 - q2 * q2 - q3 * q3
//        let r_m12 = 2 * q1 * q2 + 2 * q0 * q3
//        let r_m13 = 2 * q1 * q3 - 2 * q0 * q2
//        let r_m21 = 2 * q1 * q2 - 2 * q0 * q3
//        let r_m22 = q0 * q0 - q1 * q1 + q2 * q2 - q3 * q3
//        let r_m23 = 2 * q2 * q3 + 2 * q0 * q1
//        let r_m31 = 2 * q1 * q3 + 2 * q0 * q2
//        let r_m32 = 2 * q2 * q3 - 2 * q0 * q1
//        let r_m33 = q0 * q0 - q1 * q1 - q2 * q2 + q3 * q3
//
//        self.transform.m11 = r_m11
//        self.transform.m12 = r_m12
//        self.transform.m13 = r_m13
//        self.transform.m14 = 0.0
//
//        self.transform.m21 = r_m21
//        self.transform.m22 = r_m22
//        self.transform.m23 = r_m23
//        self.transform.m24 = 0.0
//
//        self.transform.m31 = r_m31
//        self.transform.m32 = r_m32
//        self.transform.m33 = r_m33
//        self.transform.m34 = 0.0
//
//        self.transform.m41 = (startPoint.x + endPoint.x) / 2.0
//        self.transform.m42 = (startPoint.y + endPoint.y) / 2.0
//        self.transform.m43 = (startPoint.z + endPoint.z) / 2.0
//        self.transform.m44 = 1.0
//        return self
//    }
//}
