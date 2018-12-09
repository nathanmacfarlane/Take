//
//  DeepPressGesture.swift
//  Take
//
//  Created by Family on 5/22/18.
//  Copyright © 2018 N8. All rights reserved.
//

import AudioToolbox
import UIKit.UIGestureRecognizerSubclass

class DeepPressGesture: UIGestureRecognizer {
    var vibrateOnDeepPress: Bool = true
    var threshold: CGFloat = 0.75
    var hardTriggerMinTime: TimeInterval = 0.5

    private var deepPressed: Bool = false
    private var deepPressedAt: TimeInterval = 0
    private var kPeakSoundID: UInt32 = 1519
    private var hardAction: Selector?
    private var target: AnyObject?

    required init(target: AnyObject?, action: Selector, hardAction: Selector?=nil, threshold: CGFloat = 0.75) {
        self.target = target
        self.hardAction = hardAction
        self.threshold = threshold

        super.init(target: target, action: action)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            handleTouch(touch: touch)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            handleTouch(touch: touch)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)

        state = deepPressed ? .ended : .failed

        deepPressed = false
    }

    private func handleTouch(touch: UITouch) {
//        guard let _ = view, touch.force != 0 && touch.maximumPossibleForce != 0 else {
//            return
//        }

        guard view != nil, touch.force != 0 && touch.maximumPossibleForce != 0 else {
            return
        }

        let forcePercentage = (touch.force / touch.maximumPossibleForce)
        let currentTime = NSDate.timeIntervalSinceReferenceDate

        if !deepPressed && forcePercentage >= threshold {
            state = UIGestureRecognizer.State.began

            if vibrateOnDeepPress {
                AudioServicesPlaySystemSound(kPeakSoundID)
            }

            deepPressedAt = NSDate.timeIntervalSinceReferenceDate
            deepPressed = true
        } else if deepPressed && forcePercentage <= 0 {
            endGesture()
        } else if deepPressed && currentTime - deepPressedAt > hardTriggerMinTime && forcePercentage == 1.0 {
            endGesture()

            if vibrateOnDeepPress {
                AudioServicesPlaySystemSound(kPeakSoundID)
            }

            //fire hard press
            if let hardAction = self.hardAction /*, let target = self.target*/ {
                //                target.perform(hardAction, withObject: self)
                print("state: \(state)")
                self.perform(hardAction)
            }
        }
    }

    func endGesture() {
        state = UIGestureRecognizer.State.ended
        deepPressed = false
    }
}

// MARK: DeepPressable protocol extension
protocol DeepPressable {
    var gestureRecognizers: [UIGestureRecognizer] { get set }

    func addGestureRecognizer(gestureRecognizer: UIGestureRecognizer)
    func removeGestureRecognizer(gestureRecognizer: UIGestureRecognizer)

    func setDeepPressAction(target: AnyObject, action: Selector)
    func removeDeepPressAction()
}

extension DeepPressable {
    func setDeepPressAction(target: AnyObject, action: Selector) {
        let deepPressGestureRecognizer = DeepPressGesture(target: target, action: action, threshold: 0.75)

        self.addGestureRecognizer(gestureRecognizer: deepPressGestureRecognizer)
    }

    func removeDeepPressAction() {
        if gestureRecognizers.isEmpty {
            return
        }

        for recogniser in gestureRecognizers where recogniser is DeepPressGesture {
            removeGestureRecognizer(gestureRecognizer: recogniser)
        }
    }
}
