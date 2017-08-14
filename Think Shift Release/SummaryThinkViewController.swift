//
//  SummaryThinkViewController.swift
//  Think Shift Release
//
//  Created by ricardo hernandez  on 8/10/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class SummaryThinkViewController: UIViewController, SummaryItemViewController {


    @IBOutlet weak var innerWisdomLabel: UILabel!
    @IBOutlet weak var actionStepLabel: UILabel!
    @IBOutlet weak var betterFeelingLabel: UILabel!
    
    @IBOutlet weak var contentView: UIScrollView!
    
    @IBOutlet weak var innerWisdomCard: CardView!
    @IBOutlet weak var actionStepCard: CardView!
    @IBOutlet weak var betterFeelingCard: CardView!
    
    var stressor: Stressor? = nil {
        didSet {
            self.betterFeelingLabel.text = stressor?.thinkBetterFeeling
            self.actionStepLabel.text = stressor?.thinkActionStep
            self.innerWisdomLabel.text = stressor?.thinkInnerWisdom
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.innerWisdomCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(innerWisdomTap)))
        self.actionStepCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionStepTap)))
        self.betterFeelingCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(betterFeelingTap)))
    }

}

extension SummaryThinkViewController {
    @objc fileprivate func innerWisdomTap() {
    }
    
    @objc fileprivate func actionStepTap() {
    }
    
    @objc fileprivate func betterFeelingTap() {
    }
}


