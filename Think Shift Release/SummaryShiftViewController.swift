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
    
    var stressor: Stressor? = nil {
        didSet {
            self.notTalkWithLabel.text = stressor?.shiftBoundariesNotTalkWith
            self.talkWithLabel.text = stressor?.shiftBoundariesDoTalkWith
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

    }

}

extension SummaryShiftViewController {
    @objc fileprivate func notTalkTap() {
        
    }
    
    @objc fileprivate func talkTap() {
        
    }
    
    @objc fileprivate func instantMoodTap() {
        
    }
}
