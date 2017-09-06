//
//  MusicViewController.swift
//  Think Shift Release
//
//  Created by ricardo hernandez  on 8/15/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import ZilliancePod

class MusicViewController: AnalyzedViewController {
    
    private var tableViewController: MusicTableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.contents = UIImage(named: "shift-bg")?.cgImage
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MusicTableViewController {
            self.tableViewController = vc
        }
    }

    @IBAction func addTrackAction(_ sender: Any) {
        self.tableViewController.addItem(self)
    }

}
