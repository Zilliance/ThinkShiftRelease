//
//  ShiftViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/12/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class ShiftViewController: UIViewController, ShowsSummary {
    @IBOutlet weak var subviewContainer: UIView!
    @IBOutlet weak var stressorLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    private var embeddedViewController: UIViewController?
    
    var stressor: Stressor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bottomView.layer.contents = UIImage(named: "shift-bg")?.cgImage
        
        if let title = self.stressor.title {
            self.stressorLabel.text = "I am stressed out about \(title)"
        } else {
            self.stressorLabel.text = nil
        }

        self.setupSummaryButton()
        
        // Segmented Control
        
        self.segmentedControl.tintColor = UIColor.navBar
        self.segmentedControl.setTitleTextAttributes([NSFontAttributeName: UIFont.muliBold(size: 12.0), NSForegroundColorAttributeName: UIColor.white] , for: .selected)
        self.segmentedControl.setTitleTextAttributes([NSFontAttributeName: UIFont.muliBold(size: 12.0), NSForegroundColorAttributeName: UIColor.navBar] , for: .normal)
        
        // Embed Shift Mood
        
//        self.embed(viewController: UIStoryboard(name: "ShiftViewController", bundle: nil).instantiateViewController(withIdentifier: "ShiftMood"))
    }

    // MARK: -
    
    @IBAction func didMakeShiftSelection(_ sender: UISegmentedControl) {
        
        if let embeddedViewController = self.embeddedViewController {
            self.unembed(viewController: embeddedViewController)
        }
        
        guard let vc: UIViewController = {
            switch sender.selectedSegmentIndex {
            case 0:
                return UIStoryboard(name: "ShiftViewController", bundle: nil).instantiateViewController(withIdentifier: "ShiftMood")
            case 1:
                let vc = UIStoryboard(name: "ShiftViewController", bundle: nil).instantiateViewController(withIdentifier: "ShiftBoundaries") as! ShiftSetBoundariesViewController
                vc.stressor = self.stressor
                return vc
            default:
                return nil
            }
            }() else {
                assertionFailure()
                return
        }
        
        self.embed(viewController: vc)
    }
    
    private func embed(viewController: UIViewController) {
        self.embeddedViewController = viewController
        self.addChildViewController(viewController)
        viewController.view.frame = self.subviewContainer.bounds
        self.subviewContainer.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }
    
    private func unembed(viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }

}
