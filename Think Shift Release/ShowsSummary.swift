//
//  ShowsSummary.swift
//  Think Shift Release
//
//  Created by Philip Dow on 8/4/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

protocol ShowsSummary {
    var stressor: Stressor! { get }
    func setupSummaryButton()
    func viewSummary(_ sender: Any?)
}

extension ShowsSummary where Self: UIViewController {
    func setupSummaryButton() {
        self.navigationItem.rightBarButtonItem = UIClosureBarButtonItem(title: "Summary", style: .plain, handler: { [weak self] in
            self?.viewSummary(self?.navigationItem.rightBarButtonItem)
        })
    }
    
    func viewSummary(_ sender: Any?) {
        guard let vc = UIStoryboard(name: "SummaryTableViewController", bundle: nil).instantiateInitialViewController() as? SummaryTableViewController else {
            assertionFailure()
            return
        }
        vc.stressor = self.stressor
        let nc = UINavigationController(rootViewController: vc)
        self.present(nc, animated: true, completion: nil)
    }
}
