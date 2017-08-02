//
//  User.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/20/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import RealmSwift

final class Audio: Object {
    
    dynamic var value: String!
    
    convenience init(path: String) {
        self.init()
        self.value = path
    }
    
}

final class Video: Object {
    
    dynamic var value: String!
    
    convenience init(path: String) {
        self.init()
        self.value = path
    }
    
}

final class Image: Object {
    
    dynamic var value: String!
    
    convenience init(path: String) {
        self.init()
        self.value = path
    }
    
}

final class User: Object {
    
    let stressors = List<Stressor>()
    
    var incompleteStressors: [Stressor] {
        return Array( self.stressors.filter("completed = false") )
    }
    
    let audioPaths = List<Audio>()
    let imagesPaths = List<Image>()
    let videoPaths = List<Video>()
    let quotes = List<Quote>()
    
    
    func addAudio(audioPath: String) {
        Database.shared.save {
            audioPaths.append(Audio(path: audioPath))
        }
    }
    
    func addVideo(videoPath: String) {
        Database.shared.save {
            videoPaths.append(Video(path: videoPath))
        }
    }
    
    func addImage(imagePath: String) {
        Database.shared.save {
            imagesPaths.append(Image(path: imagePath))
        }
    }
    
    func addQuote(quote: Quote) {
        Database.shared.save {
            self.quotes.append(quote)
        }
    }
    
}
