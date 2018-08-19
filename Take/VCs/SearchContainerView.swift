//
//  SearchContainerView.swift
//  Take
//
//  Created by Family on 4/27/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit

class SearchContainerView: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var topRopeButton: UIButton!
    @IBOutlet weak var sportButton: UIButton!
    @IBOutlet weak var tradButton: UIButton!
    @IBOutlet weak var boulderButton: UIButton!
    @IBOutlet weak var minMinusButton: UIButton!
    @IBOutlet weak var minPlusButton: UIButton!
    @IBOutlet weak var maxMinusButton: UIButton!
    @IBOutlet weak var maxPlusButton: UIButton!
    @IBOutlet weak var minDifficultyLabel: UILabel!
    @IBOutlet weak var maxDifficultyLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var pitchesSeg: UISegmentedControl!

    // MARK: - Variables
    var topRope: Bool = true
    var sport: Bool = true
    var trad: Bool = true
    var boulder: Bool = true
    var stars: Double = 0
    var distance: Int = 25
    var minDiff: Int = 0
    var maxDiff: Int = 15
    var pitches: Int = Int(UInt32.max)
    var ratings: [String] = ["5.0", "5.1", "5.2", "5.3", "5.4", "5.5", "5.6", "5.7", "5.8", "5.9", "5.10", "5.11", "5.12", "5.13", "5.14", "5.15"]

    // MARK: - view load/unload
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - IBActions
    @IBAction func distanceChanged(_ sender: UISlider) {
        distance = Int(distanceSlider.value)
        distanceLabel.text = "Max Distance: \(Int(distanceSlider.value)) m"
    }
    // MARK: Tapped Type
    @IBAction func tappedTopRope(_ sender: Any) {
        topRope = toggleButton(myButton: self.topRopeButton, myBool: topRope)
    }
    @IBAction func tappedSport(_ sender: Any) {
        sport = toggleButton(myButton: self.sportButton, myBool: sport)
    }
    @IBAction func tappedTrad(_ sender: Any) {
        trad = toggleButton(myButton: self.tradButton, myBool: trad)
    }
    @IBAction func tappedBoulder(_ sender: Any) {
        boulder = toggleButton(myButton: self.boulderButton, myBool: boulder)
    }
    func toggleButton(myButton: UIButton, myBool: Bool) -> Bool {
        var newBool = myBool
        if newBool == true {
            myButton.setImage(UIImage(named: "unchecked.png"), for: .normal)
            newBool = false
        } else {
            myButton.setImage(UIImage(named: "checked.png"), for: .normal)
            newBool = true
        }
        return newBool
    }
    // MARK: Changed Difficulty
    @IBAction func minMinusPressed(_ sender: UIButton) {
        minDiff = minDiff - 1
        if minDiff < 0 {
            minDiff = 0
            return
        }
        self.minDifficultyLabel.text = ratings[minDiff]
    }
    @IBAction func minPlusPressed(_ sender: UIButton) {
        minDiff = minDiff + 1
        if minDiff == maxDiff {
            minDiff = minDiff - 1
            return
        }
        if minDiff > 15 {
            minDiff = 15
            return
        }
        self.minDifficultyLabel.text = ratings[minDiff]
    }
    @IBAction func maxMinusPressed(_ sender: UIButton) {
        maxDiff = maxDiff - 1
        if maxDiff == minDiff {
            maxDiff = maxDiff + 1
            return
        }
        if maxDiff < 0 {
            maxDiff = 0
            return
        }
        self.maxDifficultyLabel.text = ratings[maxDiff]
    }
    @IBAction func maxPlusPressed(_ sender: UIButton) {
        maxDiff = maxDiff + 1
        if maxDiff > 15 {
            maxDiff = 15
            return
        }
        self.maxDifficultyLabel.text = ratings[maxDiff]
    }
    // MARK: Stars
    @IBAction func starsChanged(_ sender: UISlider) {
        stars = Double(sender.value)
        self.starsLabel.text = "\(String(repeating: "★", count: Int(stars)))\(String(repeating: "☆", count: 4 - Int(stars)))"
    }

    @IBAction func pitchesChanged(_ sender: UISegmentedControl) {
        pitches = sender.selectedSegmentIndex
        if pitches == 0 {
            pitches = Int(UInt32.max)
        }
    }

}
