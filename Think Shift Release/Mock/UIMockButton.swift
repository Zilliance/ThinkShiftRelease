//
//  UIMockButton.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/11/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class UIMockButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.sharedInit()
    }
    
    private func sharedInit() {
        self.layer.cornerRadius = UIMock.Appearance.cornerRadius
        self.backgroundColor = UIMock.Color.lightGray
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
