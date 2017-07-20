//
//  UIMockTextField.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/11/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class UIMockTextField: UITextField {

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
        self.layer.borderWidth = UIMock.Appearance.borderWidth
        self.layer.borderColor = UIMock.Color.lightGray.cgColor
    }
    
    
}
