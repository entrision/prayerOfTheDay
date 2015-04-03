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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        todayImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "prayerClicked:"))
        day1Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "prayerClicked:"))
        day2Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "prayerClicked:"))
        day3Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "prayerClicked:"))
        day4Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "prayerClicked:"))
        day5Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "prayerClicked:"))
        day6Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "prayerClicked:"))
        
        var loadingScreen = LoadingView(frame: self.view.frame)
        loadingScreen.setLabel("Loading Photo Prayer...")
        loadingScreen.tag = 70
        self.view.addSubview(loadingScreen)

        loadPrayers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    // -------------------------------------------
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    // MARK: - gesture handler
    // -------------------------------------------
    
    func prayerClicked(gesture: UITapGestureRecognizer) {
        var image:UIView = gesture.view!
        
        // TODO: get the right Prayer
        
        self.performSegueWithIdentifier("SinglePrayerSegue", sender: nil)
    }
    
    // MARK: - prayer loader
    // -------------------------------------------
    
    func loadPrayers() {
        // *** THINK ABOUT -  we need 7 prayers, they may not all be there on the server.
        // /api/v1/photos/?date=2010-01-01
        // get the current date
        var currentDate = NSDate()
        var foundPrayers = 0
        var service = WebService()
        var searchDate = currentDate
        
        for var i = 0; i < 30; i++ { // max 30 searches
            if (i > 0) {
                var interval:NSTimeInterval = Double(-1*i*24*60*60)
                searchDate = currentDate.dateByAddingTimeInterval(interval)
            }
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            var searchString = formatter.stringFromDate(searchDate)
  
            if(!Utilities.checkForPrayerOnDate(searchString)) {
                service.get("photos/?date=\(searchString)",
                    success:{ (response: NSURLResponse!, data: NSData!) -> Void in
                        var couponArray: NSArray!
                        
                        var dataString:NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
                        var error:NSError?
                        
                        if let jsonObj = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &error) as? NSArray {
                            if (jsonObj.count > 0) {
                                if let values = jsonObj.objectAtIndex(0) as? NSDictionary {
                                    Utilities.createPhotoPrayerFromDictionary(values)
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.loadPrayerUIforDayAndDate(foundPrayers, date: searchString)
                                    }
                                    foundPrayers++
                                }
                            }
                        }
                        
                    }, failure: { (error:NSError!) -> Void in
                        println("ERROR: \(error.localizedDescription)")
                })
            } else {
                self.loadPrayerUIforDayAndDate(foundPrayers, date: searchString)
                foundPrayers++
            }
            
            if (foundPrayers == 7 || i == 29) {
                var loadingView = self.view.viewWithTag(70)
                loadingView?.removeFromSuperview()
                break
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
                }
                todayLabel.text = "TODAY'S PHOTO PRAYER | \(date)"
            case 1:
                if let data = selectedPrayer?.photo {
                    day1Image.image = UIImage(data: data)
                }
                day1Label.text = "\(getDayOfTheWeek(date)), \(date)"
            case 2:
                if let data = selectedPrayer?.photo {
                    day2Image.image = UIImage(data: data)
                }
                day2Label.text = "\(getDayOfTheWeek(date)), \(date)"
            case 3:
                if let data = selectedPrayer?.photo {
                    day3Image.image = UIImage(data: data)
                }
                day3Label.text = "\(getDayOfTheWeek(date)), \(date)"
            case 4:
                if let data = selectedPrayer?.photo {
                    day4Image.image = UIImage(data: data)
                }
                day4Label.text = "\(getDayOfTheWeek(date)), \(date)"
            case 5:
                if let data = selectedPrayer?.photo {
                    day5Image.image = UIImage(data: data)
                }
                day5Label.text = "\(getDayOfTheWeek(date)), \(date)"
            default:
                if let data = selectedPrayer?.photo {
                    day6Image.image = UIImage(data: data)
                }
                day6Label.text = "\(getDayOfTheWeek(date)), \(date)"
            }

        }
    }
    
    func getDayOfTheWeek(date: String)->String {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.dateFromString(date)!
        let myCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let day = myCalendar?.component(.WeekdayCalendarUnit, fromDate: todayDate) as Int!
        
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
}
