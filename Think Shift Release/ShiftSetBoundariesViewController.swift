//
//  ShiftSetBoundariesViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/12/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class ShiftSetBoundariesViewController: UIViewController {
    
    @IBOutlet weak var talkAboutTextView: KMPlaceholderTextView!
    @IBOutlet weak var notTalkAboutTextView: KMPlaceholderTextView!
    
    var stressor: Stressor!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    private func setupView() {
        self.view.backgroundColor = .clear
    }

    @IBAction func didTapTryInstantMoodShift(_ sender: Any) {
        
    }


}

extension ShiftSetBoundariesViewController: StressorEditor {
    func save() {
        self.stressor.shiftBoundariesDoTalkWith = self.talkAboutTextView.text
        self.stressor.shiftBoundariesNotTalkWith = self.notTalkAboutTextView.text
    }
}

extension ShiftSetBoundariesViewController: UITextViewDelegate {
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
