//
//  StressorViewController.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/12/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class StressorViewController: UIViewController {

    @IBOutlet weak var thinkButton: UIButton!
    @IBOutlet weak var shiftButton: UIButton!
    @IBOutlet weak var releaseButton: UIButton!
    
    @IBOutlet weak var stressorTextField: UITextField!
    
    var stressor: Stressor = Stressor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        self.title = "New Stressor"
        
        for view in [self.thinkButton, self.shiftButton, self.releaseButton] as [UIView] {
            view.layer.cornerRadius = UIMock.Appearance.cornerRadius
        }
        
        self.view.layer.contents = UIImage(named: "stressor-intro-bg")?.cgImage
    }
    
    
    private func save () {
        
        self.stressor.title = self.stressorTextField.text
        
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
        
        guard let count = self.stressorTextField.text?.characters.count, count > 0 else {
            self.showAlert(title: "Please enter a name for your stressor", message: nil)
            return
        }
        
        self.save()
        
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
        guard let count = self.stressorTextField.text?.characters.count, count > 0 else {
            self.showAlert(title: "Please enter a name for your stressor", message: nil)
            return
        }
        self.save()
        self.performSegue(withIdentifier: "ShiftSegue", sender: nil)
    }
    
    @IBAction func didTapRelease(_ sender: Any) {
        guard let count = self.stressorTextField.text?.characters.count, count > 0 else {
            self.showAlert(title: "Please enter a name for your stressor", message: nil)
            return
        }
        self.save()
        self.performSegue(withIdentifier: "ReleaseSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ThinkSegue" {
            let vc = segue.destination as! ThinkViewController
            vc.stressor = self.stressor
        }
        
    }
}


extension StressorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
