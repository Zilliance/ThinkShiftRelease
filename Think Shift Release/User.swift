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
    
    dynamic var internalValue: Data?
    
    convenience init(id: UInt64) {
        var id = id
        self.init()
        self.internalValue = Data(bytes: &id, count: MemoryLayout<UInt64>.size)
    }
    
    var value: UInt64? {
        
        guard let internalValue = internalValue else {
            return nil
        }
        
        let ivalue = internalValue.withUnsafeBytes { (ptr: UnsafePointer<UInt64>) -> UInt64 in
            return ptr.pointee
        }
        
        return ivalue
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
    dynamic var dateAdded = Date()
    
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
    
    
    func addAudio(audioID: UInt64) {
        Database.shared.save {
            audioPaths.append(Audio(id: audioID))
        }
    }
    
    func removeAudio(audioID: UInt64) {
        
        if let object = (Database.shared.realm.objects(Audio.self).filter {
            $0.value == audioID
        }).first {
            
            Database.shared.delete(object)
            
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
    
    func videoObject(videoPath: String) -> Video? {
        return videoPaths.filter { (video) -> Bool in
            return video.value == videoPath
        }.first
    }
    
    func imageObject(path: String) -> Image? {
        return imagesPaths.filter { (image) -> Bool in
            return image.value == path
            }.first
    }
    
    func deleteImages(objects: [Image]) {

        try? Database.shared.realm.write {
            objects.forEach { (image) in
                if let index = imagesPaths.index(of: image) {
                    self.imagesPaths.remove(objectAtIndex: index)
                }
                Database.shared.realm.delete(image)

            }
        }
        
    }
    
    func deleteVideos(objects: [Video]) {
        
        try? Database.shared.realm.write {
            objects.forEach { (video) in
                if let index = videoPaths.index(of: video) {
                    self.videoPaths.remove(objectAtIndex: index)
                }
                
                Database.shared.realm.delete(video)
            }
            
        }
    }
    
    func remove(quote: Quote) {
        Database.shared.delete(quote)
    }
    
}
