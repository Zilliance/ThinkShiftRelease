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
    func summaryPreSave()
    var newStressor: ((Stressor) -> ())? { get set }
    var summarySection: ItemSection! { get set }
}

extension ShowsSummary where Self: UIViewController {
    func setupSummaryButton() {
        self.navigationItem.rightBarButtonItem = UIClosureBarButtonItem(title: "Summary", style: .plain, handler: { [weak self] in
            self?.viewSummary(self?.navigationItem.rightBarButtonItem)
        })
    }
    
    func viewSummary(_ sender: Any?) {
        guard let vc = UIStoryboard(name: "SummaryViewController", bundle: nil).instantiateInitialViewController() as? SummaryViewController else {
            assertionFailure()
            return
        }
        //pass copy of stressor to summary
        self.summaryPreSave()
        vc.stressor = Stressor(value: self.stressor)
        vc.itemSection = self.summarySection
        vc.updatedStressor = { stressor in
            self.newStressor?(stressor)
        }
        
        let nc = UINavigationController(rootViewController: vc)
        self.present(nc, animated: true, completion: nil)
    }
}
