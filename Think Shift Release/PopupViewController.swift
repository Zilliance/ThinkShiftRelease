//
//  PopupViewController.swift
//  Think Shift Release
//
//  Created by ricardo hernandez  on 8/11/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
    
    var yesAction: (() -> ())? = nil
    var noAction: (() -> ())? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.contents = UIImage(named: "popup-bg")?.cgImage
    }

    //MARK - User Actions

    @IBAction func noAction(_ sender: Any) {
        self.dismiss(animated: true) { [unowned self] in
            self.noAction?()
        }
    }

    @IBAction func yesAction(_ sender: Any) {
        
        self.yesAction?()
        self.dismiss(animated: true, completion: nil)
    }
}
