//
//  UIMockTableViewCell.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/13/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class UIMockTableViewCell: UITableViewCell {
    static let reuseIdentifier = "MockCell"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    
    // MARK: -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
