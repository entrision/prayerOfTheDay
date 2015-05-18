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
        
        //pageViewController?.view.frame = self.view.bounds
        pageViewController?.view.frame = CGRectMake(0, 64, self.view.bounds.width, self.view.bounds.height)
        pageViewController?.didMoveToParentViewController(self)
        self.automaticallyAdjustsScrollViewInsets = false
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
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return prayers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
