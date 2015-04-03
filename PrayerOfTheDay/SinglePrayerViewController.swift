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
    @IBOutlet var prayerHeightConstraint:NSLayoutConstraint!
    
    var prayerDate:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var selectedPrayer = Utilities.getPrayerForDate(prayerDate)
        
        if let data = selectedPrayer?.photo {
            image.image = UIImage(data: data)
        }
        
        prayer.text = selectedPrayer?.prayer
        //prayer.sizeToFit()
        
        self.view.layoutIfNeeded()
        
        location.text = selectedPrayer?.location
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        prayerHeightConstraint.constant = CGFloat(prayer.sizeThatFits(CGSizeMake(prayer.frame.size.width, CGFloat.max)).height)
        prayer.textAlignment = NSTextAlignment.Center
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
        let application = UIApplication.sharedApplication()
        application.openURL(targetURL!);
    }

    // MARK: - social media handlers
    // ----------------------------------------
    
    @IBAction func youTubeClicked(sender: UITapGestureRecognizer) {
        var url = NSURL(string: "vnd.youtube://watch?v=SSnn0r4chuA#action=share")
        var canOpenURL = UIApplication.sharedApplication().canOpenURL(url!)
        
        if(!canOpenURL) {
            url = NSURL(string: "https://www.youtube.com/user/operationblessing")
        }
        
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func pinterestClicked(sender: UITapGestureRecognizer) {
        var url = NSURL(string: "pinterest://user/operationbless/")
        var canOpenURL = UIApplication.sharedApplication().canOpenURL(url!)
        
        if(!canOpenURL) {
            url = NSURL(string: "https://www.pinterest.com/operationbless/")
        }
        
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func twitterClicked(sender: UITapGestureRecognizer) {
        var url = NSURL(string: "twitter://user?screen_name=operationbless")
        var canOpenURL = UIApplication.sharedApplication().canOpenURL(url!)
        
        if(!canOpenURL) {
            url = NSURL(string: "https://twitter.com/operationbless")
        }
        
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func tumblrClicked(sender: UITapGestureRecognizer) {
        var url = NSURL(string: "pinterest://user/operationbless/")
        var canOpenURL = UIApplication.sharedApplication().canOpenURL(url!)
        
        if(!canOpenURL) {
            url = NSURL(string: "http://operationblessing.tumblr.com/?mc_cid=fbdcb9fd67&mc_eid=1700c53f2c")
        }
        
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func googleClicked(sender: UITapGestureRecognizer) {
        var url = NSURL(string: "gplus://110842766638826456360/posts")
        var canOpenURL = UIApplication.sharedApplication().canOpenURL(url!)
        
        if(!canOpenURL) {
            url = NSURL(string: "https://plus.google.com/110842766638826456360/posts")
        }
        
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func facebookClicked(sender: UITapGestureRecognizer) {
        var url = NSURL(string: "fb://operationblessing")
        var canOpenURL = UIApplication.sharedApplication().canOpenURL(url!)
        
        if(!canOpenURL) {
            url = NSURL(string: "https://www.facebook.com/operationblessing")
        }
        
        UIApplication.sharedApplication().openURL(url!)
    }
}
