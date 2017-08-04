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
}


class ImagesCollectionViewController: UICollectionViewController {
    
    private var images: [URL: UIImage] = [:]
    fileprivate lazy var picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem(_:)))
        self.picker.delegate = self

        loadImages()
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
        
//        if let image = PhotoUtils.getPhoto(assetURL: url) {
//            
//            cell.imageView.image = image
//        }
        
        let image = self.images[url]
        cell.imageView.image = image
    
        return cell
    }
 
    // MARK: UICollectionViewDelegate


    // MARK: - User Action
    
    @IBAction func addItem(_ sender: Any?) {
        self.present(self.picker, animated: true, completion: nil)
    }
    
    
    fileprivate func loadImages() {
        
        let imageUrls = Array(Database.shared.user.imagesPaths).flatMap { (imagePath) -> URL? in
            return URL(string: imagePath.value)
        }
        
        self.fetchImages(for: imageUrls) {  [weak self] images in
            
            self?.images = images
            self?.collectionView?.reloadData()
            
        }
        
    }
    
    fileprivate func fetchImages(for urls:[URL], completion: @escaping ([URL: UIImage]) -> () ) {
        
        var tempImages: [URL: UIImage] = [:]
        
        let options = PHImageRequestOptions()
        options.resizeMode = .exact
        options.deliveryMode = .highQualityFormat
        
        let dispatchGroup = DispatchGroup()
        
        for url in urls {
            
            dispatchGroup.enter()
            
            let fetchResults = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
            
            if let asset = fetchResults.firstObject {
                PHImageManager.default().requestImage(for: asset, targetSize:  CGSize(width: 300.0, height: 300.0) , contentMode: .aspectFill, options: options, resultHandler: {(image, info) in
                    if let image = image {
                        tempImages[url] = image
                        dispatchGroup.leave()
                    }
                })
            }
            else {
                dispatchGroup.leave()
            }

        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { 

            completion(tempImages)

        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
        
        picker.dismiss(animated: true, completion: nil)
        
        self.loadImages()
    }
}
