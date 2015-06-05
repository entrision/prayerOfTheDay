//
//  SinglePrayerViewController.swift
//  PrayerOfTheDay
//
//  Created by Travis Wade on 3/26/15.
//  Copyright (c) 2015 OperationBlessing. All rights reserved.
//

import UIKit
import Social

class SinglePrayerViewController: OperationBlessingBaseViewController, GPPSignInDelegate {

    @IBOutlet var image:UIImageView!
    @IBOutlet var location:UILabel!
    @IBOutlet var prayer:UITextView!
    @IBOutlet var photoButton:UIButton!
    @IBOutlet var videoButton:UIButton!
    @IBOutlet var donateButton:UIButton!
    @IBOutlet var prayerHeightConstraint:NSLayoutConstraint!
    @IBOutlet var contentViewHeightConstraint:NSLayoutConstraint!
    @IBOutlet var scroll:UIScrollView!
    @IBOutlet var contentView:UIView!
    @IBOutlet var socialView:UIView!
    
    var selectedPrayer: PhotoPrayer?
    var prayerDate:String!
    var pageIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedPrayer = Utilities.getPrayerForDate(prayerDate)
        
        if let data = selectedPrayer?.photo {
            image.image = UIImage(data: data)
        }
        
        if let prayerText = selectedPrayer?.prayer {
            prayer.text = prayerText
        }
        //prayer.text = selectedPrayer?.prayer + "\n\n" + selectedPrayer?.prayer
        //prayer.sizeToFit()
        
        //self.view.layoutIfNeeded()
        
        location.text = selectedPrayer?.location
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: Selector("youTubeClicked:"), name: Strings.tappedYoutubeNotification, object: nil)
        notificationCenter.addObserver(self, selector: Selector("facebookClicked:"), name: Strings.tappedFacebookNotification, object: nil)
        notificationCenter.addObserver(self, selector: Selector("twitterClicked:"), name: Strings.tappedTwitterNotification, object: nil)
        notificationCenter.addObserver(self, selector: Selector("tumblrClicked:"), name: Strings.tappedTumblrNotification, object: nil)
        notificationCenter.addObserver(self, selector: Selector("googleClicked:"), name: Strings.tappedGoogleNotification, object: nil)
        notificationCenter.addObserver(self, selector: Selector("pinterestClicked:"), name: Strings.tappedPinterestNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //scroll.contentSize = contentView.frame.size
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        prayerHeightConstraint.constant = CGFloat(prayer.sizeThatFits(CGSizeMake(prayer.frame.size.width, CGFloat.max)).height + 50)
        prayer.textAlignment = NSTextAlignment.Center

        scroll.layoutIfNeeded()
        self.view.layoutIfNeeded()
    }
    
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
    
    func youTubeClicked(notification: NSNotification) {
        var url = NSURL(string: "vnd.youtube://watch?v=SSnn0r4chuA#action=share")
        var canOpenURL = UIApplication.sharedApplication().canOpenURL(url!)
        
        if(!canOpenURL) {
            url = NSURL(string: "https://www.youtube.com/user/operationblessing")
        }
        
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func pinterestClicked(notification: NSNotification) {
//        var url = NSURL(string: "pinterest://user/operationbless/")
//        var canOpenURL = UIApplication.sharedApplication().canOpenURL(url!)
//        
//        if(!canOpenURL) {
//            url = NSURL(string: "https://www.pinterest.com/operationbless/")
//        }
//        
//        UIApplication.sharedApplication().openURL(url!)
        
        let pinterest = notification.object as! Pinterest
        
        let imageUrl = NSURL(string: selectedPrayer!.photoURL)
        let sourceUrl = NSURL(string: "")
        
        pinterest.createPinWithImageURL(imageUrl, sourceURL: sourceUrl, description: selectedPrayer?.prayer)
    }
    
    func twitterClicked(notification: NSNotification) {
        /*
        var url = NSURL(string: "twitter://user?screen_name=operationbless")
        var canOpenURL = UIApplication.sharedApplication().canOpenURL(url!)
        
        if(!canOpenURL) {
            url = NSURL(string: "https://twitter.com/operationbless")
        }
        
        UIApplication.sharedApplication().openURL(url!)
*/
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            var selectedPrayer = Utilities.getPrayerForDate(prayerDate)
            
            var twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText("Photo Prayer of the Day")
            
            var image = selectedPrayer?.photo
            twitterSheet.addImage(UIImage(data:image!))
            
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Twitter", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func tumblrClicked(notification: NSNotification) {
//        var url = NSURL(string: "pinterest://user/operationbless/")
//        var canOpenURL = UIApplication.sharedApplication().canOpenURL(url!)
//        
//        if(!canOpenURL) {
//            url = NSURL(string: "http://operationblessing.tumblr.com/?mc_cid=fbdcb9fd67&mc_eid=1700c53f2c")
//        }
//        
//        UIApplication.sharedApplication().openURL(url!)
        
        let prayer = selectedPrayer!.prayer.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        var shareURL = NSURL(string: "tumblr://x-callback-url/link?title=Daily%20Photo%20Prayer&url=\(selectedPrayer!.photoURL)")
        var canOpenURL = UIApplication.sharedApplication().canOpenURL(shareURL!)
        
        if !canOpenURL {
            shareURL = NSURL(string: "http://tumblr.com/share?s=&v=3&t=Daily%20Photo%20Prayer&u=\(selectedPrayer!.photoURL)")
        }
        
        UIApplication.sharedApplication().openURL(shareURL!)
    }
    
    func googleClicked(notification: NSNotification) {
//        var url = NSURL(string: "gplus://110842766638826456360/posts")
//        var canOpenURL = UIApplication.sharedApplication().canOpenURL(url!)
//        
//        if(!canOpenURL) {
//            url = NSURL(string: "https://plus.google.com/110842766638826456360/posts")
//        }
//        
//        UIApplication.sharedApplication().openURL(url!)
        
        let signIn = GPPSignIn.sharedInstance()
        signIn.shouldFetchGooglePlusUser = true
        signIn.clientID = "801561423457-lmampo6rktpa4d6bu32anaftoos1jgqi.apps.googleusercontent.com"
        signIn.delegate = self
        signIn.scopes = [kGTLAuthScopePlusLogin]
        signIn.authenticate()
    }
    
    func facebookClicked(notification: NSNotification) {
        /*
        var url = NSURL(string: "fb://operationblessing")
        var canOpenURL = UIApplication.sharedApplication().canOpenURL(url!)
        
        if(!canOpenURL) {
            url = NSURL(string: "https://www.facebook.com/operationblessing")
        }
        
        UIApplication.sharedApplication().openURL(url!)
*/
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            var facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            var selectedPrayer = Utilities.getPrayerForDate(prayerDate)
            
            var prayer = selectedPrayer?.prayer
            facebookSheet.setInitialText("Photo Prayer of the Day\n" + prayer!)
            
            var image = selectedPrayer?.photo
            facebookSheet.addImage(UIImage(data:image!))
            
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Facebook", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: GPPShareDelegate
    
    func finishedWithAuth(auth: GTMOAuth2Authentication,  error: NSError ) -> Void{

        let shareBuilder = GPPShare.sharedInstance().nativeShareDialog()
        shareBuilder.attachImageData(selectedPrayer!.photo)
        shareBuilder.setPrefillText(selectedPrayer!.prayer)
        shareBuilder.open()
    }
    
    func didDisconnectWithError ( error: NSError) -> Void{
        debugPrintln("TEST2")
    }
}
