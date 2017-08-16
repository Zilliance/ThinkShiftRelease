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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.save()
    }

    private func setupView() {
        self.view.backgroundColor = .clear
        
        if let talkWith = self.stressor.shiftBoundariesDoTalkWith {
            self.talkAboutTextView.text = talkWith
        }
        
        if let notTalkWith = self.stressor.shiftBoundariesNotTalkWith {
            self.notTalkAboutTextView.text = notTalkWith
        }
    }

    @IBAction func didTapTryInstantMoodShift(_ sender: Any) {
        
    }

}

extension ShiftSetBoundariesViewController: StressorEditor {
    func save() {
        self.stressor.shiftBoundariesDoTalkWith = self.talkAboutTextView.text.characters.count > 0 ? self.talkAboutTextView.text : nil
        self.stressor.shiftBoundariesNotTalkWith = self.notTalkAboutTextView.text.characters.count > 0 ? self.notTalkAboutTextView.text : nil
    }
}

extension ShiftSetBoundariesViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
