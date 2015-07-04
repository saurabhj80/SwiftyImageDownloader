//
//  MemoryStorage.swift
//  SwiftyImageDownloader
//
//  Created by Saurabh Jain on 7/4/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

internal class MemoryStorage: NSCache, Storage {
   
    // Singleton support
    static let sharedStorage = MemoryStorage()
    
    // Add image
    func addImage(key: String, image: UIImage) {
        setObject(UIImagePNGRepresentation(image), forKey: key.MD5())
    }
    
    // Return Image from Cache
    func imageForKey(key: String) -> UIImage? {
        if let data = objectForKey(key.MD5()) as? NSData {
            return UIImage(data: data)
        }
        return nil
    }
    
    // Clear cache
    func clearCache() {
        removeAllObjects()
    }
}
