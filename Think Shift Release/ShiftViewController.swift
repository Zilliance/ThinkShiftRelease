//
//  ShiftViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/12/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ShiftViewController: UIViewController, ShowsSummary {
    @IBOutlet weak var subviewContainer: UIView!
    @IBOutlet weak var stressorLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    private var embeddedViewController: UIViewController?
    
    var stressor: Stressor!
    private var playbackObserver: NSObjectProtocol?
    
    var segment: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bottomView.layer.contents = UIImage(named: "shift-bg")?.cgImage
        
        if let title = self.stressor.title {
            self.stressorLabel.text = "I am upset about \(title)"
        } else {
            self.stressorLabel.text = nil
        }
        
        // Segmented Control
        
        self.segmentedControl.tintColor = UIColor.navBar
        self.segmentedControl.setTitleTextAttributes([NSFontAttributeName: UIFont.muliBold(size: 12.0), NSForegroundColorAttributeName: UIColor.white] , for: .selected)
        self.segmentedControl.setTitleTextAttributes([NSFontAttributeName: UIFont.muliBold(size: 12.0), NSForegroundColorAttributeName: UIColor.navBar] , for: .normal)
        
        if let segment = self.segment {
            
            self.segmentedControl.selectedSegmentIndex = segment
            self.didMakeShiftSelection(self.segmentedControl)
            
        }
        else {
            self.setupSummaryButton()
        }
        
        
        // Embed Shift Mood
        
//        self.embed(viewController: UIStoryboard(name: "ShiftViewController", bundle: nil).instantiateViewController(withIdentifier: "ShiftMood"))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let playbackObserver = self.playbackObserver {
            NotificationCenter.default.removeObserver(playbackObserver)
        }
    }

    // MARK: -
    
    @IBAction func didMakeShiftSelection(_ sender: UISegmentedControl) {
        
        if let embeddedViewController = self.embeddedViewController {
            self.unembed(viewController: embeddedViewController)
        }
        
        guard let vc: UIViewController = {
            switch sender.selectedSegmentIndex {
            case 0:
                return UIStoryboard(name: "ShiftViewController", bundle: nil).instantiateViewController(withIdentifier: "ShiftMood")
            case 1:
                let vc = UIStoryboard(name: "ShiftViewController", bundle: nil).instantiateViewController(withIdentifier: "ShiftBoundaries") as! ShiftSetBoundariesViewController
                vc.stressor = self.stressor
                return vc
            default:
                return nil
            }
        }() else {
            assertionFailure()
            return
        }
        
        guard let animation: SectionAnimation = {
            switch sender.selectedSegmentIndex {
            case 0:
                return .instantMoodShifters
            case 1:
                return .settingBoundaries
            default:
                return nil
            }
        }() else {
            assertionFailure()
            return
        }
        
        // Embed
        
        if let embeddedViewController = self.embeddedViewController {
            self.unembed(viewController: embeddedViewController)
        }
        
        self.embed(viewController: vc)
        
        // Play animation
        
        if !UserDefaults.standard.hasPlayed(animation: animation) {
            UserDefaults.standard.setHasPlayed(animation: animation)
            self.play(animation: animation, completion: nil)
        }
    }
    
    private func embed(viewController: UIViewController) {
        self.embeddedViewController = viewController
        self.addChildViewController(viewController)
        viewController.view.frame = self.subviewContainer.bounds
        self.subviewContainer.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }
    
    private func unembed(viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }

    // MARK: - Videos
    
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

extension ShiftViewController: UIViewControllerTransitioningDelegate {
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

extension ShiftViewController: SectionAnimationDelegate {
    func didDimiss(_ viewController: SectionAnimationViewController) {
        // noop
    }
}

// MARK: -
