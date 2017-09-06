//
//  TSRAnalytics.swift
//  Think Shift Release
//
//  Created by Ignacio Zunino on 04-09-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import ZilliancePod

final class TSRAnalytics: ZillianceAnalytics {
    
    enum TSRDetailedAnalyticEvents: AnalyticEvent {
        case meditationAudioStarted(String)
        case meditationAudioStopped(String)
        case meditationAudioFinished(String)
        case videoStarted(String)
        case videoStopped(String)
        case videoCompleted(String)
        
        var name: String {
            
            switch self {
            case .meditationAudioStarted(_):
                return "Meditation Audio Started"
            case .meditationAudioStopped(_):
                return "Meditation Audio Stopped"
            case .meditationAudioFinished(_):
                return "Meditation Audio Finished"
            case .videoStarted(_):
                return "Video Started"
            case .videoStopped(_):
                return "Video Stopped"
            case .videoCompleted(_):
                return "Video Completed"
            }
        }
        
        var data: [String: Any]? {
            switch self {
            case .meditationAudioStarted(let name):
                return ["name": name]
            case .meditationAudioStopped(let name):
                return ["name": name]
            case .meditationAudioFinished(let name):
                return ["name": name]
            case .videoStarted(let name):
                return ["name": name]
            case .videoStopped(let name):
                return ["name": name]
            case .videoCompleted(let name):
                return ["name": name]
            }
        }

        
    }
    
    enum TSRAnalyticEvents: String, AnalyticEvent {
        //stressor
        case newStressor
        case stressorCompleted
        case stressorResumed
        case stressorDeleted
        
        //tsr
        case thinkStepCompleted
        case shiftStepCompleted
        case releaseStepCompleted
        
        //shift
        case shiftAddedNewVideo
        case shiftAddedNewImage
        case shiftAddedNewMusic
        case shiftAddedNewQuote
        
        case shiftStartedPlayingVideo
        case shiftFinishedPlayingVideo
        case shiftStartedPlayingMusic
        case shiftFinishedPlayingMusic
        case shiftSawImage

    }
    
}
