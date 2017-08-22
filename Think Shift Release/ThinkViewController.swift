//
//  ThinkViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/12/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import AVFoundation
import AVKit

class ThinkViewController: UIViewController, ShowsSummary {
    
    @IBOutlet weak var subviewContainer: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var stressorLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var thoughtsDescription: UILabel!
    
    private var embeddedViewController: UIViewController?
    
    var stressor: Stressor!
    private var playbackObserver: NSObjectProtocol?
    var segment: Int?
    var summarySection: ItemSection! = .think
    var newStressor: ((Stressor) -> ())? = nil
    
    fileprivate var isSectionCompleted: Bool {
        return !self.textView.text.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        
        if let segment = self.segment {
            
            self.segmentedControl.selectedSegmentIndex = segment
            self.didMakeThinkSelection(self.segmentedControl)
            
        }
        else {
            self.setupSummaryButton()
        }
        
        self.newStressor = { [unowned self] stressor in
            self.stressor.copy(from: stressor)
            self.setupView()
        }
        
        self.thoughtsDescription.attributedText = self.thoughtsDescription.text?.learnMoreAttributedString(font: .muliLight(size: 12), color: .sectionDescriptionColor)
        
        // Embed Think Constructively
        
//        let viewController = UIStoryboard(name: "ThinkViewController", bundle: nil).instantiateViewController(withIdentifier: "ThinkConstructively") as! ThinkConstructivelyViewController
//        viewController.stressor = self.stressor
//        self.embed(viewController: viewController)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.save()
        if let playbackObserver = self.playbackObserver {
            NotificationCenter.default.removeObserver(playbackObserver)
        }
    }

    func summaryPreSave() {
        
        if let vc = self.embeddedViewController as? ThinkPositivelyViewController {
            vc.save()
        }
        if let vc = self.embeddedViewController as? ThinkConstructivelyViewController {
            vc.save()
        }
        
        self.save()
    }
    
    private func setupView() {
        
        self.bottomView.layer.contents = UIImage(named: "think-bg")?.cgImage
        
        if let thoughts = self.stressor.thinkThoughts {
            self.textView.text = thoughts
        }

        if let title = self.stressor.title {
            self.stressorLabel.text = "I am upset about \(title)"
        } else {
            self.stressorLabel.text = nil
        }
        
        // Segmented Control
        
        self.segmentedControl.tintColor = UIColor.navBar
        self.segmentedControl.setTitleTextAttributes([NSFontAttributeName: UIFont.muliBold(size: 12.0), NSForegroundColorAttributeName: UIColor.white] , for: .selected)
        self.segmentedControl.setTitleTextAttributes([NSFontAttributeName: UIFont.muliBold(size: 12.0), NSForegroundColorAttributeName: UIColor.navBar] , for: .normal)
        
    }


    // MARK: -
    
    @IBAction func didMakeThinkSelection(_ sender: UISegmentedControl) {
        guard let vc: UIViewController = {
            switch sender.selectedSegmentIndex {
            case 0:
                let viewController = UIStoryboard(name: "ThinkViewController", bundle: nil).instantiateViewController(withIdentifier: "ThinkConstructively") as! ThinkConstructivelyViewController
                viewController.stressor = self.stressor
                return viewController
            case 1:
                let viewController = UIStoryboard(name: "ThinkViewController", bundle: nil).instantiateViewController(withIdentifier: "ThinkPositively") as! ThinkPositivelyViewController
                viewController.stressor = self.stressor
                return viewController
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
                return .thinkConstructively
            case 1:
                return .thinkPositively
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
        self.addChildViewController(viewController)
        viewController.view.frame = self.subviewContainer.bounds
        self.subviewContainer.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        self.embeddedViewController = viewController
    }
    
    private func unembed(viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
        self.embeddedViewController = nil
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
    
    // MARK: - Learn More
    
    @IBAction func learnMoreAboutThoughts(_ sender: Any?) {
        LearnMoreViewController.present(from: self, text: NSLocalizedString("think learn more", comment: ""))
    }
}

// MARK: -

extension ThinkViewController: UIViewControllerTransitioningDelegate {
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

extension ThinkViewController: SectionAnimationDelegate {
    func didDimiss(_ viewController: SectionAnimationViewController) {
        // noop
    }
}

// MARK: -

extension ThinkViewController: StressorEditor {
    func save() {
        self.stressor.thinkThoughts = self.textView.text.characters.count > 0 ? self.textView.text : nil
    }
}

extension ThinkViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
