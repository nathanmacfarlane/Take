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
        guard !(anchor is ARPlaneAnchor) else { return }
        let sphereNode = generateSphereNode()
        DispatchQueue.main.async {
            node.addChildNode(sphereNode)
        }
    }
}
