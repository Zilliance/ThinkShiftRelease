//
//  Popup2ViewController.swift
//  Think Shift Release
//
//  Created by ricardo hernandez  on 8/15/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class Popup2ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.contents = UIImage(named: "popup2-bg")?.cgImage
        
        let string = "You can’t think straight when you’re flooded with emotion. \n\n Sometimes you need to Shift or Release first, then Think when you’re feeling a little better."
        let attributedString = NSMutableAttributedString(string: string)
        let sometimesString = "Sometimes you need to Shift or Release first, then Think when you’re feeling a little better."
        let sometimesRange = (string as NSString).range(of: sometimesString)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.muliLight(size: 18), range: sometimesRange)
        let shiftRange = (string as NSString).range(of: "Shift")
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.muliBold(size: 18), range: shiftRange)
        let releaseRange = (string as NSString).range(of: "Release")
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.muliBold(size: 18), range: releaseRange)
        
        self.label.attributedText = attributedString

    }
    
    @IBAction func continueAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
