//
//  SJImageViewCategory.swift
//  SwiftyImageDownloader
//
//  Created by Saurabh Jain on 7/3/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

public extension UIImageView {
    
    public func setImgUrl(url: NSURL?, indexPath: NSIndexPath, completionBlock:(image: UIImage?, error: NSError?) -> Void) {
        if let url = url {
            ImageManager.sharedManager.downloadImage(url, indexPath: indexPath) { [weak self] (image, error) in
                // Because the block is called from different threads
                dispatch_async(dispatch_get_main_queue()) {
                    self?.image = image
                    completionBlock(image: image, error: error)
                }
            }
        } else {
            let error = NSError(domain: "Download Error", code: 001, userInfo: [NSLocalizedDescriptionKey: "Wrong Url"])
            completionBlock(image: nil, error: error)
        }
    }
}
