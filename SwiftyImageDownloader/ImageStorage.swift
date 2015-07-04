//
//  ImageStorage.swift
//  SwiftyImageDownloader
//
//  Created by Saurabh Jain on 7/4/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

public class ImageStorage: Storage {
    
    static let sharedStorage = ImageStorage()
    
    let disk = DiskStorage.sharedStorage
    let memory = MemoryStorage.sharedStorage
    
    func addImage(key: String, image: UIImage) {
        self.disk.addImage(key, image: image)
        self.memory.addImage(key, image: image)
    }
    
    func imageForKey(key: String) -> UIImage? {
        if let image = memory.imageForKey(key) {
            return image
        }
        
        if let image = disk.imageForKey(key) {
            memory.addImage(key, image: image)
            return image
        }
        return nil
    }
    
    public func clearCache() {
        memory.clearCache()
        disk.clearCache()
    }
}
