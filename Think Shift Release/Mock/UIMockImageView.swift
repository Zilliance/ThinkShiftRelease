//
//  UIMockImageView.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/11/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class UIMockImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.sharedInit()
    }
    
    private func sharedInit() {
        self.layer.borderColor = UIMock.Color.lightGray.cgColor
        self.layer.borderWidth = 1.0
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
//        guard self.image == nil else {
//            return
//        }
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY))
        
        path.move(to: CGPoint(x: 0, y: self.bounds.maxY))
        path.addLine(to: CGPoint(x: self.bounds.maxX, y: 0))
        
        path.lineWidth = 1.0
        
        UIMock.Color.lightGray.setStroke()
        path.stroke()
    }

}
