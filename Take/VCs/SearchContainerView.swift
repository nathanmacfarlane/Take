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
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var distanceSlider: UISlider!
    @IBOutlet private weak var topRopeButton: UIButton!
    @IBOutlet private weak var sportButton: UIButton!
    @IBOutlet private weak var tradButton: UIButton!
    @IBOutlet private weak var boulderButton: UIButton!
    @IBOutlet private weak var minMinusButton: UIButton!
    @IBOutlet private weak var minPlusButton: UIButton!
    @IBOutlet private weak var maxMinusButton: UIButton!
    @IBOutlet private weak var maxPlusButton: UIButton!
    @IBOutlet private weak var minDifficultyLabel: UILabel!
    @IBOutlet private weak var maxDifficultyLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var pitchesSeg: UISegmentedControl!

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
    @IBAction private func distanceChanged(_ sender: UISlider) {
        distance = Int(distanceSlider.value)
        distanceLabel.text = "Max Distance: \(Int(distanceSlider.value)) m"
    }
    // MARK: Tapped Type
    @IBAction private func tappedTopRope(_ sender: Any) {
        topRope = toggleButton(myButton: self.topRopeButton, myBool: topRope)
    }
    @IBAction private func tappedSport(_ sender: Any) {
        sport = toggleButton(myButton: self.sportButton, myBool: sport)
    }
    @IBAction private func tappedTrad(_ sender: Any) {
        trad = toggleButton(myButton: self.tradButton, myBool: trad)
    }
    @IBAction private func tappedBoulder(_ sender: Any) {
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
    @IBAction private func minMinusPressed(_ sender: UIButton) {
        minDiff -= 1
        if minDiff < 0 {
            minDiff = 0
            return
        }
        self.minDifficultyLabel.text = ratings[minDiff]
    }
    @IBAction private func minPlusPressed(_ sender: UIButton) {
        minDiff += 1
        if minDiff == maxDiff {
            minDiff -= 1
            return
        }
        if minDiff > 15 {
            minDiff = 15
            return
        }
        self.minDifficultyLabel.text = ratings[minDiff]
    }
    @IBAction private func maxMinusPressed(_ sender: UIButton) {
        maxDiff -= 1
        if maxDiff == minDiff {
            maxDiff += 1
            return
        }
        if maxDiff < 0 {
            maxDiff = 0
            return
        }
        self.maxDifficultyLabel.text = ratings[maxDiff]
    }
    @IBAction private func maxPlusPressed(_ sender: UIButton) {
        maxDiff += 1
        if maxDiff > 15 {
            maxDiff = 15
            return
        }
        self.maxDifficultyLabel.text = ratings[maxDiff]
    }
    // MARK: Stars
    @IBAction private func starsChanged(_ sender: UISlider) {
        stars = Double(sender.value)
        self.starsLabel.text = "\(String(repeating: "★", count: Int(stars)))\(String(repeating: "☆", count: 4 - Int(stars)))"
    }

    @IBAction private func pitchesChanged(_ sender: UISegmentedControl) {
        pitches = sender.selectedSegmentIndex
        if pitches == 0 {
            pitches = Int(UInt32.max)
        }
    }

}
