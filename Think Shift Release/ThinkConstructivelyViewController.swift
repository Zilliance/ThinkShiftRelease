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
    @IBOutlet weak var actionStepTextVIew: KMPlaceholderTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()

    }
    
    private func setupViews() {
        
        for view in [self.wisdomTextView, self.actionStepTextVIew] as [UIView] {
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
