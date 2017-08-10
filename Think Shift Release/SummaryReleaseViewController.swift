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
    var stressor: Stressor? = nil {
        didSet {
            self.intentionLabel.text = stressor?.releaseIntention
            self.affirmationLabel.text = stressor?.releaseAffirmation
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
