//
//  DiskStorage.swift
//  SwiftyImageDownloader
//
//  Created by Saurabh Jain on 7/4/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

internal protocol Storage: class {
    func addImage(key: String, image: UIImage)
    func imageForKey(key: String) -> UIImage?
    func clearCache()
}

internal class DiskStorage: Storage {
    
    // Singleton Support
    static let sharedStorage = DiskStorage()
    
    // The default file manager
    private lazy var fileManager = NSFileManager.defaultManager()
    
    let queue: dispatch_queue_t = {
        return dispatch_queue_create("Save Disk Storage", DISPATCH_QUEUE_SERIAL)
    }()
    
    // The path where the directory exists
    let storagePath: String
    
    internal convenience init() {
        self.init(name: "default")
    }
    
    internal init(name: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        storagePath = (paths.first as! NSString).stringByAppendingPathComponent("saurabh")
        fileManager.createDirectoryAtPath(storagePath, withIntermediateDirectories: true, attributes: nil, error: nil)
    }
    
    // Add Image
    internal func addImage(key: String, image: UIImage) {
        dispatch_async(queue) {
            self.fileManager.createFileAtPath(self.defaultStoragePath(forKey: key), contents: UIImagePNGRepresentation(image), attributes: nil)
        }
    }
    
    // Get image
    internal func imageForKey(key: String) -> UIImage? {
        if let data = NSData(contentsOfFile: defaultStoragePath(forKey: key)) {
            return UIImage(data: data)
        }
        return nil
    }
    
    // Clear Cache
    internal func clearCache() {
        dispatch_async(queue) { [unowned self] in
            var error: NSError?
            self.fileManager.removeItemAtPath(self.storagePath, error: nil)
            self.fileManager.createDirectoryAtPath(self.storagePath, withIntermediateDirectories: true, attributes: nil, error: nil)
        }
    }
    
    private func defaultStoragePath(forKey key: String) -> String {
        return (storagePath as NSString).stringByAppendingPathComponent(key.MD5())
    }
}
