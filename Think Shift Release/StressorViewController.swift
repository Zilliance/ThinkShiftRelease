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
        
        self.playAnimation(named: "Main Think") {
            
        }
        
        
        return ;
        
        guard let popupViewController = UIStoryboard(name: "Popup", bundle: nil).instantiateInitialViewController() as? PopupViewController
            else {
                assertionFailure()
                return
        }
        
        popupViewController.yesAction = {
            self.performSegue(withIdentifier: "ThinkSegue", sender: nil)
        }
        
        popupViewController.transitioningDelegate = self
        popupViewController.modalPresentationStyle = .custom
        
        self.present(popupViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func didTapShift(_ sender: Any) {
        guard self.didEnterStressor else {
            self.showAlert(title: "Please enter a name for your stressor", message: nil)
            return
        }
        self.performSegue(withIdentifier: "ShiftSegue", sender: nil)
    }
    
    @IBAction func didTapRelease(_ sender: Any) {
        guard self.didEnterStressor else {
            self.showAlert(title: "Please enter a name for your stressor", message: nil)
            return
        }
        self.performSegue(withIdentifier: "ReleaseSegue", sender: nil)
    }
    
    // MARK: - Alerts and Videos
    
    private func playAnimation(named name: String, completion: (()->Void)?) {
        let player = AVPlayer(url: Bundle.main.url(forResource: name, withExtension: "mp4")!)
        let animation = UIStoryboard(name: "Animation", bundle: nil).instantiateInitialViewController() as! AVPlayerViewController
        
        animation.player = player
        animation.transitioningDelegate = self
        animation.modalPresentationStyle = .custom
        
        self.playbackObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { [weak self] (notification) in
            animation.dismiss(animated: true, completion: nil)
            self?.playbackObserver = nil
            completion?()
        }
        
        self.present(animation, animated: true, completion: nil)
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

extension StressorViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        switch presented {
        case is PopupViewController:
            return PopupPresentationController(presentedViewController: presented, presenting: presenting)
        case is AVPlayerViewController:
            return AnimationPresentationController(presentedViewController: presented, presenting: presenting)
        default:
            return nil
        }
}
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch dismissed {
        case is PopupViewController:
            return PopupModalTransition(withType: .dismissing)
        case is AVPlayerViewController:
            return AnimationModalTransition(withType: .dismissing)
        default:
            return nil
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch presented {
        case is PopupViewController:
            return PopupModalTransition(withType: .presenting)
        case is AVPlayerViewController:
            return AnimationModalTransition(withType: .presenting)
        default:
            return nil
        }
    }
}

extension StressorViewController: StressorEditor {
    func save() {
        self.stressor.title = self.stressorTextView.text
    }
}

extension StressorViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            self.save()
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

