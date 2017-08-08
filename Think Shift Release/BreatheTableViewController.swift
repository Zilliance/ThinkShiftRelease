//
//  BreatheTableViewController.swift
//  Think Shift Release
//
//  Created by ricardo hernandez  on 8/1/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class BreatheTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lenghtLabel: UILabel!
    
}

class BreatheTableViewController: UITableViewController {
    
    fileprivate var audioPlayer: MPMusicPlayerController?
    
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
        
    }
    
    private let reuseIdentifier = "BreatheTableViewCell"
    
    private let songs: [Song] = [.meditation, .instrumental]

    override func viewDidLoad() {
        super.viewDidLoad()
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
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }


}
