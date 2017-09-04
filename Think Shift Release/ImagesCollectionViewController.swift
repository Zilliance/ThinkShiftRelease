//
//  ImagesCollectionViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/14/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import Photos

final class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var isDeleting = false
    
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
        
    }
    
    private func removeBorder() {
        
        self.contentView.layer.borderWidth = 0
        
    }
}


class ImagesCollectionViewController: UICollectionViewController {
    
    private var images: [URL: UIImage] = [:]
    fileprivate lazy var picker = UIImagePickerController()
    
    var deleting: Bool = false {
        didSet {

            for cell in self.collectionView?.visibleCells as! [ImageCell] {
                cell.isDeleting = true
            }
        
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.layer.contents = UIImage(named: "shift-bg")?.cgImage

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        self.picker.delegate = self

        self.collectionView?.allowsMultipleSelection = true

        reloadImages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
    
        // Configure the cell
        let imageUrls = Array(Database.shared.user.imagesPaths.sorted(byKeyPath: "dateAdded")).flatMap { (imagePath) -> URL? in
            return URL(string: imagePath.value)
        }
        let url = imageUrls[indexPath.row]
        
        
        let image = self.images[url]
        cell.imageView.image = image
        
        cell.isDeleting = self.deleting
    
        return cell
    }
 
    // MARK: UICollectionViewDelegate


    // MARK: - User Action
    
    func addItem() {
        self.present(self.picker, animated: true, completion: nil)
    }
    
    
    func reloadImages() {
        
        let imageUrls = Array(Database.shared.user.imagesPaths).flatMap { (imagePath) -> URL? in
            return URL(string: imagePath.value)
        }
        
        PhotoUtils.fetchImages(for: imageUrls) {  [weak self] images in
            
            self?.images = images
            self?.collectionView?.reloadData()
            
        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard !deleting else {
            return
        }
        
        let imageUrls = Array(Database.shared.user.imagesPaths.sorted(byKeyPath: "dateAdded")).flatMap { (imagePath) -> URL? in
            return URL(string: imagePath.value)
        }
        let url = imageUrls[indexPath.row]
        
        if let image = PhotoUtils.getPhoto(assetURL: url) {
            
            let imageViewController = UIStoryboard(name: "ImageViewController", bundle: nil).instantiateInitialViewController() as! ImageViewController
            
            imageViewController.image = image
            
            self.navigationController?.pushViewController(imageViewController, animated: true)
        }
    }
    
}

extension ImagesCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let url = info[UIImagePickerControllerReferenceURL] as? URL else {
            return
        }
        
        Database.shared.user.addImage(imagePath: url.absoluteString)
        
        Analytics.send(event: TSRAnalytics.TSRAnalyticEvents.shiftAddedNewImage)
        
        picker.dismiss(animated: true, completion: nil)
        
        self.reloadImages()
    }
}
