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
        
        self.titleLabel.text = stressor.title
        
        self.completedLabel.layer.borderWidth = UIMock.Appearance.borderWidth
        self.completedLabel.layer.cornerRadius = UIMock.Appearance.cornerRadius
        
        if stressor.completed {
            self.completedLabel.backgroundColor = .navBar
            self.completedLabel.textColor = .white
            self.completedLabel.text = TSRCollectionViewCell.dateFormatter.string(from: stressor.dateCreated)
            self.completedLabel.layer.borderColor = UIColor.navBar.cgColor
            
        }
            
        else {
            self.completedLabel.backgroundColor = .contentBackground
            self.completedLabel.textColor = .darkBlue
            self.completedLabel.text = "In progress"
            self.completedLabel.layer.borderColor = UIColor.navBar.cgColor
            
        }
    }
    
}

class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var isDeleting = false
    
    fileprivate var stressors: [Stressor] {
        return Array(Database.shared.user.stressors)
    }
    
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = .paleGrey
        self.collectionView?.allowsMultipleSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView?.reloadData()
    }
    
    func delete() {
        
        guard self.stressors.count > 0 else {
            return
        }
        
        if let indexes = self.collectionView?.indexPathsForSelectedItems, indexes.count > 0 {
            
            let alertController = UIAlertController(title: "Are you sure you want to delete the selected stressors?", message: "Deleting them will permanently remove them.", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in
                alertController.dismiss(animated: true, completion: nil)
            })
            
            alertController.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
                alertController.dismiss(animated: true, completion: nil)
                
                self.collectionView?.performBatchUpdates({
                    
                    let stressors = indexes.map { [unowned self] index in
                        
                        return self.stressors[index.row]
                    }
                    
                    for stressor in stressors {
                        Database.shared.delete(stressor)
                        Analytics.shared.send(event: TSRAnalytics.TSRAnalyticEvents.stressorDeleted)
                    }
                    
                    self.collectionView?.deleteItems(at: indexes)
                }, completion: nil)
                
            })
            
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            self.showAlert(title: "Please select the stressors you would like to delete", message: nil)
        }
    }

    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.stressors.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TSRCollectionViewCell
        
        // Configure the cell
        let stressor = self.stressors[indexPath.row]
        cell.isDeleting = self.isDeleting
        cell.setup(for: stressor)
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !self.isDeleting else {
            return
        }
        
        let stressor = self.stressors[indexPath.row]
        guard let vc = UIStoryboard(name: "SummaryViewController", bundle: nil).instantiateInitialViewController() as? SummaryViewController else {
            assertionFailure()
            return
        }
        // pass stressor copy
        vc.stressor = Stressor(value: stressor)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 40, height: 90)
    }

}
