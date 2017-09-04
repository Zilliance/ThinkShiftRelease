//
//  ThinkConstructivelyViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/12/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import AVFoundation
import AVKit

class ThinkConstructivelyViewController: UIViewController {

    @IBOutlet weak var wisdomTextView: KMPlaceholderTextView!
    @IBOutlet weak var actionStepTextView: KMPlaceholderTextView!
    @IBOutlet weak var innerWisdomDescription: UILabel!
    
    var stressor: Stressor!
    private var playbackObserver: NSObjectProtocol?
    
    fileprivate var isSectionCompleted: Bool {
        return !self.wisdomTextView.text.isEmpty && !self.actionStepTextView.text.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.save()
        
        if let playbackObserver = self.playbackObserver {
            NotificationCenter.default.removeObserver(playbackObserver)
        }
    }
    
    private func setupViews() {
        
        if let wisdom = self.stressor.thinkInnerWisdom {
            self.wisdomTextView.text = wisdom
        }
        
        if let actionStep = self.stressor.thinkActionStep {
            self.actionStepTextView.text = actionStep
        }
        
        self.view.backgroundColor = .clear
        
        self.innerWisdomDescription.attributedText = self.innerWisdomDescription.text?.learnMoreAttributedString(font: .muliLight(size: 12), color: .sectionDescriptionColor)
    }
    
    // MARK: - Learn More
    
    @IBAction func learnMoreAboutInnerWisdom(_ sender: Any?) {
        LearnMoreViewController.present(from: self, text: NSLocalizedString("inner wisdom learn more", comment: ""))
    }
    
    // Video
    
    @IBAction func playVideo(_ sender: Any?) {
        self.play(animation: .thinkConstructively, completion: nil)
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
    
    // MARK: -
    
    func showCompleted() {
        guard !UserDefaults.standard.bool(forKey: "ThinkConstructivelyCompletedShown") else {
            return
        }
        UserDefaults.standard.set(true, forKey: "ThinkConstructivelyCompletedShown")
        
        let labeledPopupViewController = UIStoryboard(name: "LabeledPopup", bundle: nil).instantiateInitialViewController() as! LabeledPopupViewController
        
        labeledPopupViewController.transitioningDelegate = self
        labeledPopupViewController.modalPresentationStyle = .custom
        labeledPopupViewController.attributedString = LabeledPopupViewController.sectionCompletedAttributedString
        
        self.present(labeledPopupViewController, animated: true, completion: nil)
    }
    
}

// MARK: -

extension ThinkConstructivelyViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        switch presented {
        
        case is PopupViewController, is LabeledPopupViewController:
            return PopupPresentationController(presentedViewController: presented, presenting: presenting)

        case is SectionAnimationViewController:
            return AnimationPresentationController(presentedViewController: presented, presenting: presenting)
        
        default:
            return nil
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch dismissed {
        
        case is PopupViewController, is LabeledPopupViewController:
            return PopupModalTransition(withType: .dismissing)
            
        case is SectionAnimationViewController:
            return AnimationModalTransition(withType: .dismissing)
        
        default:
            return nil
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch presented {
        
        case is PopupViewController, is LabeledPopupViewController:
            return PopupModalTransition(withType: .presenting)
            
        case is SectionAnimationViewController:
            return AnimationModalTransition(withType: .presenting)
        
        default:
            return nil
        }
    }
}

extension ThinkConstructivelyViewController: SectionAnimationDelegate {
    func didDimiss(_ viewController: SectionAnimationViewController) {
        // noop
    }
}

// MARK: -

extension ThinkConstructivelyViewController: StressorEditor {
    func save() {
        let wasCompleted = self.stressor.completed
        let thinkWasCompleted = self.stressor.thinkCompleted
        
        self.stressor.thinkInnerWisdom = self.wisdomTextView.text.characters.count > 0 ? self.wisdomTextView.text : nil
        self.stressor.thinkActionStep = self.actionStepTextView.text.characters.count > 0 ? self.actionStepTextView.text : nil
        
        if (self.stressor.completed && !wasCompleted) {
            Analytics.sendEvent(event: TSRAnalytics.TSRAnalyticEvents.stressorCompleted)
        }
        
        if (self.stressor.thinkCompleted && !thinkWasCompleted) {
            Analytics.sendEvent(event: TSRAnalytics.TSRAnalyticEvents.thinkStepCompleted)
        }

    }
}

extension ThinkConstructivelyViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            if self.isSectionCompleted {
                self.showCompleted()
            }
            return false
        }
        return true
    }
    
}
