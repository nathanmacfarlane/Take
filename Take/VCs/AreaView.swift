//
//  AreaView.swift
//  Take
//
//  Created by Family on 5/27/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit

class AreaView: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var routesButton: UIButton!
    @IBOutlet weak var areasButton: UIButton!
    @IBOutlet weak var photosButton: UIButton!
    
    // MARK: - Variables
    var areaName    : String!
    var allRoutes   : [Route]!
    var allAreas    : [String]!
    var allPhotos   : [UIImage]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLabels()
        initButtons()
        
        self.areaLabel.text = areaName
//        self.routesButton.setTitle("\(allRoutes.count) Routes", for: .normal)
//        self.areasButton.setTitle("\(allAreas.count) Areas", for: .normal)
//        self.photosButton.setTitle("\(allPhotos.count) Photos", for: .normal)
        
        self.routesButton.setTitle("\(7) Routes", for: .normal)
        self.areasButton.setTitle("\(3) Areas", for: .normal)
        self.photosButton.setTitle("\(19) Photos", for: .normal)

    }
    
    // MARK: - Initial Setup
    func initLabels() {
        self.areaLabel.roundView(portion: 2)
        self.areaLabel.addBorder(color: self.view.backgroundColor!, width: 2)
    }
    func initButtons() {
        self.routesButton.roundButton(portion: 2)
        self.areasButton.roundButton(portion: 2)
        self.photosButton.roundButton(portion: 2)
    }
    
    // MARK: - Navigation
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
