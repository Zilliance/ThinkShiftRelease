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
    
    func setViewForPause() {
        self.isPlaying = true
        self.playButton.backgroundColor = UIColor.pauseButtonColor
        self.playButton.setTitleColor(UIColor.battleshipGrey, for: .normal)
        self.playButton.setTitle("PAUSE", for: .normal)
    }
    
    func setViewForPlay() {
        self.isPlaying = false
        self.playButton.backgroundColor = UIColor.musicOrange
        self.playButton.setTitleColor(UIColor.white, for: .normal)
        self.playButton.setTitle("PLAY", for: .normal)
    }
    
}
