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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        
        for view in [self.affirmationTextView, intentionTextView, self.containerView] as [UIView] {
            view.layer.cornerRadius = UIMock.Appearance.cornerRadius
            view.layer.borderColor = UIColor.silverColor.cgColor
            view.layer.borderWidth = 1
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Summary", style: .plain, target: self, action: #selector(viewSummary(_:)))
    }
    
    // MARK: -
    
    @IBAction func viewSummary(_ sender: Any?) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SummaryNavigation")
        self.present(vc, animated: true, completion: nil)
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
