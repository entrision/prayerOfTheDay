//
//  Utilities.swift
//  PrayerOfTheDay
//
//  Created by Travis Wade on 4/2/15.
//  Copyright (c) 2015 OperationBlessing. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Utilities {
    class func createPhotoPrayerFromDictionary(values: NSDictionary) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        
        let prayer = NSEntityDescription.insertNewObjectForEntityForName("PhotoPrayer", inManagedObjectContext: context)
        prayer.setValue(values.objectForKey("id"), forKey: "serverID")
        prayer.setValue(values.objectForKey("prayer"), forKey: "prayer")
        prayer.setValue(values.objectForKey("location"), forKey: "location")
        
        // no idea why the URL is nested in the .... URL... WHY?!!
        if let firstURL = values.objectForKey("url") as? NSDictionary {
            let webURL = NSURL(string: firstURL.objectForKey("url") as! String)
            let data = NSData(contentsOfURL: webURL!)
            prayer.setValue(webURL?.absoluteString, forKey: "photoURL")
            prayer.setValue(data, forKey: "photo")
        }
        
        prayer.setValue(values.objectForKey("for_date"), forKey: "date")
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    class func checkForPrayerOnDate(date: String) -> Bool {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "PhotoPrayer")
        let searchQuery = NSPredicate(format: "date == %@", date)
        
        fetchRequest.predicate = searchQuery
        
        do {
            let fetchResults = try context.executeFetchRequest(fetchRequest)
            
            if (fetchResults.count > 0) {
                return true
            }
        } catch let error as NSError {
            print(error)
        }

        return false
    }
    
    class func getPrayerForDate(date: String) -> PhotoPrayer? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "PhotoPrayer")
        let searchQuery = NSPredicate(format: "date == %@", date)
        
        fetchRequest.predicate = searchQuery
        
        do {
            let fetchResults = try context.executeFetchRequest(fetchRequest)
        
            if (fetchResults.count > 0) {
                let prayer = fetchResults[0] as! PhotoPrayer
                return prayer
            } else {
                return nil
            }
        } catch let error as NSError {
            print(error)
        }
        
        return nil

    }
    
    class func getDayOfTheWeek(date: String)->String {
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
}