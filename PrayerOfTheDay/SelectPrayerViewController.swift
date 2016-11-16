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

        
        self.setUpLabels()
        
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
    
    func setUpLabels () {
        todayLabel.layer.shadowRadius = 1.0
        todayLabel.layer.masksToBounds = false
        todayLabel.layer.shadowOffset = CGSizeZero
        todayLabel.layer.shadowColor = UIColor.blackColor().CGColor
        todayLabel.layer.shadowOpacity = 1.0
        
        day1Label.layer.shadowRadius = 1.0
        day1Label.layer.masksToBounds = false
        day1Label.layer.shadowOffset = CGSizeZero
        day1Label.layer.shadowColor = UIColor.blackColor().CGColor
        day1Label.layer.shadowOpacity = 1.0
        
        day2Label.layer.shadowRadius = 1.0
        day2Label.layer.masksToBounds = false
        day2Label.layer.shadowOffset = CGSizeZero
        day2Label.layer.shadowColor = UIColor.blackColor().CGColor
        day2Label.layer.shadowOpacity = 1.0
        
        day3Label.layer.shadowRadius = 1.0
        day3Label.layer.masksToBounds = false
        day3Label.layer.shadowOffset = CGSizeZero
        day3Label.layer.shadowColor = UIColor.blackColor().CGColor
        day3Label.layer.shadowOpacity = 1.0
        
        day4Label.layer.shadowRadius = 1.0
        day4Label.layer.masksToBounds = false
        day4Label.layer.shadowOffset = CGSizeZero
        day4Label.layer.shadowColor = UIColor.blackColor().CGColor
        day4Label.layer.shadowOpacity = 1.0
        
        day5Label.layer.shadowRadius = 1.0
        day5Label.layer.masksToBounds = false
        day5Label.layer.shadowOffset = CGSizeZero
        day5Label.layer.shadowColor = UIColor.blackColor().CGColor
        day5Label.layer.shadowOpacity = 1.0
        
        day6Label.layer.shadowRadius = 1.0
        day6Label.layer.masksToBounds = false
        day6Label.layer.shadowOffset = CGSizeZero
        day6Label.layer.shadowColor = UIColor.blackColor().CGColor
        day6Label.layer.shadowOpacity = 1.0
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
        print("start of load prayers")
        // *** THINK ABOUT -  we need 7 prayers, they may not all be there on the server.
        // /api/v1/photos/?date=2010-01-01

        let currentDate = NSDate()
        var searchDate = currentDate
        
        let path = NSBundle.mainBundle().pathForResource("settings", ofType: "plist")
        let settings:NSMutableDictionary = NSMutableDictionary(contentsOfFile: path!) as NSMutableDictionary!
        let baseAddress = settings.objectForKey("baseAddress") as! NSString
        
        for var i = 0; i < 10; i++ { // max 30 searches
            if (i > 0) {
                let interval:NSTimeInterval = Double(-1*i*24*60*60)
                searchDate = currentDate.dateByAddingTimeInterval(interval)
            }
            else {
                print("this is the current date!!!")
                
                let date = NSDate()
                let calendar = NSCalendar.currentCalendar()
                let components = calendar.components([ .Hour, .Minute, .Second], fromDate: date)
                let hour = components.hour
                print(hour)
                
                if(hour <= 8){
                    print("in the continue")
                    continue
                }
            }
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            let displayFormatter = NSDateFormatter()
            displayFormatter.dateFormat = "MM-dd-yyyy"
            let displayString = displayFormatter.stringFromDate(searchDate)
            
            let searchString = formatter.stringFromDate(searchDate)
  
            if(!Utilities.checkForPrayerOnDate(searchString)) {
                print("!Utilities.checkforprayerondate")
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
                                self.loadPrayerUIforDayAndDate(self.foundPrayers, date: searchString, displayDate: displayString)
                                
                                self.prayers.setObject(searchString, forKey: foundPrayers)
                                foundPrayers++
                                
                                if (checkForFullLoad(i)) {
                                    print("check for full load break")
                                    break
                                }
                            }
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
                
            } else {
                print("in the else for the prayer")
              /*  self.loadPrayerUIforDayAndDate(foundPrayers, date: searchString)
                prayers.setObject(searchString, forKey: foundPrayers)
                foundPrayers++
                */
                if (checkForFullLoad(i)) {
                    print("top check for full load")
                    break
                }
                let path: String = "\(baseAddress)photos/?date=\(searchString)"
                
                let url: NSURL = NSURL(string: path)!
                let request = NSURLRequest(URL: url)
                var response: NSURLResponse?
                
                do {
                    let data: NSData =  try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
                    
                    if let jsonObj = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as? NSArray {
                        if (jsonObj.count > 0) {
                            if let values = jsonObj.objectAtIndex(0) as? NSDictionary {
                                //Utilities.createPhotoPrayerFromDictionary(values)
                                Utilities.editPhotoPrayerFromDictionary(values, date: searchString)
                                self.loadPrayerUIforDayAndDate(self.foundPrayers, date: searchString, displayDate: displayString)
                                
                                self.prayers.setObject(searchString, forKey: foundPrayers)
                                foundPrayers++
                                
                                if (checkForFullLoad(i)) {
                                    print("check for full load break")
                                    break
                                }
                            }
                        }
                    }
                } catch let error as NSError {
                    print(error)
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
    
    func loadPrayerUIforDayAndDate(day: Int, date: String, displayDate: String) {
        let selectedPrayer = Utilities.getPrayerForDate(date)
        
        if selectedPrayer != nil  {

            switch (day) {
            case 0:
                if let data = selectedPrayer?.photo {
                    todayImage.image = UIImage(data: data)
                    checkForVerticalImage(todayImage)
                }
                todayLabel.text = "TODAY'S PHOTO PRAYER | \(displayDate)"
            case 1:
                if let data = selectedPrayer?.photo {
                    day1Image.image = UIImage(data: data)
                    checkForVerticalImage(day1Image)
                }
                day1Label.text = "\(Utilities.getDayOfTheWeek(date)), \(displayDate)"
            case 2:
                if let data = selectedPrayer?.photo {
                    day2Image.image = UIImage(data: data)
                    checkForVerticalImage(day2Image)
                }
                day2Label.text = "\(Utilities.getDayOfTheWeek(date)), \(displayDate)"
            case 3:
                if let data = selectedPrayer?.photo {
                    day3Image.image = UIImage(data: data)
                    checkForVerticalImage(day3Image)
                }
                day3Label.text = "\(Utilities.getDayOfTheWeek(date)), \(displayDate)"
            case 4:
                if let data = selectedPrayer?.photo {
                    day4Image.image = UIImage(data: data)
                    checkForVerticalImage(day4Image)
                }
                day4Label.text = "\(Utilities.getDayOfTheWeek(date)), \(displayDate)"
            case 5:
                if let data = selectedPrayer?.photo {
                    day5Image.image = UIImage(data: data)
                    checkForVerticalImage(day5Image)
                }
                day5Label.text = "\(Utilities.getDayOfTheWeek(date)), \(displayDate)"
            default:
                if let data = selectedPrayer?.photo {
                    day6Image.image = UIImage(data: data)
                    checkForVerticalImage(day6Image)
                }
                day6Label.text = "\(Utilities.getDayOfTheWeek(date)), \(displayDate)"
            }
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
        print("remove loading view")
        let loadingView = self.view.viewWithTag(70)
        loadingView?.removeFromSuperview()
        screenLoaded = true
    }
    
    func checkForVerticalImage(imageView: UIImageView) {
        if let image = imageView.image {
            if image.size.height > imageView.image!.size.width {
                imageView.contentMode = UIViewContentMode.ScaleAspectFit
                imageView.backgroundColor = UIColor.blackColor()
            } else {
                imageView.contentMode = UIViewContentMode.ScaleAspectFill
                imageView.backgroundColor = UIColor.whiteColor()
            }
        }
    }
    
    
    //MARK: Notifications
    
    func applicationWillEnterForeground(notification: NSNotification) {
        foundPrayers = 0
        
        let loadingScreen = LoadingView(frame: self.view.frame)
        print("\(loadingScreen.view?.frame)")
        loadingScreen.setLoadingLabel("Loading Photo Prayers ...")
        loadingScreen.tag = 70
        self.view.addSubview(loadingScreen)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.loadPrayers()
        })
        

        //Commenting until we can find a way to make async request
//        if screenLoaded {
//            self.foundPrayers = 0
//            self.loadPrayers()
//        }
    }
}
