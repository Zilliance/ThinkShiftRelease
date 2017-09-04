//
//  LabeledPopupViewController.swift
//  Think Shift Release
//
//  Created by ricardo hernandez  on 8/15/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class LabeledPopupViewController: UIViewController {

    static let defaultAttributedString: NSAttributedString = {
        let string = "You can’t think straight when you’re flooded with emotion. \n\n Sometimes you need to Shift or Release first, then Think when you’re feeling a little better."
        let attributedString = NSMutableAttributedString(string: string)
        
        let sometimesString = "Sometimes you need to Shift or Release first, then Think when you’re feeling a little better."
        let sometimesRange = (string as NSString).range(of: sometimesString)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.muliLight(size: 18), range: sometimesRange)
        
        let shiftRange = (string as NSString).range(of: "Shift")
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.muliBold(size: 18), range: shiftRange)
        
        let releaseRange = (string as NSString).range(of: "Release")
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.muliBold(size: 18), range: releaseRange)
        
        return attributedString
    }()
    
    static let sectionCompletedAttributedString: NSAttributedString = {
        let string = "Great job! Keep going! \n\n Click Summary or go back to the previous screen to continue using the skills of Think, Shift and Release."
        let attributedString = NSMutableAttributedString(string: string)
        
        let gobackString = "Click Summary or go back to the previous screen to continue using the skills of Think, Shift and Release."
        let gobackRange = (string as NSString).range(of: gobackString)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.muliLight(size: 18), range: gobackRange)
        
        let summaryRange = (string as NSString).range(of: "Summary")
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.muliBold(size: 18), range: summaryRange)
        
        let backRange = (string as NSString).range(of: "previous screen")
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.muliBold(size: 18), range: backRange)
        
        return attributedString
    }()
    
    // MARK: -
    
    @IBOutlet weak var label: UILabel!
    var attributedString = LabeledPopupViewController.defaultAttributedString
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.contents = UIImage(named: "popup2-bg")?.cgImage
        self.label.attributedText = self.attributedString

    }
    
    @IBAction func continueAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
