//
//  QuotesTableViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/14/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class QuotesTableViewController: UITableViewController {
    
    var quotes: [Quote] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register nibs:
        let nibName = UINib(nibName: "QuoteCell", bundle:nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "QuoteCell")
       

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 40
        self.tableView.backgroundColor = .clear
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
        self.quotes = Array(Database.shared.user.quotes)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let parentVC = self.parent {
            parentVC.navigationItem.rightBarButtonItem = self.editButtonItem
            parentVC.title = "Quotes"
        }
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.quotes.count
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath) as! QuoteTableViewCell
        let quote = self.quotes[indexPath.row]
        cell.setQuote(label: quote.title, author: quote.author)
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let quote = self.quotes[indexPath.row]
            Database.shared.user.remove(quote: quote)
            self.quotes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }

}
