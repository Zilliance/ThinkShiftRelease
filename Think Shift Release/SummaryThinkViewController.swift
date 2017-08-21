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
    
    var goto: ((SummaryGoto) -> ())? = nil
    
    var stressor: Stressor? = nil {
        didSet {
            self.refreshView()
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.innerWisdomCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(innerWisdomTap)))
        self.actionStepCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionStepTap)))
        self.betterFeelingCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(betterFeelingTap)))
        self.view.layer.contents = UIImage(named: "think-bg")?.cgImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshView()
    }
    
    private func refreshView() {
        self.betterFeelingLabel.text = stressor?.thinkBetterFeeling
        self.actionStepLabel.text = stressor?.thinkActionStep
        self.innerWisdomLabel.text = stressor?.thinkInnerWisdom

    }

}

extension SummaryThinkViewController {
    @IBAction func scheduleReminderInnerWisdom(_ sender: Any?) {
        let stressor = "Stressor: \(self.stressor?.title ?? "")"
        let details = "Inner Wisdom: \(self.stressor?.thinkInnerWisdom ?? "")"
        let reminder = "\(stressor)\n\(details)"
    }
    
    @IBAction func scheduleReminderActionStep(_ sender: Any?) {
        let stressor = "Stressor: \(self.stressor?.title ?? "")"
        let details = "Action Step: \(self.stressor?.thinkActionStep ?? "")"
        let reminder = "\(stressor)\n\(details)"
    }
    
    @IBAction func scheduleReminderBetterFeelingThought(_ sender: Any?) {
        let stressor = "Stressor: \(self.stressor?.title ?? "")"
        let details = "Better Feeling Thought: \(self.stressor?.thinkBetterFeeling ?? "")"
        let reminder = "\(stressor)\n\(details)"
    }
}

extension SummaryThinkViewController {
    @objc fileprivate func innerWisdomTap() {
        self.goto?(.thinkFirstSegment)
        
    }
    
    @objc fileprivate func actionStepTap() {
        self.goto?(.thinkFirstSegment)
        
    }
    
    @objc fileprivate func betterFeelingTap() {
        self.goto?(.thinkSecondSegment)
    }
}


