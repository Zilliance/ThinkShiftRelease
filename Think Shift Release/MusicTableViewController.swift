//
//  MusicTableViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/14/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import MediaPlayer

class MusicTableViewController: UITableViewController {
    
    var assets: [MPMediaItem] = []
    var images: [MPMediaItem: UIImage] = [:]
    fileprivate lazy var mediaPicker = MPMediaPickerController()
    fileprivate var audioPlayer: MPMusicPlayerController?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        
        //register nibs:
        let nibName = UINib(nibName: "MediaCell", bundle:nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "MediaCell")

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem(_:)))
        self.mediaPicker.delegate = self
        
        self.loadItems()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return assets.count
    }
 

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath) as! MediaCell

        // Configure the cell...
        let mediaItem = self.assets[indexPath.row]
        
        if let image = images[mediaItem] {

            cell.mediaView.image = image
            
        }
        
        var title = mediaItem.title ?? ""
        if let artist = mediaItem.artist {
            title = title + " - " +  artist
        }
        
        if (title.characters.count == 0) {
            title = "Unknown title"
        }
        
        cell.titleLabel.text = title
        
        cell.subtitleLabel.text = "Length " + mediaItem.playbackDuration.stringFormat
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // play music.
        let item = self.assets[indexPath.row]
        
        self.playPauseSong(song: item)
        
    }
    
    private func playPauseSong(song: MPMediaItem) {
        
        if let audioPlayer = self.audioPlayer, song == audioPlayer.nowPlayingItem {
            
            if (audioPlayer.currentPlaybackRate > 0) {
                audioPlayer.pause()
            } else {
                audioPlayer.play()
            }
            
        } else {
            
            self.audioPlayer = MPMusicPlayerController()
            
            MPMediaLibrary.requestAuthorization({ (status) in
                
                guard status == .authorized else {
                    //show error?
                    return
                }
                
                DispatchQueue.main.async {
                    self.audioPlayer?.setQueue(with: MPMediaItemCollection(items: [song]))
                    self.audioPlayer?.play()
                }
            })
            
        }
    }

    // MARK: - User Action
    
    @IBAction func addItem(_ sender: Any?) {
        let mediaPicker = MPMediaPickerController(mediaTypes: .music)
        mediaPicker.delegate = self
        mediaPicker.prompt = "Please Pick a Song"

        self.present(mediaPicker, animated: true, completion: nil)
    }
    
    fileprivate func loadItems() {
        
        self.assets = Array(Database.shared.user.audioPaths).flatMap { (audio) -> MPMediaItem? in
            
            guard let audioId = audio.value else {
                assertionFailure()
                return nil
            }
            
            let query = MPMediaQuery.songs()
            let urlQuery = MPMediaPropertyPredicate(value:audioId,forProperty: MPMediaItemPropertyPersistentID,comparisonType: .equalTo)
            query.addFilterPredicate(urlQuery)
            
            return query.items?.first
        }
        
        self.assets.forEach {
            if let image = $0.artwork?.image(at: CGSize(width: 50.0, height: 50.0)) {
                self.images[$0] = image
            }
        }
        
        self.tableView.reloadData()
        
    }
    
    deinit {
        self.audioPlayer?.stop()
    }
}

extension MusicTableViewController: MPMediaPickerControllerDelegate {
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        if let item = mediaItemCollection.items.first {
            
            //can retrieve media item with id later
            Database.shared.user.addAudio(audioID: item.persistentID)
            
            self.assets.append(item)
            
            if let image = item.artwork?.image(at: CGSize(width: 50.0, height: 50.0)) {
                self.images[item] = image
                self.tableView.reloadData()
            }
            
        }
        
        mediaPicker.dismiss(animated: true, completion: nil)
        
    }
    
}

