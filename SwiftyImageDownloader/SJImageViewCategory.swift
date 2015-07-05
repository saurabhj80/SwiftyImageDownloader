//
//  SJImageViewCategory.swift
//  SwiftyImageDownloader
//
//  Created by Saurabh Jain on 7/3/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

private var ImageViewAssociatedObjectHandle: UInt8 = 0
private var ImageViewIndexPathAssociatedObjectHandle: UInt8 = 0

public extension UIImageView {
    
    public func setImgUrl(url: NSURL?, indexPath: NSIndexPath, completionBlock:(image: UIImage?, error: NSError?) -> Void) {
        
        // Makes stuff efficient
        cancelDownload()
        
        if let url = url {
            let operation = ImageManager.sharedManager.downloadImage(url, indexPath: indexPath) { [weak self] (image, error) in
                // Because the block is called from different threads
                dispatch_async(dispatch_get_main_queue()) {
                    self?.image = image
                    completionBlock(image: image, error: error)
                }
            }
            if operation != nil {
                self.operation = operation
                self.indexPath = indexPath
            }
        } else {
            let error = NSError(domain: "Download Error", code: 001, userInfo: [NSLocalizedDescriptionKey: "Wrong Url"])
            completionBlock(image: nil, error: error)
        }
    }
    
    private var indexPath: NSIndexPath? {
        get { return objc_getAssociatedObject(self, &ImageViewIndexPathAssociatedObjectHandle) as? NSIndexPath }
        set {
            objc_setAssociatedObject(self, &ImageViewIndexPathAssociatedObjectHandle, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
    
    private var operation: ImageOperation? {
        get { return objc_getAssociatedObject(self, &ImageViewAssociatedObjectHandle) as? ImageOperation }
        set {
            objc_setAssociatedObject(self, &ImageViewAssociatedObjectHandle, newValue,
                objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
    
    private func cancelDownload() {
        operation?.cancel()
        if let indexPath = self.indexPath {
            ImageManager.sharedManager.pendingOperations.removeValueForKey(indexPath)
        }
    }
}
