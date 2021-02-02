//
//  SelectPrayerViewController.swift
//  PrayerOfTheDay
//
//  Created by Travis Wade on 3/26/15.
//  Copyright (c) 2015 OperationBlessing. All rights reserved.
//

import UIKit

enum PODNotificationName: String {
    case NavigatedToWeb = "com.prayeroftheday.navigatedtoweb.notification"

    var navigationName: NSNotification.Name? {
        switch self {
        case .NavigatedToWeb:
            return NSNotification.Name(rawValue: self.rawValue)
        default:
            return nil
        }
    }
}

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
    private var didNavigateToWeb = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpLabels()

        todayImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(prayerClicked(gesture:))))
        day1Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(prayerClicked(gesture:))))
        day2Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(prayerClicked(gesture:))))
        day3Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(prayerClicked(gesture:))))
        day4Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(prayerClicked(gesture:))))
        day5Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(prayerClicked(gesture:))))
        day6Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(prayerClicked(gesture:))))
        
        let loadingScreen = LoadingView(frame: self.view.frame)
        loadingScreen.setLoadingLabel(message: "Loading Photo Prayers ...")
        loadingScreen.tag = 70
        self.view.addSubview(loadingScreen)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        if let navigationName = PODNotificationName.NavigatedToWeb.navigationName {
            NotificationCenter.default.addObserver(self, selector: #selector(didNavigateToWebNotification(notification:)), name: navigationName, object: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (!screenLoaded) {
            loadPrayers()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setUpLabels () {
        todayLabel.layer.shadowRadius = 1.0
        todayLabel.layer.masksToBounds = false
        todayLabel.layer.shadowOffset = CGSize.zero
        todayLabel.layer.shadowColor = UIColor.black.cgColor
        todayLabel.layer.shadowOpacity = 1.0
        
        day1Label.layer.shadowRadius = 1.0
        day1Label.layer.masksToBounds = false
        day1Label.layer.shadowOffset = CGSize.zero
        day1Label.layer.shadowColor = UIColor.black.cgColor
        day1Label.layer.shadowOpacity = 1.0
        
        day2Label.layer.shadowRadius = 1.0
        day2Label.layer.masksToBounds = false
        day2Label.layer.shadowOffset = CGSize.zero
        day2Label.layer.shadowColor = UIColor.black.cgColor
        day2Label.layer.shadowOpacity = 1.0
        
        day3Label.layer.shadowRadius = 1.0
        day3Label.layer.masksToBounds = false
        day3Label.layer.shadowOffset = CGSize.zero
        day3Label.layer.shadowColor = UIColor.black.cgColor
        day3Label.layer.shadowOpacity = 1.0
        
        day4Label.layer.shadowRadius = 1.0
        day4Label.layer.masksToBounds = false
        day4Label.layer.shadowOffset = CGSize.zero
        day4Label.layer.shadowColor = UIColor.black.cgColor
        day4Label.layer.shadowOpacity = 1.0
        
        day5Label.layer.shadowRadius = 1.0
        day5Label.layer.masksToBounds = false
        day5Label.layer.shadowOffset = CGSize.zero
        day5Label.layer.shadowColor = UIColor.black.cgColor
        day5Label.layer.shadowOpacity = 1.0
        
        day6Label.layer.shadowRadius = 1.0
        day6Label.layer.masksToBounds = false
        day6Label.layer.shadowOffset = CGSize.zero
        day6Label.layer.shadowColor = UIColor.black.cgColor
        day6Label.layer.shadowOpacity = 1.0
    }
    
    // MARK: - Navigation
    // -------------------------------------------

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //var singlePrayerVC = segue.destinationViewController as! SinglePrayerViewController
        //singlePrayerVC.prayerDate = sender as! String
        
        let containerVC = segue.destination as! PrayerContainerViewController
        //containerVC.startDate = sender as! String
        containerVC.startIndex = (sender as! Int)
        containerVC.prayers = prayers
        
    }
    
    // MARK: - gesture handler
    // -------------------------------------------
    @objc
    func prayerClicked(gesture: UITapGestureRecognizer) {
        let image:UIView = gesture.view!
        let day = image.tag
        
        if prayers.object(forKey: day) != nil {
            self.performSegue(withIdentifier: "SinglePrayerSegue", sender: day)
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
        
        let path = Bundle.main.path(forResource: "settings", ofType: "plist")
        let settings:NSMutableDictionary = NSMutableDictionary(contentsOfFile: path!) ?? [:]
        let baseAddress = settings.object(forKey: "baseAddress") as! NSString
        
        //for var i = 0; i < 10; i++ { // max 30 searches
        for i in 0..<10 {
            if i > 0 {
                let interval:TimeInterval = Double(-1*i*24*60*60)
                searchDate = currentDate.addingTimeInterval(interval)

            } else {
                print("this is the current date!!!")
                
                let date = NSDate()
                let calendar = NSCalendar.current
                let components = calendar.dateComponents([ .hour, .minute, .second], from: date as Date)
                if let hour = components.hour {
                    print(hour as Any)
                
                    if hour <= 8 {
                        print("in the continue")
                        continue
                    }
                }
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "MM-dd-yyyy"
            let displayString = displayFormatter.string(from: searchDate as Date)
            
            let searchString = formatter.string(from: searchDate as Date)
  
            if Utilities.checkForPrayerOnDate(date: searchString) == false {
                print("!Utilities.checkforprayerondate")
                let path: String = "\(baseAddress)photos/?date=\(searchString)"

                let url: NSURL = NSURL(string: path)!
                let request = NSURLRequest(url: url as URL)
                var response: URLResponse?
                
                do {
                    let data: NSData =  try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response) as NSData
     
                    if let jsonObj = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? NSArray {
                        if (jsonObj.count > 0) {
                            if let values = jsonObj.object(at: 0) as? NSDictionary {
                                Utilities.createPhotoPrayerFromDictionary(values: values)
                                self.loadPrayerUIforDayAndDate(day: self.foundPrayers, date: searchString, displayDate: displayString)
                                
                                self.prayers.setObject(searchString, forKey: foundPrayers as NSCopying)
                                foundPrayers += 1
                                
                                if (checkForFullLoad(iterator: i)) {
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
                if (checkForFullLoad(iterator: i)) {
                    print("top check for full load")
                    break
                }
                let path: String = "\(baseAddress)photos/?date=\(searchString)"
                
                let url: NSURL = NSURL(string: path)!
                let request = NSURLRequest(url: url as URL)
                var response: URLResponse?
                
                do {
                    let data: Data =  try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response) as Data
                    
                    if let jsonObj = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? NSArray {
                        if jsonObj.count > 0 {
                            if let values = jsonObj.object(at: 0) as? NSDictionary {
                                //Utilities.createPhotoPrayerFromDictionary(values)
                                Utilities.editPhotoPrayerFromDictionary(values: values, date: searchString)
                                self.loadPrayerUIforDayAndDate(day: self.foundPrayers, date: searchString, displayDate: displayString)
                                
                                self.prayers.setObject(searchString, forKey: foundPrayers as NSCopying)
                                foundPrayers += 1
                                
                                if (checkForFullLoad(iterator: i)) {
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
        let selectedPrayer = Utilities.getPrayerForDate(date: date)
        
        if selectedPrayer != nil  {

            switch (day) {
            case 0:
                if let data = selectedPrayer?.photo {
                    todayImage.image = UIImage(data: data as Data)
                    checkForVerticalImage(imageView: todayImage)
                }
                todayLabel.text = "TODAY'S PHOTO PRAYER | \(displayDate)"
            case 1:
                if let data = selectedPrayer?.photo {
                    day1Image.image = UIImage(data: data as Data)
                    checkForVerticalImage(imageView: day1Image)
                }
                day1Label.text = "\(Utilities.getDayOfTheWeek(date: date)), \(displayDate)"
            case 2:
                if let data = selectedPrayer?.photo {
                    day2Image.image = UIImage(data: data as Data)
                    checkForVerticalImage(imageView: day2Image)
                }
                day2Label.text = "\(Utilities.getDayOfTheWeek(date: date)), \(displayDate)"
            case 3:
                if let data = selectedPrayer?.photo {
                    day3Image.image = UIImage(data: data as Data)
                    checkForVerticalImage(imageView: day3Image)
                }
                day3Label.text = "\(Utilities.getDayOfTheWeek(date: date)), \(displayDate)"
            case 4:
                if let data = selectedPrayer?.photo {
                    day4Image.image = UIImage(data: data as Data)
                    checkForVerticalImage(imageView: day4Image)
                }
                day4Label.text = "\(Utilities.getDayOfTheWeek(date: date)), \(displayDate)"
            case 5:
                if let data = selectedPrayer?.photo {
                    day5Image.image = UIImage(data: data as Data)
                    checkForVerticalImage(imageView: day5Image)
                }
                day5Label.text = "\(Utilities.getDayOfTheWeek(date: date)), \(displayDate)"
            default:
                if let data = selectedPrayer?.photo {
                    day6Image.image = UIImage(data: data as Data)
                    checkForVerticalImage(imageView: day6Image)
                }
                day6Label.text = "\(Utilities.getDayOfTheWeek(date: date)), \(displayDate)"
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
                imageView.contentMode = UIView.ContentMode.scaleAspectFit
                imageView.backgroundColor = UIColor.black
            } else {
                imageView.contentMode = UIView.ContentMode.scaleAspectFill
                imageView.backgroundColor = UIColor.white
            }
        }
    }
    
    
    //MARK: Notifications
    @objc
    func didNavigateToWebNotification(notification: NSNotification) {
        didNavigateToWeb = true
    }

    @objc func applicationWillEnterForeground(notification: NSNotification) {
        guard didNavigateToWeb == false else {
            didNavigateToWeb = false
            return
        }
        foundPrayers = 0

        let loadingScreen = LoadingView(frame: self.view.frame)
        print("\(String(describing: loadingScreen.view?.frame))")
        loadingScreen.setLoadingLabel(message: "Loading Photo Prayers ...")
        loadingScreen.tag = 70
        self.view.addSubview(loadingScreen)

        DispatchQueue.main.async {
            self.loadPrayers()
        }

        //Commenting until we can find a way to make async request
//        if screenLoaded {
//            self.foundPrayers = 0
//            self.loadPrayers()
//        }
    }
}
