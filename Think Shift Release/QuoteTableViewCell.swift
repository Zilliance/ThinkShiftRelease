//
//  QuoteTableViewCell.swift
//  Think Shift Release
//
//  Created by ricardo hernandez  on 8/8/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class QuoteTableViewCell: UITableViewCell {

    @IBOutlet weak var quoteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setQuote(label: String?, author: String?) {
        
        guard let label = label, let author = author else { return }
        
        let quote = label + "- \(author)"
        let attributedString = NSMutableAttributedString(string: quote)
        let authorRange = (quote as NSString).range(of: author)
        
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.muliBold(size: 12), range: authorRange)
        
        self.quoteLabel.attributedText = attributedString
    }

}
