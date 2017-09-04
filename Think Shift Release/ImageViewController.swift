//
//  ImageViewController.swift
//  Think Shift Release
//
//  Created by Ignacio Zunino on 04-08-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import UIKit

final class ImageViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var image: UIImage!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.imageView.image = self.image
        
        Analytics.sendEvent(event: TSRAnalytics.TSRAnalyticEvents.shiftSawImage)
        
    }
    
}
