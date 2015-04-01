//
//  SinglePrayerViewController.swift
//  PrayerOfTheDay
//
//  Created by Travis Wade on 3/26/15.
//  Copyright (c) 2015 OperationBlessing. All rights reserved.
//

import UIKit

class SinglePrayerViewController: OperationBlessingBaseViewController {

    @IBOutlet var image:UIImageView!
    @IBOutlet var location:UILabel!
    @IBOutlet var prayer:UITextView!
    @IBOutlet var photoButton:UIButton!
    @IBOutlet var videoButton:UIButton!
    @IBOutlet var donateButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prayer.sizeToFit()
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
    
    // MARK: - button handlers
    // ----------------------------------------
    
    @IBAction func donateButtonClicked(sender: UIButton) {
        let targetURL = NSURL(string: "https://secure.ob.org/site/Donation2;jsessionid=7ED640907B0CD046E1458FD0F8567FD9.app252b?&df_id=1320&1320.donation=form1")
        let application=UIApplication.sharedApplication()
        application.openURL(targetURL!);
    }
    
    @IBAction func photoButtonClicked(sender: UIButton) {
        let targetURL = NSURL(string: "http://photos.ob.org")
        let application=UIApplication.sharedApplication()
        application.openURL(targetURL!);
    }
    
    @IBAction func videoButtonClicked(sender: UIButton) {
        let targetURL = NSURL(string: "http://videos.ob.org")
        let application=UIApplication.sharedApplication()
        application.openURL(targetURL!);
    }

}
