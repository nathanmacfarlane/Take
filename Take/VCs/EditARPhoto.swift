//
//  EditARPhoto.swift
//  Take
//
//  Created by Family on 5/17/18.
//  Copyright © 2018 N8. All rights reserved.
//

import SwiftyDraw
import UIKit

class EditARPhoto: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var bgImageView: UIImageView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var canvasView: SwiftyDrawView!

    // MARK: - variables
    var theRoute: Route!
    var theImage: UIImage!
    var path: UIBezierPath!
    var startPoint: CGPoint!
    var touchPoint: CGPoint!
    let paintColor: UIColor = UIColor(hexString: "A6D7FF")

    override func viewDidLoad() {
        super.viewDidLoad()

//        let drawView = SwiftyDrawView(frame: self.view.frame)
//        self.view.addSubview(drawView)

        self.bgImageView.image = theImage
        self.backButton.roundButton(portion: 4)

    }

    // MARK: - Navigation
    @IBAction private func goBackWithoutSave(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction private func goBack(_ sender: Any) {
        if let presenter = presentingViewController as? RouteEdit {
            let imageId = UUID().uuidString
            presenter.newArKeys.append(imageId)
            presenter.arKeys.append(imageId)
            presenter.selectedAr.updateValue([theImage, self.canvasView.asImage()], forKey: imageId)
        }
        self.dismiss(animated: true, completion: nil)
    }

}
