//
//  ARView.swift
//  Take
//
//  Created by Family on 5/22/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit
import ARKit

class ARView: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    
    // MARK: - View load/unload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.roundButton(portion: 4)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    // MARK: - Navigation
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
