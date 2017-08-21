//
//  ShiftMoodShiftViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/13/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ShiftMoodShiftViewController: UIViewController {
    private var playbackObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let playbackObserver = self.playbackObserver {
            NotificationCenter.default.removeObserver(playbackObserver)
        }
    }
    
    // Video
    
    @IBAction func playVideo(_ sender: Any?) {
        self.play(animation: .instantMoodShifters, completion: nil)
    }
    
    private func play(animation: SectionAnimation, completion: (()->Void)?) {
        let player = AVPlayer(url: Bundle.main.url(forResource: animation.rawValue, withExtension: "mp4")!)
        let host = UIStoryboard(name: "Animation", bundle: nil).instantiateInitialViewController() as! SectionAnimationViewController
        
        let _ = host.view // force load for access to embedded playerViewController
        
        host.playerViewController.player = player
        host.transitioningDelegate = self
        host.modalPresentationStyle = .custom
        host.animation = animation
        host.delegate = self
        
        self.playbackObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { [weak self] (notification) in
            
            if let playbackObserver = self?.playbackObserver {
                NotificationCenter.default.removeObserver(playbackObserver)
                self?.playbackObserver = nil
            }
            
            if !host.isFullScreen {
                // Programmatically dismissing when player is full screen causes a crash
                host.dismiss(animated: true, completion: {
                    completion?()
                })
            }
        }
        
        self.present(host, animated: true, completion: nil)
        player.play()
    }
}

// MARK: -

extension ShiftMoodShiftViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        switch presented {
        case is SectionAnimationViewController:
            return AnimationPresentationController(presentedViewController: presented, presenting: presenting)
        default:
            return nil
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch dismissed {
        case is SectionAnimationViewController:
            return AnimationModalTransition(withType: .dismissing)
        default:
            return nil
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch presented {
        case is SectionAnimationViewController:
            return AnimationModalTransition(withType: .presenting)
        default:
            return nil
        }
    }
}

extension ShiftMoodShiftViewController: SectionAnimationDelegate {
    func didDimiss(_ viewController: SectionAnimationViewController) {
        // noop
    }
}
