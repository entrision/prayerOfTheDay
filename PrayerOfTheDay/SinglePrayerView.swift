//
//  SinglePrayerView.swift
//  PrayerOfTheDay
//
//  Created by Hunter Whittle on 7/22/15.
//  Copyright (c) 2015 OperationBlessing. All rights reserved.
//

import UIKit

class SinglePrayerView: UIView {
    
    @IBOutlet var image:UIImageView!
    @IBOutlet var location:UILabel!
    @IBOutlet var prayer:UITextView!
    @IBOutlet var photoButton:UIButton!
    @IBOutlet var videoButton:UIButton!
    @IBOutlet var donateButton:UIButton!
    @IBOutlet var scroll:UIScrollView!
    
    var thePrayer: PhotoPrayer? {
        
        didSet {
            
            prayer.text = thePrayer?.prayer
            prayer.textAlignment = .Center
            location.text = thePrayer?.location
            
            if let data = thePrayer?.photo {
                image.image = UIImage(data: data)
                
                if image.image!.size.height > image.image!.size.width {
                    image.contentMode = UIViewContentMode.ScaleAspectFit
                }
            }
        }
    }
    
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
}
