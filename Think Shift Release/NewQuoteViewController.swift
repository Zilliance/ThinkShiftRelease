//
//  NewQuoteViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 8/11/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class NewQuoteViewController: UIViewController {
    @IBOutlet weak var quoteTextView: KMPlaceholderTextView!
    @IBOutlet weak var authorTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.contents = UIImage(named: "shift-bg")?.cgImage
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        
        self.quoteTextView.layer.borderColor = UIColor.silverColor.cgColor
        self.quoteTextView.layer.borderWidth = UIMock.Appearance.borderWidth
        self.quoteTextView.layer.cornerRadius = UIMock.Appearance.cornerRadius
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Actions
    
    @IBAction func cancel(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func save(_ sender: Any?) {
        let quote = Quote()
        
        quote.title = self.quoteTextView.text
        quote.author = self.authorTextField.text
        
        Database.shared.user.addQuote(quote: quote)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewQuoteViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            self.authorTextField.becomeFirstResponder()
            return false
        }
        return true
    }
}

extension NewQuoteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        self.save(nil)
        return true
    }
}
