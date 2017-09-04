//
//  BreatheTableViewController.swift
//  Think Shift Release
//
//  Created by ricardo hernandez  on 8/1/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import AVFoundation

class BreatheTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lenghtLabel: UILabel!
    @IBOutlet weak var playLabel: UILabel!
    
    var isPlaying = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.playLabel.layer.cornerRadius = UIMock.Appearance.cornerRadius
    }
    
    func setViewForPause() {
        self.isPlaying = true
        self.playLabel.backgroundColor = UIColor.pauseButtonColor
        self.playLabel.textColor = UIColor.battleshipGrey
        self.playLabel.text = "PAUSE"
    }
    
    func setViewForPlay() {
        self.isPlaying = false
        self.playLabel.backgroundColor = UIColor.playButtonBlue
        self.playLabel.textColor = .white
        self.playLabel.text = "PLAY"
    }

}

class BreatheTableViewController: UITableViewController {
    
    enum Song {
        case meditation
        case instrumental
        
        var title: String {
            switch self {
            case .instrumental:
                return "Meditation Instrumental"
            case .meditation:
                return "Meditation"
            }
        }
        
        var url: URL {
            switch self {
            case .instrumental:
                return URL.init(fileURLWithPath: Bundle.main.path(
                    forResource: "release-meditation-instrumental",
                    ofType: "mp3")!)
            case .meditation:
                return URL.init(fileURLWithPath: Bundle.main.path(
                    forResource: "release-meditation",
                    ofType: "mp3")!)
            
            }
        }
        
        var length: String {
            switch self {
            case .meditation:
                return "03:42"
            case .instrumental:
                return "03:42"
            }
        }
        
    }
    
    private let reuseIdentifier = "BreatheTableViewCell"
    
    private let songs: [Song] = [.meditation, .instrumental]
    fileprivate var currentSong: Song?
    private var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAudio()
    }
    
    private func loadSong(song: Song) {
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: song.url)
            audioPlayer?.prepareToPlay()
            
        } catch let error as NSError {
            print("audioPlayer error \(error.localizedDescription)")
        }
        audioPlayer?.play()
        
        Analytics.sendEvent(event: TSRAnalytics.TSRDetailedAnalyticEvents.meditationAudioStarted(song.title))

        self.currentSong = song
        
    }
    
    private func playPauseSong(song: Song) {
        
        if let player = self.audioPlayer  {
            if song == self.currentSong {
                if player.isPlaying {
                    player.stop()
                    
                    Analytics.sendEvent(event: TSRAnalytics.TSRDetailedAnalyticEvents.meditationAudioStopped(song.title))
                    
                } else {
                    player.play()
                }
            } else {
                loadSong(song: song)
            }
        } else {
            
            loadSong(song: song)
        }
        
    }
    
    func stopAudio() {
        self.audioPlayer?.stop()
        self.audioPlayer?.currentTime = 0
    }
    
    private func setupAudio() {
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            try session.setActive(true)
        } catch let error as NSError {
            print("audio session error \(error.localizedDescription)")
        }
    }
    
    deinit {
        self.stopAudio()
    }



    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return songs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as! BreatheTableViewCell
        
        let song = songs[indexPath.row]
        // Configure the cell...
        cell.extendSeparatorInsets()
        cell.titleLabel.text = song.title
        cell.lenghtLabel.text = song.length
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // play music.
        let song = self.songs[indexPath.row]
        self.playPauseSong(song: song)
        //configure cell
        
        let cell = tableView.cellForRow(at: indexPath) as! BreatheTableViewCell
        if cell.isPlaying {
            cell.setViewForPlay()
        }
        else {
            cell.setViewForPause()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BreatheTableViewCell
        cell.setViewForPlay()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }


}

extension BreatheTableViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        guard let currentSongTitle = self.currentSong?.title else {
            assertionFailure()
            return
        }
        
        Analytics.sendEvent(event: TSRAnalytics.TSRDetailedAnalyticEvents.meditationAudioFinished(currentSongTitle))
        
    }
    
    
}
