//
//  ARView.swift
//  Take
//
//  Created by Family on 5/22/18.
//  Copyright © 2018 N8. All rights reserved.
//

import ARKit
import UIKit

class ARView: UIViewController, ARSCNViewDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!

    // MARK: - Variables
    var theRoute: Route?
    //    var planes: [SCNNode] = []

    // MARK: - View load/unload
    override func viewDidLoad() {
        super.viewDidLoad()

        closeButton.roundButton(portion: 4)

        var refImageArr: [ARReferenceImage] = []

        print("adding \(theRoute?.ardiagrams?.count ?? 0) to ref images")

        var count = 0
        for image in theRoute?.ardiagrams ?? [] {
            let cgImage = image.bgImage.cgImage!
            let refImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 10)
            refImage.name = "\(count)"
            refImageArr.append(refImage)
            count += 1
        }
        let referenceImages = Set(refImageArr)
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        sceneView.session.run(configuration)

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    // MARK: - ARView
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        DispatchQueue.global(qos: .background).async {
            let plane = SCNPlane(width: referenceImage.physicalSize.width,
                                 height: referenceImage.physicalSize.height)
            let index = Int(referenceImage.name!)!
            var theImage = self.imageByCombiningImage(firstImage: self.theRoute!.ardiagrams![index].diagram!, withImage: self.theRoute!.ardiagrams![index].bgImage)
            //            plane.materials[0].diffuse.contents = theImage
            //            var theImage = self.theRoute!.ardiagrams![index].diagram!
            //            theImage = theImage.addTextToImage(drawText: self.theRoute!.name, atPoint: CGPoint(x: 20, y: 20))
            theImage = theImage.textToImage(drawText: self.theRoute!.name, atPoint: CGPoint(x: 20, y: 20))
            plane.materials[0].diffuse.contents = theImage
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
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    // MARK: - Navigation
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
