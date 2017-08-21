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

    @IBAction func scheduleReminderRelease(_ sender: Any?) {
        let stressor = "Stressor: \(self.stressor?.title ?? "")"
        let details1 = "My Intention: \(self.stressor?.releaseMyIntention ?? "")"
        let details2 = "My Affirmation: \(self.stressor?.releaseAffirmation ?? "")"
        let details3 = "Repeat my affirmation to the rhythm of my breath to evoke the feeling of my intention."
        let reminder = "\(stressor)\n\(details1)\n\(details2)\n\(details3)"
        
        self.showScheduler(text: reminder)
    }
    
    fileprivate func showScheduler(text: String) {
        guard let scheduler = UIStoryboard(name: "Schedule", bundle: nil).instantiateInitialViewController() as? ScheduleViewController else {
            assertionFailure()
            return
        }
        guard let parent = self.parent else {
            assertionFailure()
            return
        }
        
        scheduler.title = self.stressor?.title
        scheduler.text = text
        
        parent.navigationController?.pushViewController(scheduler, animated: true)
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
