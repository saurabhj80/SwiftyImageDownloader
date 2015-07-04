//
//  ImageManager.swift
//  SwiftyImageDownloader
//
//  Created by Saurabh Jain on 7/4/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

public class ImageManager {
    
    // Singleton Support
    static let sharedManager = ImageManager()
    
    // Constants
    private struct Constants {
        static let OperationQueueName = "Image Downloader Operation Queue"
    }
    
    // Returns the operation queue used by the class
    private lazy var queue: NSOperationQueue = {
        var operationQueue = NSOperationQueue()
        operationQueue.name = Constants.OperationQueueName
        return operationQueue
    }()
    
    // Keep track of operations
    var pendingOperations = [NSIndexPath : ImageOperation]()
    
    internal func downloadImage(url: NSURL, indexPath: NSIndexPath, completionBlock:(image: UIImage?, error: NSError?) -> Void) {
        
        // If image exists in cache
        if let image = ImageStorage.sharedStorage.imageForKey(url.absoluteString!) {
            completionBlock(image: image, error: nil)
        } else {
            if pendingOperations[indexPath] == nil {
                let operation = ImageOperation(url: url) { [unowned self] (image, error) in
                    if error != nil {
                        completionBlock(image: nil, error: error)
                    } else {
                        ImageStorage.sharedStorage.addImage(url.absoluteString!, image: image!)
                        completionBlock(image: image, error: nil)
                    }
                    self.pendingOperations.removeValueForKey(indexPath)
                }
                pendingOperations[indexPath] = operation
                queue.addOperation(operation)
            } else {
                completionBlock(image: nil, error: nil)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                    self.downloadImage(url, indexPath: indexPath, completionBlock: completionBlock)
                }
            }
        }
    }
    
    public func suspendOperations() {
        queue.suspended = true
    }
    
    public func resumeOperations() {
        queue.suspended = false
    }
    
}
