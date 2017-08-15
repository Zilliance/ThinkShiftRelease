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
    
    var deleting: Bool = false {
        didSet {
            self.collectionView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.allowsMultipleSelection = true

        self.videoPicker.delegate = self
                
        self.reloadVideos()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addItem() {
        self.videoPicker.mediaTypes = [kUTTypeMovie, kUTTypeAVIMovie, kUTTypeVideo, kUTTypeMPEG4] as [String]
        self.present(self.videoPicker, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard !deleting else {
            return
        }
        
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
        
        cell.isDeleting = self.deleting
        
        return cell
    }
    
}

extension VideosCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func reloadVideos(){
    
        self.urls = Array(Database.shared.user.videoPaths).flatMap { (videoPath) -> URL? in
            return URL(string: videoPath.value)
        }
        
        PhotoUtils.fetchImages(for: self.urls) {  [weak self] images in
            
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
        
        self.reloadVideos()

    }
    
    
}

