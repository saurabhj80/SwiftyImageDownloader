//
//  ImageOperation.swift
//  SwiftyImageDownloader
//
//  Created by Saurabh Jain on 7/4/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

typealias ImageOperationCompletionBlock = ((image: UIImage?, error: NSError?) -> Void)

internal class ImageOperation: NSOperation, NSURLSessionDownloadDelegate {
    
    // MARK: - Properties
    
    // URL of the image
    private var url: NSURL
    
    // The session task
    private var task: NSURLSessionDownloadTask?
    
    // Completion Block
    private var block: ImageOperationCompletionBlock?
    
    init(url: NSURL, block: ImageOperationCompletionBlock?) {
        self.url = url
        self.block = block
    }
    
    // MARK: - Overrides
    
    private var session: NSURLSession!
    
    override func start() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        task = session.downloadTaskWithURL(self.url)
        task!.resume()
    }
    
    override func cancel() {
        task?.cancel()
        session.finishTasksAndInvalidate()
        self.finished = true
    }
    
    // Override Finished
    override var finished: Bool {
        get {
            return _finished
        }
        set {
            willChangeValueForKey("isFinished")
            _finished = newValue
            didChangeValueForKey("isFinished")
        }
    }
    
    private var _finished = false
    
    // MARK: - NSURLSessionDownload Delegate
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        if let data = NSData(contentsOfURL: location), let image = UIImage(data: data) {
            block?(image: image, error: nil)
        }
        session.finishTasksAndInvalidate()
        task = nil
        self.finished = true
    }
}

