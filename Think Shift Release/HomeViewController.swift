//
//  HomeCollectionViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/14/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var topOverlay: UIView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var selectLabel: UILabel!
    
    fileprivate var isDeleting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Think, Shift, Release"
        self.editButton.title = "Edit"
    }

    
    private func toogleDeleteMode() {
        
        self.isDeleting = !self.isDeleting
       // self.collectionView.reloadData()
        self.editButton.title = self.isDeleting ? "Done" : "Edit"
        
        UIView.animate(withDuration: 0.3, animations: {
            self.topOverlay.alpha = self.isDeleting ? 0.6 : 0
            self.deleteButton.alpha = self.isDeleting ? 1 : 0
            self.selectLabel.alpha = self.isDeleting ? 1 : 0
        }) { (complete) in
            
        }
    }

    

    // MARK: - User Action
    
    @IBAction func menuAction(_ sender: UIBarButtonItem) {
        self.sideMenuController?.toggle()
    }
    
    @IBAction func edit(_ sender: Any?) {
        self.toogleDeleteMode()
    }

    @IBAction func deleteAction(_ sender: Any) {
    }
}
