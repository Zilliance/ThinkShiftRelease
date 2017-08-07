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
    
    private let reuseIdentifier = "BreatheTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath)

        // Configure the cell...
        cell.extendSeparatorInsets()
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }


}
