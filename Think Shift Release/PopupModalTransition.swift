//
//  PopupModalTransition.swift
//  Think Shift Release
//
//  Created by ricardo hernandez  on 8/11/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation

import UIKit

final class PopupModalTransition: NSObject {
    
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

extension PopupModalTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
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
        
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        
        toViewController.view.frame = CGRect(x: (containerView.frame.width - finalFrame.width) / 2 , y: containerView.frame.size.height + finalFrame.size.height, width: finalFrame.size.width, height: finalFrame.size.height)
        containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: self.transitionDuration, animations: {
            toViewController.view.frame = finalFrame
            fromViewController.view.alpha = 0.5
        }) { (completed) in
            transitionContext.completeTransition(completed)
        }
        
    }
    
    private func dismissTransition(with transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        
        guard let frame = toViewController?.view.frame else { return }
        
        UIView.animate(withDuration: self.transitionDuration, animations: {
            toViewController?.view.alpha = 1.0
            fromViewController?.view.transform = CGAffineTransform(translationX: 0, y: frame.height)
        }) { (completed) in
            transitionContext.completeTransition(completed)
        }
        
    }
}

