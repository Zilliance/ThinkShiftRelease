//
//  ReleaseViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/12/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class ReleaseViewController: UIViewController, ShowsSummary {

    @IBOutlet weak var affirmationTextView: KMPlaceholderTextView!
    @IBOutlet weak var intentionTextView: KMPlaceholderTextView!
    @IBOutlet weak var stressorLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    var stressor: Stressor!
    var segment: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.save()
    }
    
    private func setupView() {
        
        self.bottomView.layer.contents = UIImage(named: "release-bg")?.cgImage
        
        if let affirmation = self.stressor.releaseAffirmation {
            self.affirmationTextView.text = affirmation
        }
        
        if let intention = self.stressor.releaseIntention {
            self.intentionTextView.text = intention
        }
        
        if let title = self.stressor.title {
            self.stressorLabel.text = "I am stressed out about \(title)"
        } else {
            self.stressorLabel.text = nil
        }
        
        if let _ = self.segment {
            
        }
        else {
            
            self.setupSummaryButton()
        }
    }
    
    // MARK: - Learn More
    
    @IBAction func learnMoreAboutIntention(_ sender: Any?) {
        LearnMoreViewController.present(from: self, text: NSLocalizedString("intention learn more", comment: ""))
    }
    
    @IBAction func learnMoreAboutAffirmation(_ sender: Any?) {
        LearnMoreViewController.present(from: self, text: NSLocalizedString("affirmation learn more", comment: ""))
    }
    
    @IBAction func learnMoreAboutBreathe(_ sender: Any?) {
        LearnMoreViewController.present(from: self, text: NSLocalizedString("breathe learn more", comment: ""))
    }
}

extension ReleaseViewController: StressorEditor {
    func save() {
        
        self.stressor.releaseIntention = self.intentionTextView.text.characters.count > 0 ? self.intentionTextView.text : nil
        self.stressor.releaseAffirmation = self.affirmationTextView.text.characters.count > 0 ? self.affirmationTextView.text : nil
    }
}

extension ReleaseViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
