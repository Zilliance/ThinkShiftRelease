//
//  SummaryTableViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/14/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class SummaryTableViewController: UITableViewController {
    
    // Think
    
    @IBOutlet weak var needLabel: UILabel!
    @IBOutlet weak var actionStepLabel: UILabel!
    @IBOutlet weak var betterFeelingLabel: UILabel!
    
    // Shift
    
    @IBOutlet weak var instantMoodLabel: UILabel!
    @IBOutlet weak var boundariesLabel: UILabel!
    
    // Release
    
    @IBOutlet weak var intentionLabel: UILabel!
    @IBOutlet weak var affirmationLabel: UILabel!
    @IBOutlet weak var reminderButton: UIButton!
    
    var stressor: Stressor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    
    private func setupView() {
        
        if let need = self.stressor.thinkThoughts {
            self.needLabel.text = need
        }
        
        if let action = self.stressor.thinkActionStep {
            self.actionStepLabel.text = action
        }
        
        if let betterFeeling = self.stressor.thinkBetterFeeling {
            self.betterFeelingLabel.text = betterFeeling
        }
        
        if let boundaries = self.stressor.shiftBoundariesDoTalkWith {
            self.boundariesLabel.text = boundaries
        }
        
        if let intention = self.stressor.releaseIntention {
            self.intentionLabel.text = intention
        }
        
        if let affirmation = self.stressor.releaseAffirmation {
            self.affirmationLabel.text = affirmation
        }
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 286
        
        self.title = "Summary"
        
        if let _ = self.presentingViewController {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close(_:)))
        }
        
        // TODO: change back button title to back
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @IBAction func close(_ sender: Any?) {
        if let _ = self.presentingViewController {
            self.dismiss(animated: true, completion: nil)
        } else if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }

    @IBAction func reminderAction(_ sender: Any) {
    }
}
