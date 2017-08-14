//
//  SectionAnimationViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 8/14/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

import Foundation
import AVKit

enum SectionAnimation: String {
    case think = "Main Think"
    case thinkConstructivey = "Think Constructively"
    case thinkPositively = "Think Positively"
    
    case shift = "Main Shift"
    case instantMoodShifters = "Instant Mood Shifters"
    case settingBoundaries = "Setting Boundaries"
    
    case release = "Release"
    
    var defaultsKey: String {
        return "Did Play \(self.rawValue) Video"
    }
}

protocol SectionAnimationDelegate {
    func didDimiss(_ viewController: SectionAnimationViewController)
}

class SectionAnimationViewController: UIViewController {
    var playerViewController: AVPlayerViewController!
    var delegate: SectionAnimationDelegate?
    var animation: SectionAnimation?
    
    var isFullScreen: Bool {
        return self.playerViewController.videoBounds.width > AnimationPresentationController.width
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AVPlayerViewController {
            self.playerViewController = vc
        }
    }
}
