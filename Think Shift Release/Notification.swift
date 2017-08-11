//
//  Notification.swift
//  Zilliance
//
//  Created by Ignacio Zunino on 17-07-17.
//  Copyright © 2017 Pillars4Life. All rights reserved.
//

import Foundation
import RealmSwift

@objc enum dayOfTheWeek: Int32 {
    case sun = 0
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
    
}

class DayObject: Object {
    dynamic var internalValue: dayOfTheWeek = .sun
    
    var rawValue: Int {
        return Int(internalValue.rawValue)
    }
    
    convenience init(internalValue: dayOfTheWeek) {
        self.init()
        self.internalValue = internalValue
    }
    
}

class RecurrentInstance: Object {
    dynamic var id: String?
    dynamic var date: Date?
    
    convenience init(id: String, date: Date) {
        self.init()
        self.id = id
        self.date = date
    }
}

class Notification: Object{
    
    
    @objc enum NotificationType: Int32 {
        case local
        case calendar
    }
    
    @objc enum Recurrence: Int32 {
        case daily
        case weekly
        case none
    }
    
    dynamic var notificationId: String?
    
    override class func primaryKey() -> String? {
        return "notificationId"
    }
    
    dynamic var associatedObjectId: String?
    
    dynamic var startDate: Date?
    dynamic var type: NotificationType = .local
    dynamic var recurrence: Recurrence = .none
    
    dynamic var dateAdded = Date()
    
    dynamic var title: String = ""
    dynamic var body: String = ""
    
    let weekDays = List<DayObject>()
    
    let scheduledInstances = List<RecurrentInstance>()
    
    //if there's one day for the weekdays selected that is after today, select that one.
    //if not, the first one can be
    
    func getNextWeekDate(fromDate: Date) -> Date? {

        guard weekDays.count > 0 else {
            return nil
        }
        
        let nextWeekFromCreation = dateAdded.addingTimeInterval(7 * 60 * 60 * 24)

        for weekDay in weekDays {
            let nextInstance = fromDate.nextDateWithWeekDate(weekDay: weekDay.rawValue)
            if (nextInstance > fromDate) {
                if (nextInstance > nextWeekFromCreation && self.recurrence == .none) {
                    return nil
                }
                return nextInstance
            }
        }
        
        guard let firstDay = weekDays.first else {
            return nil
        }
        
        let nextDate = fromDate.nextDateWithWeekDate(weekDay: firstDay.rawValue).addingTimeInterval(60 * 60 * 24 * 7)
        
        
        if (nextDate > nextWeekFromCreation && self.recurrence == .none) {
            return nil
        }
        
        return nextDate
        
    }
    
    func nextNotificationDate(fromDate: Date = Date()) -> Date? {
        
        guard let startDate = startDate else {
            return nil
        }
        
        if (startDate > fromDate) {
            return startDate
        }
        
        guard let nextWeekDate = getNextWeekDate(fromDate: fromDate), (nextWeekDate > startDate || recurrence == .weekly) else {
            return nil
        }
        
        return nextWeekDate
        
    }
    
}
