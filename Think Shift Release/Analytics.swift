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
import ZilliancePod

final class Analytics: AnalyticsService {
    
    static let shared = Analytics()
    
    func initialize() {
        
        //Fabric
        Fabric.with([Answers.self])
        
        //Amplitude
        Amplitude.instance().initializeApiKey("18145b777826a76ff2fefbeaaa4e0e8b")
        
        ZillianceAnalytics.initialize(projectName: "Think.Shift.Release.", analyticsService: self)
        
    }
    
    func send(event: AnalyticEvent) {
        
        Answers.logCustomEvent(withName: event.name, customAttributes: event.data)
        
        Amplitude.instance().logEvent(event.name, withEventProperties: event.data)
        
    }
    
}
