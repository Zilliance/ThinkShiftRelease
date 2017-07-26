//
//  User.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/20/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import RealmSwift

final class StringObject: Object {

    dynamic var value: String?
    
    convenience init(internalValue: String) {
        self.init()
        self.value = internalValue
    }
    
}

final class User: Object {
    
    let stressors = List<Stressor>()
    
    var incompleteStressors: [Stressor] {
        return Array( self.stressors.filter("completed = false") )
    }
    
    let audioPaths = List<StringObject>()
    let imagesPaths = List<StringObject>()
    let videoPaths = List<StringObject>()
    let quotes = List<Quote>()
    
    private func addMedia(list: List<StringObject>, value: String) {
        Database.shared.save {
            list.append(StringObject(internalValue: value))
        }
    }

    func addAudio(audioPath: String) {
        self.addMedia(list: self.audioPaths, value: audioPath)
    }

    func addVideo(videoPath: String) {
        self.addMedia(list: self.videoPaths, value: videoPath)
    }

    func addImage(imagePath: String) {
        self.addMedia(list: self.imagesPaths, value: imagePath)
    }

    func addQuote(quote: Quote) {
        Database.shared.save {
            self.quotes.append(quote)
        }
    }
    
}
