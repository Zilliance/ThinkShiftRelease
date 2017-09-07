//
//  QuotesViewController.swift
//  Think Shift Release
//
//  Created by ricardo hernandez  on 8/15/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import ZillianceShared

class QuotesViewController: AnalyzedViewController {
    
    private var tableViewController: QuotesTableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         self.view.layer.contents = UIImage(named: "shift-bg")?.cgImage
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableViewController.quotes = Array(Database.shared.user.quotes)
        self.tableViewController.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Action
    
    @IBAction func addItem(_ sender: Any?) {
        let vc = UIStoryboard(name: "QuotesViewController", bundle: nil).instantiateViewController(withIdentifier: "NewQuoteNav")
        
        self.present(vc, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? QuotesTableViewController {
            self.tableViewController = vc
        }
    }

}
