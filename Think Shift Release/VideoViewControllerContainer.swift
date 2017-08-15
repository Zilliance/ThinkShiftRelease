//
//  VideoViewControllerContainer.swift
//  Think Shift Release
//
//  Created by Ignacio Zunino on 15-08-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
final class VideoViewControllerContainer: UIViewController {
    
    @IBOutlet weak var deleteButtonHeight: NSLayoutConstraint!
    
    var videoViewController: VideosCollectionViewController!
    var deleting = false
    @IBOutlet var addButton: UIButton!
    
    var layoutCompleted = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteButtonHeight.constant = 0
        
        self.view.layer.contents = UIImage(named: "shift-bg")?.cgImage
        
        self.addButton.layer.cornerRadius = 3
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard !self.layoutCompleted else {
            return
        }

        self.layoutCompleted = true
        
        let gradient = CAGradientLayer()
        gradient.frame = self.addButton.bounds
        gradient.colors = [UIColor.color(forRed: 246, green: 148, blue: 120, alpha: 1).cgColor, UIColor.color(forRed: 234, green: 91, blue: 67, alpha: 1).cgColor]
        gradient.locations = [0, 1]
        self.addButton.layer.insertSublayer(gradient, at: 0)

        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = segue.destination as? VideosCollectionViewController {
            self.videoViewController = nextVC
        }
    }
    
    @IBAction func deleteTapped() {
        
        //todo: add alert
        
        defer {
            self.toggleEditionMode()
        }
        
        guard let selectedIndexes = self.videoViewController.collectionView?.indexPathsForSelectedItems else {
            return
        }
        
        let selectedItems: [Video] = selectedIndexes.map {
            return Database.shared.user.videoPaths[$0.row]
        }
        
        Database.shared.deleteObjects(selectedItems)
        
        self.videoViewController.reloadVideos()

    }
    
    private func toggleEditionMode() {
        self.deleting = !self.deleting
        self.deleteButtonHeight.constant = self.deleting ? 60 : 0
        self.videoViewController.deleting = self.deleting
        self.navigationItem.rightBarButtonItem?.title = self.deleting ? "Done" : "Edit"
        
        self.addButton.isHidden = self.deleting
    }
    
    @IBAction func editTapped(_ sender: Any) {
        self.toggleEditionMode()
    }
    
    @IBAction func addTapped() {
        self.videoViewController.addItem()
    }
    
}
