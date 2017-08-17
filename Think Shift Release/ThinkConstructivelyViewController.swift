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
    @IBOutlet weak var innerWisdomDescription: UILabel!
    
    var stressor: Stressor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        self.innerWisdomDescription.attributedText = self.innerWisdomDescription.text?.learnMoreAttributedString(font: .muliLight(size: 12), color: .sectionDescriptionColor)
    }
    
    // MARK: - Learn More
    
    @IBAction func learnMoreAboutInnerWisdom(_ sender: Any?) {
        LearnMoreViewController.present(from: self, text: NSLocalizedString("inner wisdom learn more", comment: ""))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.save()
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
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
