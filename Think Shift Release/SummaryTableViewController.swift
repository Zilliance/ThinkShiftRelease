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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 286
        
        self.title = "Summary"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close(_:)))
        
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
