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
            if let thought = stressor?.thinkThoughts {
                self.thoughtsLabel.text = thought
            }
            
            if let action = stressor?.thinkActionStep {
                self.actionStepLabel.text = action
            }
            
            if let innerWisdom = stressor?.thinkInnerWisdom {
                self.innerWisdomLabel.text = innerWisdom
            }

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
