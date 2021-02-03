//
//  PrayerContainerViewController.swift
//  PrayerOfTheDay
//
//  Created by Travis Wade on 5/15/15.
//  Copyright (c) 2015 OperationBlessing. All rights reserved.
//

import UIKit
import Social

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
        theScrollView.isPagingEnabled = true
        theScrollView.showsHorizontalScrollIndicator = false
        theScrollView.showsVerticalScrollIndicator = false
        theScrollView.scrollsToTop = false
        
        currentIndex = startIndex
        
        view.bringSubviewToFront(socialView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !viewsLoaded {
            
            let sortedKeys = (prayers.allKeys as NSArray).sortedArray(using: #selector(NSNumber.compare(_:)))
            for key in sortedKeys {
                sortedPrayers.add(prayers.object(forKey: key)!)
            }
            
            let scrollArray = NSMutableArray()
            for i in 0 ..< sortedPrayers.count {
                let prayerDate = sortedPrayers[i] as! String
                let thePrayer = Utilities.getPrayerForDate(date: prayerDate)
                
                let singlePrayerView = Bundle.main.loadNibNamed("SinglePrayerView", owner: self, options: nil)?.first as! SinglePrayerView
                singlePrayerView.frame = theScrollView.bounds
                singlePrayerView.thePrayer = thePrayer
                scrollArray.add(singlePrayerView)
            }
            
            for i in 0 ..< scrollArray.count {
                let theWidth = theScrollView.frame.size.width;
                let frame = CGRect(x: theWidth * CGFloat(i), y: 0, width: theScrollView.frame.size.width, height: theScrollView.frame.size.height)
                
                let subview = UIView(frame: frame)
                subview.addSubview(scrollArray[i] as! UIView)
                self.theScrollView.addSubview(subview)
            }
            
            let width = self.theScrollView.frame.size.width * CGFloat(scrollArray.count)
            let contentSize = CGSize(width: width, height: self.theScrollView.frame.size.height);
            theScrollView.contentSize = contentSize;
            
            scrollToPage(page: startIndex!)
            viewsLoaded = true
        }
    }
    
    func scrollToPage(page: Int) {
        let frame = CGRect(x: theScrollView.frame.size.width * CGFloat(page), y: 0, width: theScrollView.frame.size.width, height: theScrollView.frame.size.height)
        theScrollView.scrollRectToVisible(frame, animated: false)
    }
    
    // MARK: - social media handlers
    // ----------------------------------------
    
    @IBAction func pinterestClicked(sender: AnyObject) {
        
        PDKClient.sharedInstance().authenticate(withPermissions: [PDKClientWritePublicPermissions, PDKClientWriteRelationshipsPermissions, PDKClientWritePrivatePermissions, PDKClientReadPrivatePermissions, PDKClientReadPublicPermissions, PDKClientReadRelationshipsPermissions], withSuccess: { (response) -> Void in
            let prayerDate = self.sortedPrayers[self.currentIndex!] as! String
            if let selectedPrayer = Utilities.getPrayerForDate(date: prayerDate) {
                let imageUrl = NSURL(string: selectedPrayer.photoURL)
                PDKPin.pin(withImageURL: imageUrl as URL?, link: NSURL(string: "") as URL?, suggestedBoardName: "", note: selectedPrayer.prayer, withSuccess: { () -> Void in
                    var x = 0
                    x += 1
                }, andFailure: { (error) -> Void in
                    print(error?.localizedDescription as Any)
                })
            }
        }, andFailure: { (error) -> Void in
            print(error?.localizedDescription as Any)
        })
    }
    
    @IBAction func shareit(_ sender: Any) {
        let prayerDate = sortedPrayers[currentIndex!] as! String
        if let selectedPrayer = Utilities.getPrayerForDate(date: prayerDate) {

            let activityController = UIActivityViewController(activityItems: [selectedPrayer.photo as Data, "\(selectedPrayer.location) - \(selectedPrayer.prayer)"],
                                                              applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
        }
    }

    @IBAction func twitterClicked(sender: AnyObject) {
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let prayerDate = sortedPrayers[currentIndex!] as! String
            if let selectedPrayer = Utilities.getPrayerForDate(date: prayerDate) {
                let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                let prayerString = "\(selectedPrayer.location) - \(selectedPrayer.prayer)" as String
                if prayerString.count > 114 {
                    twitterSheet.setInitialText("\((prayerString as NSString).substring(to: 110))...")
                } else {
                    twitterSheet.setInitialText(prayerString)
                }
                
                let image = selectedPrayer.photo
                twitterSheet.add(UIImage(data: image as Data))
                
                self.present(twitterSheet, animated: true, completion: nil)
            }

        } else {
            let alert = UIAlertController(title: "Twitter", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
         
            
        }
    }
    
    @IBAction func tumblrClicked(sender: AnyObject) {
        
        let prayerDate = sortedPrayers[currentIndex!] as! String
        if let selectedPrayer = Utilities.getPrayerForDate(date: prayerDate) {
            let data = selectedPrayer.photo as Data
            guard let image = UIImage(data: data) else { return }

            UIPasteboard.general.images = [image]

            var shareURL = URL(string: "tumblr://x-callback-url/photo?caption=Daily%20Photo%20Prayer")!
            let canOpenURL = UIApplication.shared.canOpenURL(shareURL)

            if !canOpenURL {
                shareURL = URL(string: "http://tumblr.com/share?s=&v=3&t=Daily%20Photo%20Prayer&u=\(selectedPrayer.photoURL)")!
            }
        
            UIApplication.shared.open(shareURL, options: [:], completionHandler: nil)

        }
    }
    
    @IBAction func googleClicked(sender: AnyObject) {
        
//        if let signIn = GPPSignIn.sharedInstance() {
//            signIn.shouldFetchGooglePlusUser = true
//            signIn.clientID = "801561423457-lmampo6rktpa4d6bu32anaftoos1jgqi.apps.googleusercontent.com"
//            signIn.delegate = self
//            signIn.scopes = [kGTLAuthScopePlusLogin]
//            signIn.authenticate()
//        }
    }
    
    @IBAction func facebookClicked(sender: AnyObject) {
        
        let prayerDate = sortedPrayers[currentIndex!] as! String
        if let selectedPrayer = Utilities.getPrayerForDate(date: prayerDate) {
            
            if UIApplication.shared.canOpenURL(URL(string: "fb://")!) || SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                let photo = FBSDKSharePhoto(image: UIImage(data: selectedPrayer.photo as Data), userGenerated: true)
                let content = FBSDKSharePhotoContent()
                content.photos = [photo!]
                FBSDKShareDialog.show(from: self, with: content, delegate: self)

            } else {
                let theContent = FBSDKShareLinkContent()
                theContent.imageURL = URL(string: selectedPrayer.photoURL)
                theContent.contentTitle = "Daily Photo Prayer"
                theContent.contentDescription = "\(selectedPrayer.location) - \(selectedPrayer.prayer)"
                FBSDKShareDialog.show(from: self, with: theContent, delegate: self)
            }
        }
    }
}

extension PrayerContainerViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageWidth = scrollView.frame.size.width;
        currentIndex = Int(floor((self.theScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1);
    }
}

extension PrayerContainerViewController: FBSDKSharingDelegate {
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
    }

    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        print(error as Any)
        let alert = UIAlertController(title: "Uh oh!", message: "Something went wrong when sharing to Facebook.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        
    }

}

//extension PrayerContainerViewController: GPPSignInDelegate {
//    func finished(withAuth auth: GTMOAuth2Authentication!, error: Error!) {
//        let prayerDate = sortedPrayers[currentIndex!] as! String
//        if let selectedPrayer = Utilities.getPrayerForDate(date: prayerDate) {
////            if let shareBuilder = GPPShare.sharedInstance().nativeShareDialog() {
////                shareBuilder.attachImageData(selectedPrayer.photo as Data)
////                shareBuilder.setPrefillText("\(selectedPrayer.location) - \(selectedPrayer.prayer)")
////                shareBuilder.open()
////            }
//        }
//    }
//
//    func didDisconnectWithError(_ error: Error!) {
//        debugPrint("TEST2")
//    }
//
//}
