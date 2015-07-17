//
//  PrayerContainerViewController.swift
//  PrayerOfTheDay
//
//  Created by Travis Wade on 5/15/15.
//  Copyright (c) 2015 OperationBlessing. All rights reserved.
//

import UIKit

class PrayerContainerViewController: OperationBlessingBaseViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pageViewController: UIPageViewController?
    var prayers: NSMutableDictionary!
    var startIndex: Int?
    
    @IBOutlet weak var socialView: SocialView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        pageViewController = storyboard.instantiateViewControllerWithIdentifier("PageViewController") as? UIPageViewController
        pageViewController?.dataSource = self
        pageViewController?.delegate = self

        let singlePrayerVC = self.storyboard?.instantiateViewControllerWithIdentifier("SinglePrayerViewController") as! SinglePrayerViewController
        singlePrayerVC.prayerDate = prayers.objectForKey(startIndex!) as! String
        singlePrayerVC.pageIndex = startIndex
        
        let controllers: NSArray = [singlePrayerVC]
        
        pageViewController!.setViewControllers(controllers as [AnyObject], direction: .Forward, animated: false, completion: nil)
        
        self.addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        
        pageViewController?.view.frame = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height - socialView.frame.size.height)
        pageViewController?.didMoveToParentViewController(self)
        self.automaticallyAdjustsScrollViewInsets = false
        self.edgesForExtendedLayout = UIRectEdge.None

        view.bringSubviewToFront(socialView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - page view delegate
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! SinglePrayerViewController).pageIndex!
        
        if (index <= 0) {
            return nil
        }
        
        index--
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! SinglePrayerViewController).pageIndex!
        
        index++
        
        if (index >= prayers.count) {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {

        let singlePrayerVC = self.storyboard?.instantiateViewControllerWithIdentifier("SinglePrayerViewController") as! SinglePrayerViewController
        singlePrayerVC.prayerDate = prayers.objectForKey(index) as! String
        singlePrayerVC.pageIndex = index
        
        return singlePrayerVC
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
