//
//  PrayerContainerViewController.swift
//  PrayerOfTheDay
//
//  Created by Travis Wade on 5/15/15.
//  Copyright (c) 2015 OperationBlessing. All rights reserved.
//

import UIKit

class PrayerContainerViewController: OperationBlessingBaseViewController {

    var prayers: NSMutableDictionary!
    var startIndex: Int?
    
    @IBOutlet weak var theScrollView: UIScrollView!
    @IBOutlet weak var socialView: SocialView!
    
    var viewsLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        theScrollView.delegate = self
        theScrollView.pagingEnabled = true
        theScrollView.showsHorizontalScrollIndicator = false
        theScrollView.showsVerticalScrollIndicator = false
        theScrollView.scrollsToTop = false
        
        view.bringSubviewToFront(socialView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !viewsLoaded {
            
            let view1 = NSBundle.mainBundle().loadNibNamed("SinglePrayerView", owner: self, options: nil)[0] as! SinglePrayerView
            view1.frame = theScrollView.bounds
            
            let view2 = NSBundle.mainBundle().loadNibNamed("SinglePrayerView", owner: self, options: nil)[0] as! SinglePrayerView
            view2.frame = theScrollView.bounds
            
            let scrollArray: NSArray = [view1, view2]
            
            for(var i=0; i<scrollArray.count; ++i) {
                let theWidth = theScrollView.frame.size.width;
                let frame = CGRectMake(theWidth*CGFloat(i), 0, theScrollView.frame.size.width, theScrollView.frame.size.height)
                
                let subview = UIView(frame: frame)
                subview.addSubview(scrollArray[i] as! UIView)
                self.theScrollView.addSubview(subview)
            }
            
            let width = self.theScrollView.frame.size.width * CGFloat(scrollArray.count)
            let contentSize = CGSizeMake(width, self.theScrollView.frame.size.height);
            theScrollView.contentSize = contentSize;
            
            viewsLoaded = true
        }
    }
    
    // MARK: - social media handlers
    // ----------------------------------------
    
    @IBAction func pinterestClicked(sender: AnyObject) {
        
        var pinterest = Pinterest()
        pinterest.setValue("1445483", forKey: "clientId")
        
        NSNotificationCenter.defaultCenter().postNotificationName(Strings.tappedPinterestNotification, object: pinterest)
    }
    
    @IBAction func twitterClicked(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(Strings.tappedTwitterNotification, object: nil)
    }
    
    @IBAction func tumblrClicked(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(Strings.tappedTumblrNotification, object: nil)
    }
    
    @IBAction func googleClicked(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(Strings.tappedGoogleNotification, object: nil)
    }
    
    @IBAction func facebookClicked(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(Strings.tappedFacebookNotification, object: nil)
    }
}

extension PrayerContainerViewController: UIScrollViewDelegate {
    
    
}