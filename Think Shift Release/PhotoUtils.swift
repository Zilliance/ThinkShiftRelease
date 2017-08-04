//
//  PhotoUtils.swift
//  Think Shift Release
//
//  Created by Ignacio Zunino on 04-08-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import Photos

final class PhotoUtils {
    
    static func getPhoto(assetURL: URL) -> UIImage? {
        
        var retrievedPhoto: UIImage?
        
        let fetchResults = PHAsset.fetchAssets(withALAssetURLs: [assetURL], options: nil)
        
        let options = PHImageRequestOptions()
        options.resizeMode = .exact
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = true
        
        fetchResults.enumerateObjects(using: { asset, index, _ in
            PHImageManager.default().requestImage(for: asset, targetSize:  PHImageManagerMaximumSize , contentMode: .aspectFill, options: options, resultHandler: {(image, info) in
                
                retrievedPhoto = image
                
            })
        })
        
        return retrievedPhoto
        
    }
    
}
