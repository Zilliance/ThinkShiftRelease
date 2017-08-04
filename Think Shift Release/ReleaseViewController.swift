//
//  ReleaseViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/12/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class ReleaseViewController: UIViewController {

    @IBOutlet weak var affirmationTextView: KMPlaceholderTextView!
    @IBOutlet weak var intentionTextView: KMPlaceholderTextView!
    @IBOutlet weak var containerView: UIView!
    
    var stressor: Stressor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        
        if let affirmation = self.stressor.releaseAffirmation {
            self.affirmationTextView.text = affirmation
        }
        
        if let intention = self.stressor.releaseIntention {
            self.intentionTextView.text = intention
        }
        
        for view in [self.affirmationTextView, intentionTextView, self.containerView] as [UIView] {
            view.layer.cornerRadius = UIMock.Appearance.cornerRadius
            view.layer.borderColor = UIColor.silverColor.cgColor
            view.layer.borderWidth = 1
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Summary", style: .plain, target: self, action: #selector(viewSummary(_:)))
    }
    
    // MARK: -
    
    @IBAction func viewSummary(_ sender: Any?) {
        
        guard let vc = UIStoryboard(name: "SummaryTableViewController", bundle: nil).instantiateInitialViewController() as? SummaryTableViewController else {
            assertionFailure()
            return
        }
        vc.stressor = self.stressor
        let nc = UINavigationController(rootViewController: vc)
        self.present(nc, animated: true, completion: nil)
    }
    
}

extension ReleaseViewController: StressorEditor {
    func save() {
        self.stressor.releaseIntention = self.intentionTextView.text
        self.stressor.releaseAffirmation = self.affirmationTextView.text
    }
}

extension ReleaseViewController: UITextViewDelegate {
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
