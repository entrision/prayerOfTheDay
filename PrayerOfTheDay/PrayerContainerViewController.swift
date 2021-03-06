//
//  PrayerContainerViewController.swift
//  PrayerOfTheDay
//
//  Created by Travis Wade on 5/15/15.
//  Copyright (c) 2015 OperationBlessing. All rights reserved.
//

import UIKit
import Social
//import PinterestSDK

class PrayerContainerViewController: OperationBlessingBaseViewController {

    var prayers: NSMutableDictionary!
    var startIndex: Int?
    var currentIndex: Int?
    
    @IBOutlet weak var theScrollView: UIScrollView!
    @IBOutlet weak var socialView: SocialView!
    
    var sortedPrayers = NSMutableArray()
    var viewsLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        theScrollView.delegate = self
        theScrollView.pagingEnabled = true
        theScrollView.showsHorizontalScrollIndicator = false
        theScrollView.showsVerticalScrollIndicator = false
        theScrollView.scrollsToTop = false
        
        currentIndex = startIndex
        
        view.bringSubviewToFront(socialView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !viewsLoaded {
            
            let sortedKeys = (prayers.allKeys as NSArray).sortedArrayUsingSelector(#selector(NSNumber.compare(_:)))
            for key in sortedKeys {
                sortedPrayers.addObject(prayers.objectForKey(key)!)
            }
            
            let scrollArray = NSMutableArray()
            for i in 0 ..< sortedPrayers.count {
                let prayerDate = sortedPrayers[i] as! String
                let thePrayer = Utilities.getPrayerForDate(prayerDate)
                
                let singlePrayerView = NSBundle.mainBundle().loadNibNamed("SinglePrayerView", owner: self, options: nil)![0] as! SinglePrayerView
                singlePrayerView.frame = theScrollView.bounds
                singlePrayerView.thePrayer = thePrayer
                scrollArray.addObject(singlePrayerView)
            }
            
            for i in 0 ..< scrollArray.count {
                let theWidth = theScrollView.frame.size.width;
                let frame = CGRectMake(theWidth*CGFloat(i), 0, theScrollView.frame.size.width, theScrollView.frame.size.height)
                
                let subview = UIView(frame: frame)
                subview.addSubview(scrollArray[i] as! UIView)
                self.theScrollView.addSubview(subview)
            }
            
            let width = self.theScrollView.frame.size.width * CGFloat(scrollArray.count)
            let contentSize = CGSizeMake(width, self.theScrollView.frame.size.height);
            theScrollView.contentSize = contentSize;
            
            scrollToPage(startIndex!)
            viewsLoaded = true
        }
    }
    
    func scrollToPage(page: Int) {
        let frame = CGRectMake(theScrollView.frame.size.width * CGFloat(page), 0, theScrollView.frame.size.width, theScrollView.frame.size.height)
        theScrollView.scrollRectToVisible(frame, animated: false)
    }
    
    // MARK: - social media handlers
    // ----------------------------------------
    
    @IBAction func pinterestClicked(sender: AnyObject) {
        
        PDKClient.sharedInstance().authenticateWithPermissions([PDKClientWritePublicPermissions, PDKClientWriteRelationshipsPermissions, PDKClientWritePrivatePermissions, PDKClientReadPrivatePermissions, PDKClientReadPublicPermissions, PDKClientReadRelationshipsPermissions], withSuccess: { (response) -> Void in
            let prayerDate = self.sortedPrayers[self.currentIndex!] as! String
            if let selectedPrayer = Utilities.getPrayerForDate(prayerDate) {
                let imageUrl = NSURL(string: selectedPrayer.photoURL)
                PDKPin.pinWithImageURL(imageUrl, link: NSURL(string: ""), suggestedBoardName: "", note: selectedPrayer.prayer, withSuccess: { () -> Void in
                    var x = 0
                    x++
                }, andFailure: { (error) -> Void in
                    print(error.localizedDescription)
                })
            }
        }, andFailure: { (error) -> Void in
            print(error.localizedDescription)
        })
    }
    
    @IBAction func twitterClicked(sender: AnyObject) {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let prayerDate = sortedPrayers[currentIndex!] as! String
            if let selectedPrayer = Utilities.getPrayerForDate(prayerDate) {
                let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                let prayerString = "\(selectedPrayer.location) - \(selectedPrayer.prayer)" as String
                if prayerString.characters.count > 114 {
                    twitterSheet.setInitialText("\((prayerString as NSString).substringToIndex(110))...")
                } else {
                    twitterSheet.setInitialText(prayerString)
                }
                
                let image = selectedPrayer.photo
                twitterSheet.addImage(UIImage(data:image))
                
                self.presentViewController(twitterSheet, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Twitter", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
         
            
        }
    }
    
    @IBAction func tumblrClicked(sender: AnyObject) {
        
        let prayerDate = sortedPrayers[currentIndex!] as! String
        if let selectedPrayer = Utilities.getPrayerForDate(prayerDate) {
            
            UIPasteboard.generalPasteboard().images = [UIImage(data: selectedPrayer.photo)!]

            var shareURL = NSURL(string: "tumblr://x-callback-url/photo?caption=Daily%20Photo%20Prayer")
            let canOpenURL = UIApplication.sharedApplication().canOpenURL(shareURL!)

            if !canOpenURL {
                shareURL = NSURL(string: "http://tumblr.com/share?s=&v=3&t=Daily%20Photo%20Prayer&u=\(selectedPrayer.photoURL)")
            }
        
            UIApplication.sharedApplication().openURL(shareURL!)
        }
    }
    
    @IBAction func googleClicked(sender: AnyObject) {
        
        let signIn = GPPSignIn.sharedInstance()
        signIn.shouldFetchGooglePlusUser = true
        signIn.clientID = "801561423457-lmampo6rktpa4d6bu32anaftoos1jgqi.apps.googleusercontent.com"
        signIn.delegate = self
        signIn.scopes = [kGTLAuthScopePlusLogin]
        signIn.authenticate()
    }
    
    @IBAction func facebookClicked(sender: AnyObject) {
        
        let prayerDate = sortedPrayers[currentIndex!] as! String
        if let selectedPrayer = Utilities.getPrayerForDate(prayerDate) {
            
            if UIApplication.sharedApplication().canOpenURL(NSURL(string: "fb://")!) || SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                let photo = FBSDKSharePhoto(image: UIImage(data: selectedPrayer.photo), userGenerated: true)
                let content = FBSDKSharePhotoContent()
                content.photos = [photo]
                FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: self)
            } else {
                let theContent = FBSDKShareLinkContent()
                theContent.imageURL = NSURL(string: selectedPrayer.photoURL)
                theContent.contentTitle = "Daily Photo Prayer"
                theContent.contentDescription = "\(selectedPrayer.location) - \(selectedPrayer.prayer)"
                FBSDKShareDialog.showFromViewController(self, withContent: theContent, delegate: self)
            }
        }
    }
}

extension PrayerContainerViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let pageWidth = scrollView.frame.size.width;
        currentIndex = Int(floor((self.theScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1);
    }
}

extension PrayerContainerViewController: FBSDKSharingDelegate {
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        print(error)
        let alert = UIAlertController(title: "Uh oh!", message: "Something went wrong when sharing to Facebook.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
        
    }
}

extension PrayerContainerViewController: GPPSignInDelegate {
    
    func finishedWithAuth(auth: GTMOAuth2Authentication,  error: NSError ) -> Void{
        
        let prayerDate = sortedPrayers[currentIndex!] as! String
        if let selectedPrayer = Utilities.getPrayerForDate(prayerDate) {
            let shareBuilder = GPPShare.sharedInstance().nativeShareDialog()
            shareBuilder.attachImageData(selectedPrayer.photo)
            shareBuilder.setPrefillText("\(selectedPrayer.location) - \(selectedPrayer.prayer)")
            shareBuilder.open()
        }
    }
    
    func didDisconnectWithError ( error: NSError) -> Void{
        debugPrint("TEST2")
    }
}
