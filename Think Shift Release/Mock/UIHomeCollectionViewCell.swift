//
//  UIMockCollectionViewCell.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/11/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class UIHomeCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "MockCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.sharedInit()
    }
    
    private func sharedInit() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIMock.Color.lightGray
        self.backgroundView = backgroundView
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIMock.Color.darkGray
        self.selectedBackgroundView = selectedBackgroundView
    }
    
}
