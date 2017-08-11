//
//  TextViewContainerViewController.swift
//  Zilliance
//
//  Created by ricardo hernandez  on 4/27/17.
//  Copyright © 2017 Pillars4Life. All rights reserved.
//

import UIKit

class ZillianceTextViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var textView: UITextView!
    
    struct EditableText {
        var text: String = ""
        var type: EditTextType = .value
        var isMultipleSelection = false
        var selectedIndexes: [Int]? = []
    }
    
    enum EditTextType {
        case value
        case activity
        case text
    }
    
    struct Validation: OptionSet {
        
        let rawValue: Int
        
        static let none = Validation(rawValue: 1 << 0)
        static let value1 = Validation(rawValue: 1 << 1)
        static let value2 = Validation(rawValue: 1 << 2)
        static let placeholder1 = Validation(rawValue: 1 << 3)
        static let placeholder2 = Validation(rawValue: 1 << 4)
        
        var error: ValidationError? {
            
            if !self.intersection([.value1, .value2]).isEmpty {
                return .value
            }
            else if !self.intersection([.placeholder1, .placeholder2]).isEmpty {
                return .placeholder
            }
            else {
                return nil
            }
        }
        
        enum ValidationError {
            case value
            case placeholder
        }
        
        mutating func removeValues() {
            if self.contains(.value2) {
                self.remove(.value2)
            }
            else {
                self.remove(.value1)
            }
        }
        
        mutating func removePlaceholders() {
            if self.contains(.placeholder2) {
                self.remove(.placeholder2)
            }
            else {
                self.remove(.placeholder1)
            }
        }
    }
    
    var validation: Validation = .none
    
    fileprivate var editableTexts: [EditableText] = []
    fileprivate var promptTexts: [String] = []
    fileprivate var deletingText = false
    
    func setupForExample(with text:String) {
        self.textView.textColor = UIColor.darkBlue
        self.validation = .none
        self.editableTexts.removeAll()
        self.promptTexts.removeAll()
        self.textView.text = text
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()

    }
    
    private func setupView() {
        
        self.textView.text = nil
        
        let tapEdit = UITapGestureRecognizer(target: self, action: #selector(self.editTapped))
        self.textView.addGestureRecognizer(tapEdit)
        self.textView.isEditable = false
        
        self.textView.layer.cornerRadius = UIMock.Appearance.cornerRadius
        self.textView.layer.borderWidth = UIMock.Appearance.borderWidth
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.textView.delegate = self
        self.textView.returnKeyType = .done

    }

}

