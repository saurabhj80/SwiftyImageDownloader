//
//  SJCollectionViewController.swift
//  SwiftyImageDownloader
//
//  Created by Saurabh Jain on 7/3/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class SJCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    override func prepareForReuse() {
        imgView.image = nil
        super.prepareForReuse()
    }
}

class SJCollectionViewController: UICollectionViewController {

    private var imageURLs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let file = NSBundle.mainBundle().pathForResource("imageURLs", ofType: "plist"),
            let paths = NSArray(contentsOfFile: file) {
                for url in paths {
                    imageURLs.append(url as! String)
                }
        }
        
        collectionView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        ImageStorage.sharedStorage.clearCache()
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SJCollectionViewCell
        let url = imageURLs[indexPath.row]
        let imageURL = NSURL(string: imageURLs[indexPath.row])
        cell.imgView.setImgUrl(imageURL,indexPath: indexPath, completionBlock: { (image, error) -> Void in
            if error != nil {
                let transition = CATransition()
                cell.imgView?.layer.addAnimation(transition, forKey: "fade")
            }
        })
        return cell
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        ImageManager.sharedManager.suspendOperations()
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            ImageManager.sharedManager.resumeOperations()
        }
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        ImageManager.sharedManager.resumeOperations()
    }

    @IBAction func clearCache(sender: UIBarButtonItem) {
        ImageStorage.sharedStorage.clearCache()
    }
    
}
