import ARKit
import FontAwesome_swift
import Presentr
import SceneKit
import UIKit

class ARViewVC: UIViewController, ARSCNViewDelegate, ARSessionDelegate, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate {

    var sceneView: ARSCNView!
    var collectionView: UICollectionView!
    var compassView: UIImageView!
    var compassLabel: UILabel!

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

    var visibleArRefImage: ArImageAndRefImage?

    var locationManager = CLLocationManager()
    var userLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        initViews()

        locationManager.delegate = self

        // Start location services to get the true heading.
        locationManager.distanceFilter = 1000
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()

        //Start heading updating.
        if CLLocationManager.headingAvailable() {
            locationManager.headingFilter = 5
            locationManager.startUpdatingHeading()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.first {
            self.userLocation = userLocation
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        guard let loc = self.userLocation, let selectedLat = visibleArRefImage?.arImage.latitude, let selectedLong = visibleArRefImage?.arImage.longitude else {
            return
        }
        let visibleLocation = CLLocation(latitude: selectedLat, longitude: selectedLong)
        let heading = doComputeAngleBetweenMapPoints(fromHeading: newHeading.magneticHeading, CLLocationCoordinate2D(location: loc), CLLocationCoordinate2D(location: visibleLocation))
        compassLabel.text = "Distance: \(loc.distance(from: visibleLocation))"
        UIView.animate(withDuration: 0.2) {
            self.compassView.transform = CGAffineTransform(rotationAngle: CGFloat(self.degreesToRadians(degrees: heading)))
        }
    }

    private func doComputeAngleBetweenMapPoints(
        fromHeading: CLLocationDirection,
        _ fromPoint: CLLocationCoordinate2D,
        _ toPoint: CLLocationCoordinate2D
        ) -> CLLocationDirection {
        let bearing = getBearing(point1: fromPoint, point2: toPoint)
        var theta = bearing - fromHeading
        if theta < 0 {
            theta += 360
        }
        return theta
    }

    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }

    private func getBearing(point1: CLLocationCoordinate2D, point2: CLLocationCoordinate2D) -> Double {
        let lat1 = degreesToRadians(degrees: point1.latitude)
        let lon1 = degreesToRadians(degrees: point1.longitude)
        let lat2 = degreesToRadians(degrees: point2.latitude)
        let lon2 = degreesToRadians(degrees: point2.longitude)
        let dLon = lon2 - lon1
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        var radiansBearing = atan2(y, x)
        if radiansBearing < 0 {
            radiansBearing += 2 * Double.pi
        }
        return radiansToDegrees(radians: radiansBearing)
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
        visibleArRefImage = arAndRef
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

    @objc
    func hitMap() {
        let presenter = Presentr(presentationType: .alert)
        presenter.cornerRadius = 15
        presenter.backgroundColor = .black
        presenter.backgroundOpacity = 0.5
        presenter.transitionType = .crossDissolve
        presenter.dismissAnimated = false
        let mapVC = TestMapVC()
        mapVC.searchBarVisible = false
        mapVC.view.clipsToBounds = true
        for r in Array(diagrams.keys) {
            for arImage in diagrams[r] ?? [] {
                guard let lat = arImage.latitude, let long = arImage.longitude else { continue }
                _ = mapVC.mapView.addMarker(lat: lat, long: long, title: r.name)
            }
        }
        self.customPresentViewController(presenter, viewController: mapVC, animated: true)
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

        let mapButton = UIButton()
        mapButton.setTitle(String.fontAwesomeIcon(name: .mapPin), for: .normal)
        mapButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        mapButton.setTitleColor(.black, for: .normal)
        mapButton.addTarget(self, action: #selector(hitMap), for: .touchUpInside)

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

        compassView = UIImageView()
        compassView.image = UIImage(named: "compass")

        compassLabel = LabelAvenir(size: 20, type: .Heavy, color: .black)
        compassLabel.text = "Distance: "

        view.addSubview(sceneView)
        view.addSubview(collectionView)
        view.addSubview(compassView)
        view.addSubview(compassLabel)
        view.addSubview(backButton)
        view.addSubview(mapButton)

        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: backButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: backButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: backButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: backButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true

        mapButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mapButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: mapButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: mapButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: mapButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 75).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

        compassView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: compassView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: compassView, attribute: .bottom, relatedBy: .equal, toItem: collectionView, attribute: .top, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: compassView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        NSLayoutConstraint(item: compassView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true

        compassLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: compassLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: compassLabel, attribute: .bottom, relatedBy: .equal, toItem: compassView, attribute: .top, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: compassLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: compassLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).isActive = true

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
