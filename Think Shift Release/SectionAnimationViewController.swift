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
import AVFoundation

enum SectionAnimation: String {
    case think = "Main Think"
    case thinkConstructively = "Think Constructively"
    case thinkPositively = "Think Positively"
    
    case shift = "Main Shift"
    case instantMoodShifters = "Instant Mood Shifters"
    case settingBoundaries = "Setting Boundaries"
    
    case release = "Release"
    
    var defaultsKey: String {
        return "Has Played \(self.rawValue) Video"
    }
}

extension UserDefaults {
    func hasPlayed(animation: SectionAnimation) -> Bool {
        return self.bool(forKey: animation.defaultsKey)
    }
    
    func setHasPlayed(animation: SectionAnimation) {
        self.set(true, forKey: animation.defaultsKey)
    }
}

// MARK: -

protocol SectionAnimationDelegate {
    func didDimiss(_ viewController: SectionAnimationViewController)
}

class SectionAnimationViewController: UIViewController {
    enum Source {
        case card
        case icon
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscape]
    }
    
    var playerViewController: AVPlayerViewController!
    var delegate: SectionAnimationDelegate?
    var animation: SectionAnimation?
    var source: Source?
    
    var isFullScreen: Bool {
        return self.playerViewController.videoBounds.width > AnimationPresentationController.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let animation = self.animation else {
            assertionFailure()
            return
        }
        
        Analytics.sendEvent(event: TSRAnalytics.TSRDetailedAnalyticEvents.videoStarted(animation.rawValue))

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard let duration = self.playerViewController.player?.currentItem?.duration, let currentTime = self.playerViewController.player?.currentItem?.currentTime(), let animation = self.animation else {
            assertionFailure()
            return
        }
        
        if (CMTimeCompare(currentTime, duration) >= 0) {
            Analytics.sendEvent(event: TSRAnalytics.TSRDetailedAnalyticEvents.videoCompleted(animation.rawValue))
        } else {
            Analytics.sendEvent(event: TSRAnalytics.TSRDetailedAnalyticEvents.videoStopped(animation.rawValue))
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AVPlayerViewController {
            self.playerViewController = vc
        }
    }
}
