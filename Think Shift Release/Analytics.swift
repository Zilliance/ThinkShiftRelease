//
//  Analytics.swift
//  EmotionTranslator
//
//  Created by Ignacio Zunino on 29-08-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import Fabric
import Answers
import Amplitude_iOS

//utilities to allow splitting a String when there's an uppercase
extension Sequence {
    func splitBefore(
        separator isSeparator: (Iterator.Element) throws -> Bool
        ) rethrows -> [AnySequence<Iterator.Element>] {
        var result: [AnySequence<Iterator.Element>] = []
        var subSequence: [Iterator.Element] = []
        
        var iterator = self.makeIterator()
        while let element = iterator.next() {
            if try isSeparator(element) {
                if !subSequence.isEmpty {
                    result.append(AnySequence(subSequence))
                }
                subSequence = [element]
            }
            else {
                subSequence.append(element)
            }
        }
        result.append(AnySequence(subSequence))
        return result
    }
}

extension Character {
    var isUpperCase: Bool { return String(self) == String(self).uppercased() }
}

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

//

protocol AnalyticEvent {

    var name: String {get}
    var data: [String: Any]? {get}
    
}

class ZillianceAnalytics {
    
    enum ZillianceDetailedAnalytics: AnalyticEvent {
        
        case tourPagedViewed(Int)
        case tourClosed(Int)
        case viewControllerShown(String)
        
        var name: String {
            switch self {
            case .tourPagedViewed(_):
                return "Tour Paged Viewed"
            case .viewControllerShown(let name):
                return "View Shown - " + name.replacingOccurrences(of: "ViewController", with: "")
            case .tourClosed(_):
                return "Tour Closed"
            }
            
        }
        
        var data: [String : Any]? {
            
            switch self {
            case .tourPagedViewed(let page):
                return ["Page": page]
            case .tourClosed(let page):
                return ["Page": page]
            case .viewControllerShown(_):
                return nil
            }
        }
    }
    
    enum ZillianceBaseAnalytics: String, AnalyticEvent {
        
        //Plan?
        case planViewed
        case calendarEventAdded
        case reminderAdded
        case repeatingReminderAdded
        
        // Sidebar
        case faqViewed
        case companyViewed
        case privacyPolycyViewed
        case termsOfServicesViewed
        
        //Summary/sharing
        case summaryViewed
        case summaryShared
        
    }
    
}

extension RawRepresentable where RawValue == String, Self: AnalyticEvent {
    
    var name: String {
        return self.rawValue.characters
            .splitBefore(separator: { $0.isUpperCase })
            .map{(String($0)).capitalizingFirstLetter()}.joined(separator: " ")
    }
    
    var data: [String: Any]? {
        return nil
    }
    
}


final class Analytics {
    
    static func initialize() {
        
        //Fabric
        Fabric.with([Answers.self])
        
        //Amplitude
        Amplitude.instance().initializeApiKey("18145b777826a76ff2fefbeaaa4e0e8b")
        
    }
    
    static func send(event: AnalyticEvent) {
        
        Answers.logCustomEvent(withName: event.name, customAttributes: event.data)
        
        Amplitude.instance().logEvent(event.name, withEventProperties: event.data)
        
    }
    
}
