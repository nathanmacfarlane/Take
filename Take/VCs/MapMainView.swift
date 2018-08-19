//
//  MapMainView.swift
//  Take
//
//  Created by Nathan Macfarlane on 7/14/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit

class MapMainView: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var browseButton: UIButton!

    // MARK: - view load/unload
    override func viewDidLoad() {
        super.viewDidLoad()

        self.browseButton.roundButton(portion: 2)

    }

}
