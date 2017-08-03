//
//  ThinkViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/12/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class ThinkViewController: UIViewController {
    
    @IBOutlet weak var subviewContainer: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textView: KMPlaceholderTextView!
    private var embeddedViewController: UIViewController?
    
    var stressor: Stressor!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Summary", style: .plain, target: self, action: #selector(viewSummary(_:)))
        self.setupView()
        let viewController = UIStoryboard(name: "ThinkViewController", bundle: nil).instantiateViewController(withIdentifier: "ThinkConstructively") as! ThinkConstructivelyViewController
        viewController.stressor = self.stressor
        self.embed(viewController: viewController)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.save()
    }

    private func setupView() {
        
        if let thoughts = self.stressor.thinkThoughts {
            self.textView.text = thoughts
        }
        
        self.textView.layer.cornerRadius = UIMock.Appearance.cornerRadius
        self.textView.layer.borderWidth = 1
        self.textView.layer.borderColor = UIColor.silverColor.cgColor
        
        self.segmentedControl.tintColor = UIColor.purple
        self.segmentedControl.setTitleTextAttributes([NSFontAttributeName: UIFont.muliBold(size: 12.0), NSForegroundColorAttributeName: UIColor.white] , for: .selected)
        self.segmentedControl.setTitleTextAttributes([NSFontAttributeName: UIFont.muliBold(size: 12.0), NSForegroundColorAttributeName: UIColor.purple] , for: .normal)
        
        self.view.layer.contents = UIImage(named: "think-bg")?.cgImage
    }


    // MARK: -
    
    @IBAction func didMakeThinkSelection(_ sender: UISegmentedControl) {
        guard let vc: UIViewController = {
            switch sender.selectedSegmentIndex {
            case 0:
                let viewController = UIStoryboard(name: "ThinkViewController", bundle: nil).instantiateViewController(withIdentifier: "ThinkConstructively") as! ThinkConstructivelyViewController
                viewController.stressor = self.stressor
                return viewController
            case 1:
                let viewController = UIStoryboard(name: "ThinkViewController", bundle: nil).instantiateViewController(withIdentifier: "ThinkPositively") as! ThinkPositivelyViewController
                viewController.stressor = self.stressor
                return viewController
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
        self.embeddedViewController = viewController
    }
    
    private func unembed(viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
        self.embeddedViewController = nil
    }
    
    // MARK: -
    
    @IBAction func viewSummary(_ sender: Any?) {
        guard let vc = UIStoryboard(name: "SummaryTableViewController", bundle: nil).instantiateInitialViewController() else {
            assertionFailure()
            return
        }
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
}

extension ThinkViewController: StressorEditor {
    func save() {
        self.stressor.thinkThoughts = self.textView.text
    }
}

extension ThinkViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
