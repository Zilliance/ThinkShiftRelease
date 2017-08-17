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
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var affirmationLabel: UILabel!
    @IBOutlet weak var contentView: UIScrollView!
    
    
    @IBOutlet weak var intentionCard: CardView!
    @IBOutlet weak var experienceCard: CardView!
    @IBOutlet weak var affirmationCard: CardView!
    @IBOutlet weak var breatheCardHeight: NSLayoutConstraint!
    
    var breatheCardHidden = false
    
    var goto: ((SummaryGoto) -> ())? = nil
    
    var stressor: Stressor? = nil {
        didSet {
            self.refreshView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.breatheCardHidden) {
            self.breatheCardHeight.constant = 0
        }
        
        self.intentionCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(intentionTap)))
        self.experienceCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(intentionTap)))
        self.affirmationCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(affirmationTap)))
        self.view.layer.contents = UIImage(named: "release-bg")?.cgImage

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshView()
    }
    
    private func refreshView() {
        self.intentionLabel.text = stressor?.releaseMyIntention
        self.experienceLabel.text = stressor?.releaseInsteadExperience
        self.affirmationLabel.text = stressor?.releaseAffirmation
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
