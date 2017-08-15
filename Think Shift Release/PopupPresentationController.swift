//
//  PopupPresentationController.swift
//  Think Shift Release
//
//  Created by ricardo hernandez  on 8/11/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class PopupPresentationController: UIPresentationController {
    
    private let width: CGFloat = UIDevice.isSmallerThaniPhone6 ? 300 : 335
    private let height: CGFloat  = 350
    
    override var frameOfPresentedViewInContainerView: CGRect {
        
        guard let containerView = containerView else {return CGRect()}
        
        return CGRect(x:(containerView.frame.width - self.width) / 2, y: (containerView.frame.height - self.height) / 2, width: self.width, height: self.height)
    }
    

}
