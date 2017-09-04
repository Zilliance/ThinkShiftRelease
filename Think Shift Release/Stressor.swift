//
//  Stressor.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/20/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import RealmSwift

final class Stressor: Object {
    dynamic var id: String = UUID().uuidString
    override class func primaryKey() -> String? {
        return "id"
    }
    
    dynamic var title: String?
    
    var completed: Bool {
        return (self.thinkCompleted && self.shiftCompleted && self.releaseCompleted)
    }
    
    var thinkCompleted: Bool {
        let strings = [self.thinkThoughts, self.thinkInnerWisdom, self.thinkActionStep, self.thinkBetterFeeling]
        return strings.flatMap { $0 }.filter { $0.isEmpty == false }.count == strings.count
    }
    
    var shiftCompleted: Bool {
        let strings = [self.shiftBoundariesDoTalkWith, self.shiftBoundariesNotTalkWith]
        return strings.flatMap { $0 }.filter { $0.isEmpty == false }.count == strings.count
    }
    
    var releaseCompleted: Bool {
        let strings = [self.releaseMyIntention, self.releaseAffirmation, self.releaseInsteadExperience]
        return strings.flatMap { $0 }.filter { $0.isEmpty == false }.count == strings.count
    }
    
    dynamic var dateCreated: Date = Date()
    
    //think
    dynamic var thinkThoughts: String?
    dynamic var thinkInnerWisdom: String?
    dynamic var thinkActionStep: String?
    dynamic var thinkBetterFeeling: String?
    
    //shift
    dynamic var shiftBoundariesNotTalkWith: String?
    dynamic var shiftBoundariesDoTalkWith: String?
    
    //release
    dynamic var releaseMyIntention: String?
    dynamic var releaseInsteadExperience: String?
    dynamic var releaseAffirmation: String?
    
    //copy from stressor
    
    func copy(from stressor:Stressor) {
        
        self.thinkThoughts = stressor.thinkThoughts
        self.dateCreated = stressor.dateCreated
        self.thinkInnerWisdom = stressor.thinkInnerWisdom
        self.thinkActionStep = stressor.thinkActionStep
        self.thinkBetterFeeling = stressor.thinkBetterFeeling
        
        self.shiftBoundariesDoTalkWith = stressor.shiftBoundariesDoTalkWith
        self.shiftBoundariesNotTalkWith = stressor.shiftBoundariesNotTalkWith
        
        self.releaseAffirmation = stressor.releaseAffirmation
        self.releaseMyIntention = stressor.releaseMyIntention
        self.releaseAffirmation = stressor.releaseAffirmation
    }
    
}
