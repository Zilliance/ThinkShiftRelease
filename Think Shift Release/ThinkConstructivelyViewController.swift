//
//  ThinkConstructivelyViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/12/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class ThinkConstructivelyViewController: UIViewController {

    @IBOutlet weak var wisdomTextView: KMPlaceholderTextView!
    @IBOutlet weak var actionStepTextView: KMPlaceholderTextView!
    
    var stressor: Stressor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()

    }
    
    private func setupViews() {
        
        if let wisdom = self.stressor.thinkInnerWisdom {
            self.wisdomTextView.text = wisdom
        }
        
        if let actionStep = self.stressor.thinkActionStep {
            self.actionStepTextView.text = actionStep
        }
        
        self.view.backgroundColor = .clear
    }
    
    // MARK: - Learn More
    
    @IBAction func learnMoreAboutInnerWisdom(_ sender: Any?) {
        LearnMoreViewController.present(from: self, text: NSLocalizedString("inner wisdom learn more", comment: ""))
    }
}

extension ThinkConstructivelyViewController: StressorEditor {
    func save() {
        self.stressor.thinkInnerWisdom = self.wisdomTextView.text.characters.count > 0 ? self.wisdomTextView.text : nil
        self.stressor.thinkActionStep = self.actionStepTextView.text.characters.count > 0 ? self.actionStepTextView.text : nil
    }
}

extension ThinkConstructivelyViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            self.save()
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
