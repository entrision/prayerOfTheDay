//
//  SelectPrayerViewController.swift
//  PrayerOfTheDay
//
//  Created by Travis Wade on 3/26/15.
//  Copyright (c) 2015 OperationBlessing. All rights reserved.
//

import UIKit

class SelectPrayerViewController: OperationBlessingBaseViewController {

    @IBOutlet var todayImage: UIImageView!
    @IBOutlet var day1Image: UIImageView!
    @IBOutlet var day2Image: UIImageView!
    @IBOutlet var day3Image: UIImageView!
    @IBOutlet var day4Image: UIImageView!
    @IBOutlet var day5Image: UIImageView!
    @IBOutlet var day6Image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        todayImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "prayerClicked:"))
        day1Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "prayerClicked:"))
        day2Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "prayerClicked:"))
        day3Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "prayerClicked:"))
        day4Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "prayerClicked:"))
        day5Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "prayerClicked:"))
        day6Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "prayerClicked:"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    // -------------------------------------------
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    // MARK: - gesture handler
    // -------------------------------------------
    
    func prayerClicked(gesture: UITapGestureRecognizer) {
        var image:UIView = gesture.view!
        
        // TODO: get the right Prayer
        
        self.performSegueWithIdentifier("SinglePrayerSegue", sender: nil)
    }
    
}
