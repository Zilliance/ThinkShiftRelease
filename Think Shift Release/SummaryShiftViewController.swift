//
//  SummaryShiftViewController.swift
//  Think Shift Release
//
//  Created by ricardo hernandez  on 8/10/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class SummaryShiftViewController: UIViewController, SummaryItemViewController {
    
    @IBOutlet weak var notTalkWithLabel: UILabel!
    @IBOutlet weak var talkWithLabel: UILabel!
    
    var stressor: Stressor? = nil {
        didSet {
            self.notTalkWithLabel.text = stressor?.shiftBoundariesNotTalkWith
            self.talkWithLabel.text = stressor?.shiftBoundariesDoTalkWith
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
