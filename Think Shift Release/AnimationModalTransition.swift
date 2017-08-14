//
//  PopupModalTransition.swift
//  Think Shift Release
//
//  Created by ricardo hernandez  on 8/11/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//


import UIKit
import AVFoundation
import AVKit

final class DismissingBackgroundView: UIVisualEffectView {
    var viewController: UIViewController?
    
    dynamic func handleTap(recognizer: UITapGestureRecognizer) {
        self.viewController?.dismiss(animated: true, completion: nil)
    }
}

final class AnimationModalTransition: NSObject {
    fileprivate var transitionContext: UIViewControllerContextTransitioning?
    fileprivate var overlay = DismissingBackgroundView()
    
    enum TransitionType {
        case presenting
        case dismissing
    }
    
    fileprivate let transitionDuration = 0.3
    fileprivate var type: TransitionType
    
    init(withType type: TransitionType) {
        self.type = type
        super.init()
    }
}

extension AnimationModalTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        switch self.type {
        case .presenting:
            self.presentTransition(with: transitionContext)
        case .dismissing:
            self.dismissTransition(with: transitionContext)
        }
        
    }
    
    private func presentTransition(with transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to) else {
                return
        }
        
        // Add overlay to container
        
        self.overlay.frame = containerView.frame
        containerView.addSubview(overlay)
        
        // Tap to dismiss gesture recognizer
        
        let recognizer = UITapGestureRecognizer(target: self.overlay, action: #selector(DismissingBackgroundView.handleTap(recognizer:)))
        self.overlay.addGestureRecognizer(recognizer)
        self.overlay.viewController = fromViewController
        
        // Add target view controller to container
        
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        
        toViewController.view.frame = CGRect(x: (containerView.frame.width - finalFrame.width) / 2 , y: containerView.frame.size.height + finalFrame.size.height, width: finalFrame.size.width, height: finalFrame.size.height)
        containerView.addSubview(toViewController.view)
        
        // Transition
        
        UIView.animate(withDuration: self.transitionDuration, animations: {
            toViewController.view.frame = finalFrame
            self.overlay.effect = UIBlurEffect(style: .dark)
        }) { (completed) in
            transitionContext.completeTransition(completed)
        }
        
    }
    
    private func dismissTransition(with transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        
        guard let frame = toViewController?.view.frame else { return }
        
        // End playback : would rather have this somewhere else, delegate method or something
        
        if let animation = fromViewController as? SectionAnimationViewController {
            animation.playerViewController.player?.pause()
            animation.delegate?.didDimiss(animation)
        }
        
        // Capture overlay
        
        for view in containerView.subviews {
            if let overlay = view as? DismissingBackgroundView {
                self.overlay = overlay
            }
        }
        
        // Transition
        
        UIView.animate(withDuration: self.transitionDuration, animations: {
            fromViewController?.view.transform = CGAffineTransform(translationX: 0, y: frame.height)
            self.overlay.effect = nil
        }) { (completed) in
            self.overlay.removeFromSuperview()
            transitionContext.completeTransition(completed)
        }
        
    }
}

