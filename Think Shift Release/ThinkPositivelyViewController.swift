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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.save()
    }

    private func setupViews() {
        
        if let feeling = self.stressor.thinkBetterFeeling {
            self.textView.text = feeling
        }
        
        self.view.backgroundColor = .clear
    }
    
    // MARK: - Learn More
    
    @IBAction func learnMoreAboutBetterFeelingThought(_ sender: Any?) {
        LearnMoreViewController.present(from: self, text: NSLocalizedString("better feeling thought learn more", comment: ""))
    }
}

extension ThinkPositivelyViewController: StressorEditor {
    func save() {
        self.stressor.thinkBetterFeeling = self.textView.text.characters.count > 0 ? self.textView.text : nil
    }
}

extension ThinkPositivelyViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
