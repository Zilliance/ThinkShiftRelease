//
//  HomeCollectionViewController.swift
//  Think Shift Release
//
//  Created by ricardo hernandez  on 7/24/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TSRCell"

class TSRCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var greyLineView: UIView!
    @IBOutlet weak var checkmarkView: UIImageView!
    
    var isDeleting = false
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    override var isSelected: Bool {
        didSet {
            guard isDeleting else {
                return
            }
            if isSelected {
                self.addBorder()
            }
            else {
                self.removeBorder()
            }
        }
    }
    
    private func addBorder() {
        
        self.contentView.layer.borderWidth = 2
        self.contentView.layer.borderColor = UIColor.aquaBlue.cgColor
        self.checkmarkView.alpha = 1
        
    }
    
    private func removeBorder() {
        
        self.contentView.layer.borderWidth = 0
        self.checkmarkView.alpha = 0
        
    }
    
    func setup(for stressor: Stressor) {
        
        self.contentView.layer.borderWidth = 0
        // self.titleLabel.text = compass.stressor
        
        if stressor.completed {
            self.completedLabel.backgroundColor = .navBar
            self.completedLabel.textColor = .contentBackground
            self.greyLineView.isHidden = true
            self.completedLabel.text = TSRCollectionViewCell.dateFormatter.string(from: stressor.dateCreated)
            
        }
            
        else {
            self.completedLabel.backgroundColor = .contentBackground
            self.completedLabel.textColor = .black
            self.greyLineView.isHidden = false
            self.completedLabel.text = "In progress"
            
        }
    }
    
}

class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private struct MockCollectionViewContent {
        let index: Int
    }
    
    private lazy var items: [MockCollectionViewContent] = {
        return (0..<9).map { MockCollectionViewContent(index: $0) }
    }()
    
    var editable = true
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = .paleGrey
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        // Configure the cell
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 40, height: 105)
    }

}
