//
//  CardView.swift
//  Think Shift Release
//
//  Created by ricardo hernandez  on 8/4/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }

    override init (frame : CGRect) {
        super.init(frame : frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupView() {
        self.layer.borderColor = UIColor.silverColor.cgColor
        self.layer.borderWidth = UIMock.Appearance.borderWidth
        self.layer.cornerRadius = UIMock.Appearance.cornerRadius
        
        for view in self.subviews {
            if let textView = view as? UITextView {
                textView.layer.borderColor = UIColor.silverColor.cgColor
                textView.layer.borderWidth = UIMock.Appearance.borderWidth
                textView.layer.cornerRadius = UIMock.Appearance.cornerRadius
            }
        }
    }
}
