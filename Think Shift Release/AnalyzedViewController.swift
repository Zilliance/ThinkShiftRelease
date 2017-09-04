//
//  AnalyzedViewController.swift
//  Think Shift Release
//
//  Created by Ignacio Zunino on 04-09-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

extension NSObject {
    var theClassName: String {
        return NSStringFromClass(type(of: self))
    }
}

class AnalyzedViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewName = self.theClassName
        Analytics.sendEvent(event: ZillianceAnalytics.ZillianceDetailedAnalytics.viewControllerShown(viewName))

    }
    
}
