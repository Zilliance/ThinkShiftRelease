//
//  ReleaseViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/12/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import AVFoundation
import AVKit

class ReleaseViewController: UIViewController, ShowsSummary {

    @IBOutlet weak var affirmationTextView: KMPlaceholderTextView!
    @IBOutlet weak var intentionTextView: KMPlaceholderTextView!
    @IBOutlet weak var experienceTextView: KMPlaceholderTextView!
    @IBOutlet weak var stressorLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var intentionDescription: UILabel!
    @IBOutlet weak var affirmationDescription: UILabel!
    @IBOutlet weak var breatheDescription: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    
    var stressor: Stressor!
    var newStressor: ((Stressor) -> ())? = nil
    var segment: Int?
    
    var summarySection: ItemSection! = .release
    private var playbackObserver: NSObjectProtocol?
    
    fileprivate var isSectionCompleted: Bool {
        return !self.affirmationTextView.text.isEmpty && !self.intentionTextView.text.isEmpty && !self.experienceTextView.text.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        self.newStressor = { [unowned self] stressor in
            self.stressor.copy(from: stressor)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.save()
    }
    
    func summaryPreSave() {
         self.save()
    }
    
    private func setupView() {
        
        self.bottomView.layer.contents = UIImage(named: "release-bg")?.cgImage
        
        if let affirmation = self.stressor.releaseAffirmation {
            self.affirmationTextView.text = affirmation
        }
        
        if let intention = self.stressor.releaseMyIntention {
            self.intentionTextView.text = intention
        }
        
        if let experience = self.stressor.releaseInsteadExperience {
            self.experienceTextView.text = experience
        }
        
        
        if let title = self.stressor.title {
            self.stressorLabel.text = "I am upset about \(title)"
        } else {
            self.stressorLabel.text = nil
        }
        
        if let _ = self.segment {
            
        } else {
            self.setupSummaryButton()
        }
        
        // Format learn more sentences
        
        let intentionAttrStr = self.intentionDescription.text?.learnMoreAttributedString(font: .muliLight(size: 12), color: .sectionDescriptionColor).mutableCopy() as! NSMutableAttributedString
        let intentionStr = intentionAttrStr.string as NSString
        
        let range = intentionStr.range(of: "emotion", options: .caseInsensitive, range: NSRange(location: 0, length: intentionStr.length))
        
        intentionAttrStr.setAttributes([NSFontAttributeName: UIFont.muliLightItalic(size: 12)], range: range)
        
        self.intentionDescription.attributedText = intentionAttrStr
        
        self.affirmationDescription.attributedText = self.affirmationDescription.text?.learnMoreAttributedString(font: .muliLight(size: 12), color: .sectionDescriptionColor)
        
        self.breatheDescription.attributedText = self.breatheDescription.text?.learnMoreAttributedString(font: .muliLight(size: 12), color: .sectionDescriptionColor)
    }
    
    // MARK: - Learn More
    
    @IBAction func learnMoreAboutIntention(_ sender: Any?) {
        LearnMoreViewController.present(from: self, text: NSLocalizedString("intention learn more", comment: ""))
    }
    
    @IBAction func learnMoreAboutAffirmation(_ sender: Any?) {
        LearnMoreViewController.present(from: self, text: NSLocalizedString("affirmation learn more", comment: ""))
    }
    
    @IBAction func learnMoreAboutBreathe(_ sender: Any?) {
        LearnMoreViewController.present(from: self, text: NSLocalizedString("breathe learn more", comment: ""))
    }
    
    // MARK: -
    
    func showCompleted() {
        
        guard !UserDefaults.standard.bool(forKey: "ReleaseCompletedShown") else {
            return
        }
        UserDefaults.standard.set(true, forKey: "ReleaseCompletedShown")
        
        let labeledPopupViewController = UIStoryboard(name: "LabeledPopup", bundle: nil).instantiateInitialViewController() as! LabeledPopupViewController
        
        labeledPopupViewController.transitioningDelegate = self
        labeledPopupViewController.modalPresentationStyle = .custom
        labeledPopupViewController.attributedString = LabeledPopupViewController.sectionCompletedAttributedString
        
        self.present(labeledPopupViewController, animated: true, completion: nil)
    }
    
    // MARK: - Videos
    
    @IBAction func playReleaseVideo(_ sender: Any?) {
        self.play(animation: .release, completion: nil)
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

extension ReleaseViewController: UIViewControllerTransitioningDelegate {
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

extension ReleaseViewController: SectionAnimationDelegate {
    func didDimiss(_ viewController: SectionAnimationViewController) {
        // noop
    }
}


// MARK: -

extension ReleaseViewController: StressorEditor {
    func save() {
        let wasCompleted = self.stressor.completed
        let releaseWasComlpeted = self.stressor.releaseCompleted
        
        self.stressor.releaseMyIntention = self.intentionTextView.text.characters.count > 0 ? self.intentionTextView.text : nil
        self.stressor.releaseInsteadExperience = self.experienceTextView.text.characters.count > 0 ? self.experienceTextView.text : nil
        self.stressor.releaseAffirmation = self.affirmationTextView.text.characters.count > 0 ? self.affirmationTextView.text : nil
        
        if (self.stressor.completed && !wasCompleted) {
            Analytics.sendEvent(event: TSRAnalytics.TSRAnalyticEvents.stressorCompleted)
        }
        
        if (self.stressor.releaseCompleted && !releaseWasComlpeted) {
            Analytics.sendEvent(event: TSRAnalytics.TSRAnalyticEvents.thinkStepCompleted)
        }
        
    }
}

extension ReleaseViewController: UITextViewDelegate {
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
