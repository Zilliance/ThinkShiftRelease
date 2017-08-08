//
//  ThinkPositivelyViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/12/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class ThinkPositivelyViewController: UIViewController {

    @IBOutlet weak var textView: KMPlaceholderTextView!
    
    var stressor: Stressor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }

    private func setupViews() {
        
        if let feeling = self.stressor.thinkBetterFeeling {
            self.textView.text = feeling
        }
        
        self.view.backgroundColor = .clear
    }
}

extension ThinkPositivelyViewController: StressorEditor {
    func save() {
        self.stressor.thinkBetterFeeling = textView.text
    }
}

extension ThinkPositivelyViewController: UITextViewDelegate {
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