extension ZillianceTextViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.textView.isEditable = false
        self.textView.dataDetectorTypes = [.all];
    }
    
    func replaceTappableText(index: Int, withText text: String, selectedIndexes: [Int]?)
    {
        let editableText = self.editableTexts[index].text
        if var currentText = self.textView.text, let range = currentText.range(of: editableText)
        {
            currentText.replaceSubrange(range, with: text)
            self.textView.text = currentText
            
            if (text.characters.count == 0)
            {
                self.editableTexts.remove(at: index)
            }
            else
            {
                self.editableTexts[index].text = text
                self.editableTexts[index].selectedIndexes = selectedIndexes
            }
            self.validation.removeValues()
            self.setupTextView()
            
            let nsRange = editableText.nsRange(from: range)
            
            //we want to position the cursor at the end of the new selection
            let newSelectionRange = NSRange(location: nsRange.location + text.characters.count + 1, length: 0)
            self.textView.selectedRange = newSelectionRange
            
        }
    }
    
    func setupTextView() {
        
        let currentText: String = self.textView.text
        
        let attributedString = NSMutableAttributedString(string: currentText, attributes: [
            NSFontAttributeName : UIFont.muliRegular(size: 15)
            ])
        
        for editableText in self.editableTexts {
            
            let range = (currentText as NSString).range(of: editableText.text)
            
            if (range.location != NSNotFound)
            {
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue , range: range)
            }
        }
        
        for promptText in self.promptTexts {
            
            let range = (currentText as NSString).range(of: promptText)
            
            if (range.location != NSNotFound)
            {
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray , range: range)
            }
        }
        
        self.textView.attributedText = attributedString
        self.textView.delegate = self
    }
    
    
    func editTapped(tap: UITapGestureRecognizer) {
        
        let point = tap.location(in: self.textView)
        
        guard let position = self.textView.closestPosition(to: point) else {
            return
        }
        
        let range = self.textView.textRange(from: position, to: position)
        
        self.textView.selectedTextRange = range
        
        self.textView.dataDetectorTypes = []
        self.textView.isEditable = true
        self.textView.becomeFirstResponder()
    }
    
    func tappableIndexForRange(range: NSRange, textsList: [String]) -> Int?
    {
        guard self.textView.text.characters.count > 0 else {
            return nil
        }
        
        var range = range
        range.length = 1 // when you tap it's 0 but we need to go one to the right to know if it overlaps
        
        let stringRange = self.textView.text.range(from: range)
        
        guard let sRange = stringRange else {
            return nil
        }
        
        for (index, element) in textsList.enumerated()
        {
            if let tapped = self.textView.text.range(of: element)?.overlaps(sRange), (tapped)
            {
                return index
            }
        }
        
        return nil
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        
        var range = self.textView.selectedRange
        
        //range.length == 0 -> Tap OR delete. We only want a tap but not a delete
        
        guard textView.text.characters.count > range.location && range.length == 0 && !self.deletingText
            else
        {
            self.deletingText = false
            return
        }
        
        //  this is a workaround to the fact that when you select a word sometimes iOS sets the selection at the end so it would not allow us to assume it's a tap inside that word
        if (range.location > 0)
        {
            range = NSRange(location: range.location - 1, length: 1)
        }
        
//        let editableTexts = self.editableTexts.map{ $0.text }
//        
//        if let indexTapped = self.tappableIndexForRange(range: range, textsList: editableTexts)
//        {
//            self.handleTextEditTapped(index: indexTapped)
//        }
//        else
//        {
//            if let indexTapped = self.tappableIndexForRange(range: range, textsList: self.promptTexts)
//            {
//                self.handleTextPromptTapped(index: indexTapped)
//            }
//        }
    }
    
    func handleTextPromptTapped(index: Int)
    {
        let prompt = self.promptTexts[index]
        
        if let selectedRange = self.textView.text.nsRange(from: prompt), (self.textView.selectedRange.location != selectedRange.location)
        {
            self.textView.selectedRange = selectedRange
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        
        if self.tappableIndexForRange(range: range, textsList: self.promptTexts) != nil {
            self.validation.removePlaceholders()
        }
        
        let deleteTapped = (text.characters.count == 0 && range.length == 1)
        
        if (deleteTapped)
        {
            let editableTexts = self.editableTexts.map{ $0.text }
            
            if let indexTapped = self.tappableIndexForRange(range: range, textsList: editableTexts), let selectedRange = textView.text.nsRange(from: self.editableTexts[indexTapped].text)
            {
                //remove the tappable text
                self.replaceTappableText(index: indexTapped, withText: "", selectedIndexes: nil)
                
                let newSelection = NSRange(location: selectedRange.location, length: 0)
                textView.selectedRange = newSelection
                
                return false
            }
            
            self.deletingText = true
            
        }
        else
        {
            //if writing over the prompt, the font color should go back to black
            if let indexTapped = self.tappableIndexForRange(range: range, textsList: self.promptTexts)
            {
                let prompt = self.promptTexts[indexTapped]
                
                //selectingRange = range means it selected the prompt
                if let selectedRange = textView.text.nsRange(from: prompt), (selectedRange == range)
                {
                    let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
                    attributedString.removeAttribute(NSForegroundColorAttributeName, range: range)
                    attributedString.replaceCharacters(in: range, with: "")
                    
                    textView.attributedText = attributedString
                    
                    let newSelection = NSRange(location: selectedRange.location, length: 0)
                    textView.selectedRange = newSelection
                }
            }
        }
        
        return true
    }
    
    // MARK : --
    
}

//MARK -- Extensions

extension String {
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else { return nil }
        return from ..< to
    }
    
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                       length: utf16.distance(from: from, to: to))
    }
    
    func nsRange(from string: String) -> NSRange?
    {
        if let range = self.range(of: string)
        {
            return self.nsRange(from: range)
        }
        return nil
    }
}

extension NSRange {
    static func ==(lhs: NSRange, rhs: NSRange) -> Bool {
        return lhs.location == rhs.location && lhs.length == rhs.length
    }
    
    static func !=(lhs: NSRange, rhs: NSRange) -> Bool {
        return !(lhs == rhs)
    }
    
}
