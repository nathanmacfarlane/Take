import ARKit
//import Blueprints
import SceneKit
import UIKit

class ARViewVC: UIViewController, ARSCNViewDelegate, ARSessionDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    var sceneView: ARSCNView!
    var collectionView: UICollectionView!

    var route: Route?
    var diagrams: [Route: [ArImage]] = [:]
    var refImages: [ARRefImage] {
        var temp: [ARRefImage] = []
        for (route, arImages) in diagrams {
            for (i, arImage) in arImages.enumerated() {
                guard let dgImage = arImage.bgImage, let cgDgImage = dgImage.cgImage else { continue }
                temp.append(ARRefImage(cgDgImage, orientation: .up, physicalWidth: 10, route: route, index: i))
            }
        }
        return temp
    }

    struct ArImageAndRefImage {
        var arImage: ArImage
        var refImage: ARRefImage
    }

    var activeImages: [SCNNode: ArImageAndRefImage] = [:]
    var nodes: [SCNNode] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        initViews()

    }

    @objc
    func hitBack() {
        dismiss(animated: true, completion: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activeImages.keys.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let node = nodes[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoutePhotoCVCell", for: indexPath) as? RoutePhotosCVC,
            let arAndRef = activeImages[node] else { return UICollectionViewCell() }
        cell.dgImageView.image = arAndRef.arImage.dgImage
        cell.bgImageView.image = arAndRef.arImage.bgImage
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let node = nodes[indexPath.row]
        for n in nodes where n != node {
            n.isHidden = true
        }
        node.isHidden = false
        guard let arAndRef = activeImages[node] else { return }
        add(arAndRef: arAndRef, to: node, imageIndex: indexPath.row)
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor,
            let referenceImage = imageAnchor.referenceImage as? ARRefImage,
            let route = (imageAnchor.referenceImage as? ARRefImage)?.route,
            let index = (imageAnchor.referenceImage as? ARRefImage)?.index,
            let arImage = self.diagrams[route]?[index] else { return }
        DispatchQueue.global(qos: .background).async {
            self.nodes.append(node)
            self.activeImages[node] = ArImageAndRefImage(arImage: arImage, refImage: referenceImage)
            DispatchQueue.main.async {
                self.collectionView.insertItems(at: [IndexPath(row: self.nodes.count - 1, section: 0)])
            }
        }
    }

    func add(arAndRef: ArImageAndRefImage, to node: SCNNode, imageIndex: Int) {
        let plane = SCNPlane(width: arAndRef.refImage.physicalSize.width, height: arAndRef.refImage.physicalSize.height)
        guard let dgImage = arAndRef.arImage.dgImage else { return }
//        let tti = textToImage(drawText: arAndRef.refImage.route?.name ?? "NO NAME", inImage: dgImage, atPoint: CGPoint(x: dgImage.size.width / 2, y: dgImage.size.height - 100))
        plane.materials[0].diffuse.contents = dgImage
        let planeNode = SCNNode(geometry: plane)
        planeNode.opacity = 1.0
        planeNode.eulerAngles.x = -.pi / 2
        node.addChildNode(planeNode)
    }

    func initViews() {

        sceneView = ARSCNView()
        sceneView.delegate = self
        sceneView.session.delegate = self

        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = Set(refImages)
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        let backButton = UIButton()
        backButton.setTitle("Close", for: .normal)
        backButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 18)
        backButton.setTitleColor(.black, for: .normal)
        backButton.addTarget(self, action: #selector(hitBack), for: .touchUpInside)

//        let blueprintLayout = HorizontalBlueprintLayout(
//            itemsPerRow: view.frame.width / 75,
//            itemsPerColumn: 1,
//            itemSize: CGSize(width: 75, height: 75),
//            minimumInteritemSpacing: 10,
//            minimumLineSpacing: 10,
//            sectionInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
//            stickyHeaders: true,
//            stickyFooters: true
//        )

//        blueprintLayout.scrollDirection = .horizontal
//        collectionView = UICollectionView(frame: .zero, collectionViewLayout: blueprintLayout)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.scrollDirection = .horizontal

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.register(RoutePhotosCVC.self, forCellWithReuseIdentifier: "RoutePhotoCVCell")
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false

        view.addSubview(sceneView)
        view.addSubview(collectionView)
        view.addSubview(backButton)

        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: backButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: backButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: backButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: backButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 75).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

        sceneView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: sceneView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sceneView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sceneView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sceneView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }

    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.white
        guard let textFont = UIFont(name: "Avenir-Black", size: 35) else { return UIImage() }
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        let textFontAttributes = [NSAttributedString.Key.font: textFont, NSAttributedString.Key.foregroundColor: textColor] as [NSAttributedString.Key: Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }
}
