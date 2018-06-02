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
    @IBOutlet weak var areaLabelLong: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var routesButton: UIButton!
    @IBOutlet weak var areasButton: UIButton!
    @IBOutlet weak var photosButton: UIButton!
    
    // MARK: - Variables
    var areaName    : String!
    var areaArr     : [String]?
    var allRoutes   : [Route]!
    var allAreas    : [String]!
    var allPhotos   : [UIImage]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLabels()
        initButtons()
        
        let FBPath = getFBPath()
        searchFBRoute(inArea: FBPath) { (routeIDs) in
            for routeID in routeIDs {
                searchFBRoute(byProperty: "id", withValue: routeID, completion: { (routes) in
                    self.allRoutes = routes
                    for route in routes {
                        print("go route by id: \(route.name)")
                    }
                    DispatchQueue.main.async {
                        self.routesButton.setTitle("\(routes.count+1) Routes", for: .normal)
                    }
                })
            }
        }
        
        self.areaLabel.addAbrevText(text: areaName)
        self.areaLabelLong.text = areaName
//        self.routesButton.setTitle("\(allRoutes.count) Routes", for: .normal)
//        self.areasButton.setTitle("\(allAreas.count) Areas", for: .normal)
//        self.photosButton.setTitle("\(allPhotos.count) Photos", for: .normal)
        
//        self.routesButton.setTitle("\(7) Routes", for: .normal)
//        self.areasButton.setTitle("\(3) Areas", for: .normal)
//        self.photosButton.setTitle("\(19) Photos", for: .normal)

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
    
    // MARK: - Other Functions
    func getFBPath() -> String {
        let indexOfArea = areaArr!.index(of: areaName)!
        var str = ""
        var i = 0
        while i <= indexOfArea {
            str += "/\(areaArr![i])"
            i += 1
        }
        return str
    }
    
    // MARK: - Navigation
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
