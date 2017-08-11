//
//  QuotesTableViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/14/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class QuotesTableViewController: UITableViewController {
    
    private var quotes: [Quote] {
        return Array(Database.shared.user.quotes)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register nibs:
        let nibName = UINib(nibName: "QuoteCell", bundle:nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "QuoteCell")
        self.view.layer.contents = UIImage(named: "shift-bg")?.cgImage

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 40
        
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem(_:)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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

    // MARK: - User Action
    
    @IBAction func addItem(_ sender: Any?) {
        let vc = UIStoryboard(name: "QuotesViewController", bundle: nil).instantiateViewController(withIdentifier: "NewQuoteNav")
        
        self.present(vc, animated: true, completion: nil)
    }
}
