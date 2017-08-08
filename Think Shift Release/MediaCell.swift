//
//  MediaCell.swift
//  Think Shift Release
//
//  Created by Ignacio Zunino on 28-07-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import UIKit

final class MediaCell: UITableViewCell {
    
    @IBOutlet var mediaView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var playButton: UIButton!
    
    var isPlaying = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        self.playButton.layer.cornerRadius = UIMock.Appearance.cornerRadius
        
    }
    
    func setViewForPlay() {
        self.isPlaying = !self.isPlaying
        self.playButton.backgroundColor = self.isPlaying ? UIColor.pauseButtonColor : UIColor.musicOrange
        let color = self.isPlaying ? UIColor.battleshipGrey : UIColor.white
        self.playButton.setTitleColor(color, for: .normal)
        let title = self.isPlaying ? "PAUSE" : "PLAY"
        self.playButton.setTitle(title, for: .normal)
    }
    
}
