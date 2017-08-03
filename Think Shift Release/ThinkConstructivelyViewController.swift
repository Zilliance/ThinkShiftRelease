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
        
        for view in [self.wisdomTextView, self.actionStepTextView] as [UIView] {
            view.layer.cornerRadius = UIMock.Appearance.cornerRadius
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.silverColor.cgColor
        }
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
