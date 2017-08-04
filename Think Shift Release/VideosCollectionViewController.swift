//
//  VideosCollectionViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/14/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices
import AVKit

class VideosCollectionViewController: UICollectionViewController {

    fileprivate lazy var videoPicker = UIImagePickerController()
    var urls: [URL] = []
    var images: [URL: UIImage] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem(_:)))
        self.videoPicker.delegate = self
        
        self.loadVideos()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addItem(_ sender: Any?) {
        self.videoPicker.mediaTypes = [kUTTypeMovie, kUTTypeAVIMovie, kUTTypeVideo, kUTTypeMPEG4] as [String]
        self.present(self.videoPicker, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoURL = self.urls[indexPath.row]
        
        let playerViewController = AVPlayerViewController()
        
        let player = AVPlayer(url: videoURL)
        
        playerViewController.player = player
        
        present(playerViewController, animated: true) {
            player.play()
        }
    }

}

extension VideosCollectionViewController {
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.urls.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        let videoURL = self.urls[indexPath.row]
        let image = images[videoURL]
        
        cell.imageView.image = image
        
        return cell
    }
    
}

extension VideosCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    func loadVideos(){
    
        self.urls = Array(Database.shared.user.videoPaths).flatMap { (videoPath) -> URL? in
            return URL(string: videoPath.value)
        }
        
        self.fetchImages(for: self.urls) {  [weak self] images in
            
            self?.images = images
            self?.collectionView?.reloadData()
            
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let url = info[UIImagePickerControllerReferenceURL] as? URL else {
            return
        }
        
        Database.shared.user.addVideo(videoPath: url.absoluteString)
        
        picker.dismiss(animated: true, completion: nil)
        
        self.loadVideos()

    }
    
    
}
