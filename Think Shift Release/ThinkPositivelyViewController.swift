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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }

    private func setupViews() {
        self.textView.layer.cornerRadius = UIMock.Appearance.cornerRadius
        self.textView.layer.borderWidth = 1
        self.textView.layer.borderColor = UIColor.silverColor.cgColor
    }
}
