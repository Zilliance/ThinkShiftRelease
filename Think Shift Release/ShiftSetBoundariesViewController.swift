//
//  ShiftSetBoundariesViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/12/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import AVFoundation
import AVKit

class ShiftSetBoundariesViewController: UIViewController {
    
    @IBOutlet weak var talkAboutTextView: KMPlaceholderTextView!
    @IBOutlet weak var notTalkAboutTextView: KMPlaceholderTextView!
    
    var stressor: Stressor!
    private var playbackObserver: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.save()
        
        if let playbackObserver = self.playbackObserver {
            NotificationCenter.default.removeObserver(playbackObserver)
        }
    }

    private func setupView() {
        self.view.backgroundColor = .clear
        
        if let talkWith = self.stressor.shiftBoundariesDoTalkWith {
            self.talkAboutTextView.text = talkWith
        }
        
        if let notTalkWith = self.stressor.shiftBoundariesNotTalkWith {
            self.notTalkAboutTextView.text = notTalkWith
        }
    }

    @IBAction func didTapTryInstantMoodShift(_ sender: Any) {
        
    }
    
    // Video
    
    @IBAction func playVideo(_ sender: Any?) {
        self.play(animation: .settingBoundaries, completion: nil)
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

extension ShiftSetBoundariesViewController: UIViewControllerTransitioningDelegate {
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

extension ShiftSetBoundariesViewController: SectionAnimationDelegate {
    func didDimiss(_ viewController: SectionAnimationViewController) {
        // noop
    }
}

// MARK: -

extension ShiftSetBoundariesViewController: StressorEditor {
    func save() {
        self.stressor.shiftBoundariesDoTalkWith = self.talkAboutTextView.text.characters.count > 0 ? self.talkAboutTextView.text : nil
        self.stressor.shiftBoundariesNotTalkWith = self.notTalkAboutTextView.text.characters.count > 0 ? self.notTalkAboutTextView.text : nil
    }
}

extension ShiftSetBoundariesViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
