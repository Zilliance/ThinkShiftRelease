//
//  StressorViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/12/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

protocol StressorEditor {
    func save()
}

class StressorViewController: UIViewController {

    @IBOutlet weak var thinkButton: UIButton!
    @IBOutlet weak var shiftButton: UIButton!
    @IBOutlet weak var releaseButton: UIButton!
    
    @IBOutlet weak var stressorTextView: KMPlaceholderTextView!
    
    var stressor: Stressor = Stressor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.save()
        if (self.isMovingFromParentViewController) {
            guard let count = self.stressorTextView.text?.characters.count, count > 0 else { return }
            self.updateDatabase()
        }
    }
    
    private func setupView() {
        self.title = "New Stressor"
        
        for button in [self.thinkButton, self.shiftButton, self.releaseButton] as [UIButton] {
            button.imageView?.contentMode = .scaleAspectFit
        }
        
        self.view.layer.contents = UIImage(named: "stressor-intro-bg")?.cgImage
    }
    
    private func updateDatabase() {
        
        let update = Database.shared.user.stressors.filter { $0.id == self.stressor.id }.count > 0
        
        if (update) {
            Database.shared.add(realmObject: self.stressor, update: true)
        }
        else {
            Database.shared.save {
                Database.shared.user.stressors.append(self.stressor)
            }
        }

    }
    
    
    // MARK: -

    @IBAction func didTapThink(_ sender: Any) {
        
        guard let count = self.stressorTextView.text?.characters.count, count > 0 else {
            self.showAlert(title: "Please enter a name for your stressor", message: nil)
            return
        }
        
        
        let alert = UIAlertController(title: "Do you feel calm enough to think well?", message: "Additional message content. We could have a custom style alert here.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            // noop
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.performSegue(withIdentifier: "ThinkSegue", sender: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didTapShift(_ sender: Any) {
        guard let count = self.stressorTextView.text?.characters.count, count > 0 else {
            self.showAlert(title: "Please enter a name for your stressor", message: nil)
            return
        }
        self.performSegue(withIdentifier: "ShiftSegue", sender: nil)
    }
    
    @IBAction func didTapRelease(_ sender: Any) {
        guard let count = self.stressorTextView.text?.characters.count, count > 0 else {
            self.showAlert(title: "Please enter a name for your stressor", message: nil)
            return
        }
        self.performSegue(withIdentifier: "ReleaseSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.stressor = Stressor(value: self.stressor)
        if segue.identifier == "ThinkSegue" {
            let vc = segue.destination as! ThinkViewController
            vc.stressor = self.stressor
        }
        else if segue.identifier == "ReleaseSegue" {
            let vc = segue.destination as! ReleaseViewController
            vc.stressor = self.stressor
        }
        else if segue.identifier == "ShiftSegue" {
            let vc = segue.destination as! ShiftViewController
            vc.stressor = self.stressor
        }
        
    }
}

extension StressorViewController: StressorEditor {
    func save() {
        self.stressor.title = self.stressorTextView.text
    }
}

extension StressorViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            self.save()
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

