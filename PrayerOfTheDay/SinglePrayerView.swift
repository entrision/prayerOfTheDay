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
            prayer.textAlignment = .center
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: thePrayer!.date)
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let displayDate = dateFormatter.string(from: date!)
            
            location.text = "\(Utilities.getDayOfTheWeek(date: thePrayer!.date)), \(displayDate) - \(thePrayer!.location)"
            
            if let data = thePrayer?.photo {
                image.image = UIImage(data: data as Data)
                
                if image.image!.size.height > image.image!.size.width {
                    image.contentMode = UIView.ContentMode.scaleAspectFit
                }
            }
        }
    }
    
    @IBAction func donateButtonClicked(sender: UIButton) {
        if let targetURL = URL(string: "https://secure.ob.org/site/Donation2?df_id=8000&8000.donation=form1") {
            UIApplication.shared.openURL(targetURL);
        }
    }
    
    @IBAction func photoButtonClicked(sender: UIButton) {
       // let targetURL = NSURL(string: "http://photos.ob.org")
        if let targetURL = URL(string: "https://www.ob.org/category/photos/") {
            UIApplication.shared.openURL(targetURL);
        }
    }
    
    @IBAction func videoButtonClicked(sender: UIButton) {
        //let targetURL = NSURL(string: "http://videos.ob.org")
        if let targetURL = URL(string: "https://www.ob.org/category/videos/") {
            UIApplication.shared.openURL(targetURL);
        }
    }
}
