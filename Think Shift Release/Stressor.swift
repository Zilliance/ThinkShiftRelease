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
        let strings = [self.thinkThoughts, self.thinkInnerWisdom, self.thinkActionStep, self.thinkBetterFeeling, self.shiftBoundariesDoTalkWith, self.shiftBoundariesNotTalkWith, self.releaseIntention, self.releaseAffirmation]
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
    dynamic var releaseIntention: String?
    dynamic var releaseAffirmation: String?
    
}
