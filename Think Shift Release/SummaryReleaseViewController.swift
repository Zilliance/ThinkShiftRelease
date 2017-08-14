//
//  SummaryReleaseViewController.swift
//  Think Shift Release
//
//  Created by ricardo hernandez  on 8/10/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class SummaryReleaseViewController: UIViewController, SummaryItemViewController {

    @IBOutlet weak var intentionLabel: UILabel!
    @IBOutlet weak var affirmationLabel: UILabel!
    @IBOutlet weak var contentView: UIScrollView!
    
    
    @IBOutlet weak var intentionCard: CardView!
    @IBOutlet weak var affirmationCard: CardView!
    
    var goto: ((SummaryGoto) -> ())? = nil
    
    var stressor: Stressor? = nil {
        didSet {
            self.intentionLabel.text = stressor?.releaseIntention
            self.affirmationLabel.text = stressor?.releaseAffirmation
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.intentionCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(intentionTap)))
        self.affirmationCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(affirmationTap)))

    }
}

extension SummaryReleaseViewController {
    
    @objc fileprivate func intentionTap() {
        self.goto?(.release)
    }
    
    @objc fileprivate func affirmationTap() {
        self.goto?(.release)
    }
}
