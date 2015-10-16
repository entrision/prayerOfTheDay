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
    @IBOutlet var todayLabel: UILabel!
    @IBOutlet var day1Label: UILabel!
    @IBOutlet var day2Label: UILabel!
    @IBOutlet var day3Label: UILabel!
    @IBOutlet var day4Label: UILabel!
    @IBOutlet var day5Label: UILabel!
    @IBOutlet var day6Label: UILabel!
    
    var prayers = NSMutableDictionary()
    var foundPrayers = 0
    var screenLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        todayImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "prayerClicked:"))
        day1Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "prayerClicked:"))
        day2Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "prayerClicked:"))
        day3Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "prayerClicked:"))
        day4Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "prayerClicked:"))
        day5Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "prayerClicked:"))
        day6Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "prayerClicked:"))
        
        let loadingScreen = LoadingView(frame: self.view.frame)
        loadingScreen.setLoadingLabel("Loading Photo Prayers ...")
        loadingScreen.tag = 70
        self.view.addSubview(loadingScreen)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationWillEnterForeground:"), name: UIApplicationWillEnterForegroundNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if (!screenLoaded) {
            loadPrayers()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Navigation
    // -------------------------------------------
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //var singlePrayerVC = segue.destinationViewController as! SinglePrayerViewController
        //singlePrayerVC.prayerDate = sender as! String
        
        let containerVC = segue.destinationViewController as! PrayerContainerViewController
        //containerVC.startDate = sender as! String
        containerVC.startIndex = (sender as! Int)
        containerVC.prayers = prayers
        
    }
    
    // MARK: - gesture handler
    // -------------------------------------------
    
    func prayerClicked(gesture: UITapGestureRecognizer) {
        let image:UIView = gesture.view!
        let day = image.tag
        
        if prayers.objectForKey(day) != nil {
            self.performSegueWithIdentifier("SinglePrayerSegue", sender: day)
        }

        /*
        if let searchDate = prayers.objectForKey(day) as? String {
            self.performSegueWithIdentifier("SinglePrayerSegue", sender: searchDate)
        }
*/
    }
    
    // MARK: - prayer loader
    // -------------------------------------------
    
    func loadPrayers() {
        // *** THINK ABOUT -  we need 7 prayers, they may not all be there on the server.
        // /api/v1/photos/?date=2010-01-01

        let currentDate = NSDate()
        var searchDate = currentDate
        
        let path = NSBundle.mainBundle().pathForResource("settings", ofType: "plist")
        let settings:NSMutableDictionary = NSMutableDictionary(contentsOfFile: path!) as NSMutableDictionary!
        let baseAddress = settings.objectForKey("baseAddress") as! NSString
        
        for var i = 0; i < 30; i++ { // max 30 searches
            if (i > 0) {
                let interval:NSTimeInterval = Double(-1*i*24*60*60)
                searchDate = currentDate.dateByAddingTimeInterval(interval)
            }
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            let searchString = formatter.stringFromDate(searchDate)
  
            if(!Utilities.checkForPrayerOnDate(searchString)) {
                let path: String = "\(baseAddress)photos/?date=\(searchString)"

                let url: NSURL = NSURL(string: path)!
                let request = NSURLRequest(URL: url)
                var response: NSURLResponse?
                
                do {
                    let data: NSData =  try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
     
                    if let jsonObj = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as? NSArray {
                        if (jsonObj.count > 0) {
                            if let values = jsonObj.objectAtIndex(0) as? NSDictionary {
                                Utilities.createPhotoPrayerFromDictionary(values)
                                self.loadPrayerUIforDayAndDate(self.foundPrayers, date: searchString)
                                
                                self.prayers.setObject(searchString, forKey: foundPrayers)
                                foundPrayers++
                                
                                if (checkForFullLoad(i)) {
                                    break
                                }
                            }
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
                
            } else {
                self.loadPrayerUIforDayAndDate(foundPrayers, date: searchString)
                prayers.setObject(searchString, forKey: foundPrayers)
                foundPrayers++
                
                if (checkForFullLoad(i)) {
                    break
                }
            }
        }
        if foundPrayers > 0 {
            removeLoadingView()
        } else {
            if let loadingView = self.view.viewWithTag(70) as? LoadingView {
                if let theView = loadingView.view {
                    theView.spinnerView.stopAnimating()
                    theView.label.text = "No Prayers"
                }
            }
        }
    }
    
    func loadPrayerUIforDayAndDate(day: Int, date: String) {
        let selectedPrayer = Utilities.getPrayerForDate(date)
        
        if selectedPrayer != nil  {

            switch (day) {
            case 0:
                if let data = selectedPrayer?.photo {
                    todayImage.image = UIImage(data: data)
                    checkForVerticalImage(todayImage)
                }
                todayLabel.text = "TODAY'S PHOTO PRAYER | \(date)"
            case 1:
                if let data = selectedPrayer?.photo {
                    day1Image.image = UIImage(data: data)
                    checkForVerticalImage(day1Image)
                }
                day1Label.text = "\(getDayOfTheWeek(date)), \(date)"
            case 2:
                if let data = selectedPrayer?.photo {
                    day2Image.image = UIImage(data: data)
                    checkForVerticalImage(day2Image)
                }
                day2Label.text = "\(getDayOfTheWeek(date)), \(date)"
            case 3:
                if let data = selectedPrayer?.photo {
                    day3Image.image = UIImage(data: data)
                    checkForVerticalImage(day3Image)
                }
                day3Label.text = "\(getDayOfTheWeek(date)), \(date)"
            case 4:
                if let data = selectedPrayer?.photo {
                    day4Image.image = UIImage(data: data)
                    checkForVerticalImage(day4Image)
                }
                day4Label.text = "\(getDayOfTheWeek(date)), \(date)"
            case 5:
                if let data = selectedPrayer?.photo {
                    day5Image.image = UIImage(data: data)
                    checkForVerticalImage(day5Image)
                }
                day5Label.text = "\(getDayOfTheWeek(date)), \(date)"
            default:
                if let data = selectedPrayer?.photo {
                    day6Image.image = UIImage(data: data)
                    checkForVerticalImage(day6Image)
                }
                day6Label.text = "\(getDayOfTheWeek(date)), \(date)"
            }
        }
    }
    
    func getDayOfTheWeek(date: String)->String {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.dateFromString(date)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let day = myCalendar?.component(NSCalendarUnit.Weekday, fromDate: todayDate) as Int!
        
        switch(day) {
        case 1:
            return "SUNDAY"
        case 2:
            return "MONDAY"
        case 3:
            return "TUESDAY"
        case 4:
            return "WEDNESDAY"
        case 5:
            return "THURSDAY"
        case 6:
            return "FRIDAY"
        default:
            return "SATURDAY"
        }
    }
    
    func checkForFullLoad(iterator:Int)->Bool {
        if (foundPrayers == 7 || iterator == 29) {
            removeLoadingView()
            return true
        }
        
        return false
    }
    
    func removeLoadingView() {
        let loadingView = self.view.viewWithTag(70)
        loadingView?.removeFromSuperview()
        screenLoaded = true
    }
    
    func checkForVerticalImage(imageView: UIImageView) {
        
        if imageView.image!.size.height > imageView.image!.size.width {
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            imageView.backgroundColor = UIColor.blackColor()
        } else {
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    //MARK: Notifications
    
    func applicationWillEnterForeground(notification: NSNotification) {
        //Commenting until we can find a way to make async request
//        if screenLoaded {
//            self.foundPrayers = 0
//            self.loadPrayers()
//        }
    }
}
