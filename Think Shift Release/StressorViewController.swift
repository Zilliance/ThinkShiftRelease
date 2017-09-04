//
//  StressorViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/12/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import AVFoundation
import AVKit

protocol StressorEditor {
    func save()
}

class StressorViewController: UIViewController {

    @IBOutlet weak var thinkButton: UIButton!
    @IBOutlet weak var shiftButton: UIButton!
    @IBOutlet weak var releaseButton: UIButton!
    
    @IBOutlet weak var stressorTextView: KMPlaceholderTextView!
    
    var stressor: Stressor = Stressor()
    
    private var playbackObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        Analytics.sendEvent(event: TSRAnalytics.TSRAnalyticEvents.newStressor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let value =  UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.save()
        
        if (self.isMovingFromParentViewController) {
            guard let count = self.stressorTextView.text?.characters.count, count > 0 else { return }
            self.updateDatabase()
        }
        
        if let playbackObserver = self.playbackObserver {
            NotificationCenter.default.removeObserver(playbackObserver)
        }
    }
    
    private func setupView() {
        self.title = "New Stressor"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        for button in [self.thinkButton, self.shiftButton, self.releaseButton] as [UIButton] {
            button.imageView?.contentMode = .scaleAspectFit
        }
        
        self.view.layer.contents = UIImage(named: "stressor-intro-bg")?.cgImage
    }
    
    private func updateDatabase() {
        
        let update = Database.shared.user.stressors.filter { $0.id == self.stressor.id }.count > 0
        
        if (update) {
            Database.shared.add(realmObject: self.stressor, update: true)
        }
        else {
            Database.shared.save {
                Database.shared.user.stressors.append(self.stressor)
            }
        }
    }
    
    private var didEnterStressor: Bool {
        if let count = self.stressorTextView.text?.characters.count, count > 0 {
            return true
        } else {
            return false
        }
    }
    
    // MARK: -

    @IBAction func didTapThink(_ sender: Any) {
        guard self.didEnterStressor else {
            self.showAlert(title: "Please enter a name for your stressor", message: nil)
            return
        }
        
        if UserDefaults.standard.hasPlayed(animation: .think) {
            self.showThinkCards()
        } else {
            UserDefaults.standard.setHasPlayed(animation: .think)
            self.play(animation: .think, fromCard: true, completion: nil)
        }
    }
    
    @IBAction func didTapShift(_ sender: Any) {
        guard self.didEnterStressor else {
            self.showAlert(title: "Please enter a name for your stressor", message: nil)
            return
        }
        
        if UserDefaults.standard.hasPlayed(animation: .shift) {
            self.performSegue(withIdentifier: "ShiftSegue", sender: nil)
        } else {
            UserDefaults.standard.setHasPlayed(animation: .shift)
            self.play(animation: .shift, fromCard: true, completion: nil)
        }
    }
    
    @IBAction func didTapRelease(_ sender: Any) {
        guard self.didEnterStressor else {
            self.showAlert(title: "Please enter a name for your stressor", message: nil)
            return
        }
        
        if UserDefaults.standard.hasPlayed(animation: .release) {
           self.performSegue(withIdentifier: "ReleaseSegue", sender: nil)
        } else {
            UserDefaults.standard.setHasPlayed(animation: .release)
            self.play(animation: .release, fromCard: true, completion: nil)
        }
    }
    
    // MARK: - Tap to Play Video
    
    @IBAction func playThinkVideo() {
        self.play(animation: .think, fromCard: false, completion: nil)
        UserDefaults.standard.setHasPlayed(animation: .think)
    }
    
    @IBAction func playShiftVideo() {
        self.play(animation: .shift, fromCard: false, completion: nil)
        UserDefaults.standard.setHasPlayed(animation: .shift)
    }
    
    @IBAction func playReleaseVideo() {
        self.play(animation: .release, fromCard: false, completion: nil)
        UserDefaults.standard.setHasPlayed(animation: .release)
    }
    
    // MARK: - Alerts and Videos
    
    fileprivate func showThinkCards() {
        guard let popupViewController = UIStoryboard(name: "Popup", bundle: nil).instantiateInitialViewController() as? PopupViewController
            else {
                assertionFailure()
                return
        }
        
        popupViewController.yesAction = {
            self.performSegue(withIdentifier: "ThinkSegue", sender: nil)
        }
        
        popupViewController.noAction = {
            guard let labeledPopupViewController = UIStoryboard(name: "LabeledPopup", bundle: nil).instantiateInitialViewController() as? LabeledPopupViewController
                else {
                    assertionFailure()
                    return
            }
            labeledPopupViewController.transitioningDelegate = self
            labeledPopupViewController.modalPresentationStyle = .custom
            self.present(labeledPopupViewController, animated: true, completion: nil)
        }
        
        // Show second card on no action
        
        popupViewController.transitioningDelegate = self
        popupViewController.modalPresentationStyle = .custom
        
        self.present(popupViewController, animated: true, completion: nil)
    }
    
    private func play(animation: SectionAnimation, fromCard: Bool, completion: (()->Void)?) {
        let player = AVPlayer(url: Bundle.main.url(forResource: animation.rawValue, withExtension: "mp4")!)
        let host = UIStoryboard(name: "Animation", bundle: nil).instantiateInitialViewController() as! SectionAnimationViewController
        
        let _ = host.view // force load for access to embedded playerViewController
        
        host.playerViewController.player = player
        host.transitioningDelegate = self
        host.modalPresentationStyle = .custom
        host.source = fromCard ? .card : .icon
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.stressor = Stressor(value: self.stressor)
        if segue.identifier == "ThinkSegue" {
            let vc = segue.destination as! ThinkViewController
            vc.stressor = self.stressor
        }
        else if segue.identifier == "ReleaseSegue" {
            let vc = segue.destination as! ReleaseViewController
            vc.stressor = self.stressor
        }
        else if segue.identifier == "ShiftSegue" {
            let vc = segue.destination as! ShiftViewController
            vc.stressor = self.stressor
        }
        
    }
}

// MARK: -

extension StressorViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        switch presented {
        
        case is PopupViewController, is LabeledPopupViewController:
            return PopupPresentationController(presentedViewController: presented, presenting: presenting)
        
        case is SectionAnimationViewController:
            let presentationController = AnimationPresentationController(presentedViewController: presented, presenting: presenting)
            presentationController.delegate = self
            return presentationController
        
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

extension StressorViewController: UIAdaptivePresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        if traitCollection.verticalSizeClass == .compact  {
            return .overFullScreen
        } else {
            return .custom
        }
    }

}

extension StressorViewController: SectionAnimationDelegate {
    func didDimiss(_ viewController: SectionAnimationViewController) {
        // Only take the next action if the user tapped from the card and not the video icon
        guard viewController.source == .card else {
            return
        }
        
        switch viewController.animation {
        case .think?:
            self.showThinkCards()
        case .shift?:
            self.performSegue(withIdentifier: "ShiftSegue", sender: nil)
        case .release?:
            self.performSegue(withIdentifier: "ReleaseSegue", sender: nil)
        default:
            assertionFailure()
        }
    }
}

// MARK: -

extension StressorViewController: StressorEditor {
    func save() {
        let wasCompleted = self.stressor.completed

        self.stressor.title = self.stressorTextView.text
        
        if (self.stressor.completed && !wasCompleted) {
            Analytics.sendEvent(event: TSRAnalytics.TSRAnalyticEvents.stressorCompleted)
        }

    }
}

extension StressorViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}

