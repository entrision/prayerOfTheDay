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
    @IBOutlet var scroll:UIScrollView!
    @IBOutlet var contentView:UIView!
    
    var selectedPrayer: PhotoPrayer?
    var prayerDate:String!
    var pageIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedPrayer = Utilities.getPrayerForDate(prayerDate)
        
        if let data = selectedPrayer?.photo {
            image.image = UIImage(data: data)
            
            if image.image!.size.height > image.image!.size.width {
                image.contentMode = UIViewContentMode.Top
            }
        }
        
        if let prayerText = selectedPrayer?.prayer {
            prayer.text = prayerText
        }
        //prayer.text = selectedPrayer?.prayer + "\n\n" + selectedPrayer?.prayer
        //prayer.sizeToFit()
        
        //self.view.layoutIfNeeded()
        
        location.text = selectedPrayer?.location
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
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
//        scroll.contentSize = contentView.frame.size
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)

        prayer.textAlignment = NSTextAlignment.Center
        prayer.scrollEnabled = false
        
        scroll.layoutIfNeeded()
        self.view.layoutIfNeeded()
    }
    
    // MARK: - button handlers
    // ----------------------------------------
    
    @IBAction func donateButtonClicked(sender: UIButton) {
        let targetURL = NSURL(string: "https://secure.ob.org/site/Donation2?df_id=8000&8000.donation=form1")
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
    
    func pinterestClicked(notification: NSNotification) {
        
        let pinterest = notification.object as! Pinterest
        
        let imageUrl = NSURL(string: selectedPrayer!.photoURL)
        let sourceUrl = NSURL(string: "")
        
        pinterest.createPinWithImageURL(imageUrl, sourceURL: sourceUrl, description: selectedPrayer?.prayer)
    }
    
    func twitterClicked(notification: NSNotification) {

        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            var selectedPrayer = Utilities.getPrayerForDate(prayerDate)
            
            var twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            let prayerString = selectedPrayer?.prayer
            if count(prayerString!) > 114 {
                twitterSheet.setInitialText("\(prayerString!.substringToIndex(advance(prayerString!.startIndex, 114)))...")
            } else {
                twitterSheet.setInitialText(prayerString!)
            }
            
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
        
        let prayer = selectedPrayer!.prayer.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        var shareURL = NSURL(string: "tumblr://x-callback-url/link?title=Daily%20Photo%20Prayer&url=\(selectedPrayer!.photoURL)")
        var canOpenURL = UIApplication.sharedApplication().canOpenURL(shareURL!)
        
        if !canOpenURL {
            shareURL = NSURL(string: "http://tumblr.com/share?s=&v=3&t=Daily%20Photo%20Prayer&u=\(selectedPrayer!.photoURL)")
        }
        
        UIApplication.sharedApplication().openURL(shareURL!)
    }
    
    func googleClicked(notification: NSNotification) {
        
        let signIn = GPPSignIn.sharedInstance()
        signIn.shouldFetchGooglePlusUser = true
        signIn.clientID = "801561423457-lmampo6rktpa4d6bu32anaftoos1jgqi.apps.googleusercontent.com"
        signIn.delegate = self
        signIn.scopes = [kGTLAuthScopePlusLogin]
        signIn.authenticate()
    }
    
    func facebookClicked(notification: NSNotification) {
        
        if let selectedPrayer = Utilities.getPrayerForDate(prayerDate) {
            let photo = FBSDKSharePhoto(image: UIImage(data: selectedPrayer.photo), userGenerated: true)
            let content = FBSDKSharePhotoContent()
            content.photos = [photo]
            FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: self)
        }
        
//        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
//            var facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//            var selectedPrayer = Utilities.getPrayerForDate(prayerDate)
//            
//            var prayer = selectedPrayer?.prayer
//            facebookSheet.setInitialText("Photo Prayer of the Day\n" + prayer!)
//            
//            var image = selectedPrayer?.photo
//            facebookSheet.addImage(UIImage(data:image!))
//            
//            self.presentViewController(facebookSheet, animated: true, completion: nil)
//        } else {
//            var alert = UIAlertController(title: "Facebook", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//        }
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

extension SinglePrayerViewController: FBSDKSharingDelegate {
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        
        var alert = UIAlertController(title: "Facebook", message: "Please login to your Facebook account by going to Settings > Facebook.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
        
    }
}
