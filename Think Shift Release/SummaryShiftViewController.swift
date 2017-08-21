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
    @IBOutlet weak var contentView: UIScrollView!
    
    @IBOutlet weak var mediaCardHeight: NSLayoutConstraint!    
    var mediaCardHidden = false

    @IBOutlet weak var notTalkCard: CardView!
    @IBOutlet weak var talkCard: CardView!
    @IBOutlet weak var instantMoodCard: CardView!
    
    var goto: ((SummaryGoto) -> ())? = nil
    
    var stressor: Stressor? = nil {
        didSet {
          self.refreshView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (mediaCardHidden) {
            self.mediaCardHeight.constant = 0
        }
        
        self.notTalkCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(notTalkTap)))
        self.talkCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(talkTap)))
        self.instantMoodCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(instantMoodTap)))
        self.view.layer.contents = UIImage(named: "shift-bg")?.cgImage

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshView()
    }
    
    private func refreshView() {
        
        self.notTalkWithLabel.text = self.stressor?.shiftBoundariesNotTalkWith
        self.talkWithLabel.text = self.stressor?.shiftBoundariesDoTalkWith
        
    }

}

extension SummaryShiftViewController {
    @IBAction func scheduleReminderNotTalkAbout(_ sender: Any?) {
        let stressor = "Stressor: \(self.stressor?.title ?? "")"
        let details = "Boundaries - I will NOT think of talk about this stressor: \(self.stressor?.shiftBoundariesNotTalkWith ?? "")"
        let reminder = "\(stressor)\n\(details)"
    }
    
    @IBAction func scheduleReminderTalkAbout(_ sender: Any?) {
        let stressor = "Stressor: \(self.stressor?.title ?? "")"
        let details = "Boundaries - I will think of talk about this stressor: \(self.stressor?.shiftBoundariesDoTalkWith ?? "")"
        let reminder = "\(stressor)\n\(details)"
    }
    
    @IBAction func scheduleReminderMoodShifter(_ sender: Any?) {
        let stressor = "Stressor: \(self.stressor?.title ?? "")"
        let details = "When I am triggered by this stressor, I will remember to go to the Think, Shift, Release app to access my Instant Mood Shifters."
        let reminder = "\(stressor)\n\(details)"
    }
}

extension SummaryShiftViewController {
    @objc fileprivate func notTalkTap() {
        self.goto?(.shiftSecondSegment)
    }
    
    @objc fileprivate func talkTap() {
        self.goto?(.shiftSecondSegment)
    }
    
    @objc fileprivate func instantMoodTap() {
        self.goto?(.shiftFirstSegment)
    }
}
