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
    private var embeddedViewController: UIViewController?
    
    var stressor: Stressor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = self.stressor.title {
            self.stressorLabel.text = title
        }

        self.setupSummaryButton()
        
        self.embed(viewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShiftMood"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    
    @IBAction func didMakeShiftSelection(_ sender: UISegmentedControl) {
        guard let vc: UIViewController = {
            switch sender.selectedSegmentIndex {
            case 0:
                return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShiftMood")
            case 1:
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShiftBoundaries") as! ShiftSetBoundariesViewController
                vc.stressor = self.stressor
                return vc
            default:
                return nil
            }
            }() else {
                assertionFailure()
                return
        }
        
        if let embeddedViewController = self.embeddedViewController {
            self.unembed(viewController: embeddedViewController)
        }
        self.embed(viewController: vc)
    }
    
    private func embed(viewController: UIViewController) {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
