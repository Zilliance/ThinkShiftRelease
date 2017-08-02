//
//  VideosTableViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/14/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices
import AVKit

class VideosTableViewController: UITableViewController {

    fileprivate lazy var videoPicker = UIImagePickerController()
    var urls: [URL] = []
    var images: [URL: UIImage] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem(_:)))
        self.videoPicker.delegate = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80

        //register nibs:
        let nibName = UINib(nibName: "MediaCell", bundle:nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "MediaCell")
        
        self.loadVideos()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showVideos(_ sender: UIButton) {
        self.videoPicker.mediaTypes = [kUTTypeMovie, kUTTypeAVIMovie, kUTTypeVideo, kUTTypeMPEG4] as [String]
        self.present(self.videoPicker, animated: true, completion: nil)
    }
    
    @IBAction func addItem(_ sender: Any?) {
        self.videoPicker.mediaTypes = [kUTTypeMovie, kUTTypeAVIMovie, kUTTypeVideo, kUTTypeMPEG4] as [String]
        self.present(self.videoPicker, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let videoURL = self.urls[indexPath.row]
        
        let playerViewController = AVPlayerViewController()
        
        let player = AVPlayer(url: videoURL)
        
        playerViewController.player = player
        
        present(playerViewController, animated: true) { 
            player.play()
        }
        
    }

}

extension VideosTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.urls.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath) as! MediaCell
        
        let videoURL = self.urls[indexPath.row]
        let image = images[videoURL]
        
        cell.mediaView.image = image
        
        return cell
    }
    
}

extension VideosTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    fileprivate func fetchImages(for urls:[URL], completion: @escaping ([UIImage]) -> () ) {
        
        let fetchResults = PHAsset.fetchAssets(withALAssetURLs: urls, options: nil)
        
        var tempImages: [UIImage] = []
        
        fetchResults.enumerateObjects(using: { asset, index, _ in
            PHImageManager.default().requestImage(for: asset, targetSize:  CGSize(width: 50.0, height: 50.0) , contentMode: .aspectFit, options: nil, resultHandler: {[weak self] (image, info) in
                if let im = image {
                    
                    let url = urls[index]
                    self?.images[url] = image
                    
                    tempImages.append(im)
                    if index == fetchResults.count-1 {
                        completion(tempImages)
                    }
                }
            })
        })
        
    }
    
    func loadVideos(){
    
        self.urls = Array(Database.shared.user.videoPaths).flatMap { (videoPath) -> URL? in
            return URL(string: videoPath.value)
        }
        
        self.fetchImages(for: self.urls) {  [weak self] images in
            
            self?.tableView.reloadData()
            
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

