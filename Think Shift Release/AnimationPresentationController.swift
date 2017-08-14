//
//  PopupPresentationController.swift
//  Think Shift Release
//
//  Created by ricardo hernandez  on 8/11/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class AnimationPresentationController: UIPresentationController {
    static let width: CGFloat = UIDevice.isSmallerThaniPhone6 ? 300 : 330
    static let height: CGFloat = UIDevice.isSmallerThaniPhone6 ? 250 : 275

    override var frameOfPresentedViewInContainerView: CGRect {
        
        guard let containerView = containerView else {return CGRect()}
        
        return CGRect(x:(containerView.frame.width - AnimationPresentationController.width) / 2,
                      y: (containerView.frame.height - AnimationPresentationController.height) / 2,
                      width: AnimationPresentationController.width,
                      height: AnimationPresentationController.height)
    }

}
