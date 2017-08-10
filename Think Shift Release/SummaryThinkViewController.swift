//
//  SummaryThinkViewController.swift
//  Think Shift Release
//
//  Created by ricardo hernandez  on 8/10/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class SummaryThinkViewController: UIViewController, SummaryItemViewController {


    @IBOutlet weak var thoughtsLabel: UILabel!
    @IBOutlet weak var innerWisdomLabel: UILabel!
    @IBOutlet weak var actionStepLabel: UILabel!
    
    var stressor: Stressor? = nil {
        didSet {
            self.thoughtsLabel.text = stressor?.thinkThoughts
            self.actionStepLabel.text = stressor?.thinkActionStep
            self.innerWisdomLabel.text = stressor?.thinkInnerWisdom
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
