//
//  TypeAnimationLabel.swift
//  iCProVision
//
//  Created by Konrad Feiler on 25/03/16.
//  Copyright © 2016 Mathheartcode UG. All rights reserved.
//

import UIKit

public class TypeAnimationLabel: UILabel {

    /**
     interval time between each character
     */
    @IBInspectable public var characterInterval: NSTimeInterval = 0.2
    
    /**
     Setting a text immediately triggers animation
     */
    override public var text: String? {
        get {
            return super.text
        }
        set {
            if characterInterval < 0 { characterInterval = -characterInterval }
            stopped = false
            stoppedString = newValue
            let val = newValue ?? ""
            startTextTypingAnimation(val, characterInterval: characterInterval, initial: true)
        }
    }
    
    private var stopped: Bool = false
    private var stoppedString: String?
    private var animationTimer: NSTimer?

    /**
     Stop typing animation
     */
    public func stopTyping() {
        stopped = true
    }
    
    /**
     Continue typing animation
     */
    public func continueTyping() {
        guard self.stopped else {
            print("Animation is not stopped")
            return
        }
        stopped = false
        if let stoppedSubstring = stoppedString {
            startTextTypingAnimation(stoppedSubstring, characterInterval: characterInterval, initial: false)
        }
    }
    
    @objc private func updateText(timer: NSTimer) {
        guard !self.stopped else {
            super.text = stoppedString
            return
        }
        
        if let currentText = super.text, let stoppedString = stoppedString {
            if currentText.characters.count < stoppedString.characters.count {
                let index: String.Index = stoppedString.startIndex.advancedBy(currentText.characters.count + 1)
                super.text = stoppedString.substringToIndex(index)
            }
            else {
                super.text = ""
            }
            self.sizeToFit()
        }
    }
    
    private func startTextTypingAnimation(typedText: String, characterInterval: NSTimeInterval, initial: Bool) {
        if initial == true {
            super.text = ""
        }
        
        if let animationTimer = animationTimer {
            animationTimer.invalidate()
            self.animationTimer = nil
        }

        
        self.animationTimer = NSTimer.scheduledTimerWithTimeInterval(characterInterval, target: self,
                                                                     selector: #selector(TypeAnimationLabel.updateText(_:)),
                                                                     userInfo: nil, repeats: true)
        super.text = ""
        self.stopped = false
    }

}
