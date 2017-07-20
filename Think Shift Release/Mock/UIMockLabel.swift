//
//  UIMockLabel.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/11/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

private let subviewHeight = CGFloat(14)
private let subviewMargin = CGFloat(4)

class UIMockLabel: UILabel {
    private var views = [UIView]()
    
    var bold = false {
        didSet {
            self.updateSubviews()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            self.updateSubviews()
        }
    }
    
    override var text: String? {
        get {
            return nil
        }
        set {
            super.text = nil
        }
    }
    
    override var attributedText: NSAttributedString? {
        get {
            return nil
        }
        set {
            super.attributedText = nil
        }
    }
    
    // MARK: -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sharedInit()
        self.text = nil
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.sharedInit()
        self.text = nil
    }
    
    private func sharedInit() {
        self.updateSubviews()
    }
    
    // MARK: -
    
    private func updateSubviews() {
        self.views.removeAll()
        
        let lines  = Int( floor( self.bounds.height / (subviewHeight + subviewMargin) ) )
        for index in 0..<lines {
            let view = UIView()
            
            view.backgroundColor = self.bold ? UIMock.Color.darkGray : UIMock.Color.lightGray
            view.translatesAutoresizingMaskIntoConstraints = false
            
            self.views.append(view)
            self.addSubview(view)
            
            let top = CGFloat(index)*subviewHeight + CGFloat(index)*subviewMargin
            
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: top).isActive = true
            view.heightAnchor.constraint(equalToConstant: subviewHeight).isActive = true
            view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        }
    }

}
