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
    dynamic var completed: Bool = false
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
