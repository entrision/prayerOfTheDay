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
        
        let prayer = NSEntityDescription.insertNewObjectForEntityForName("PhotoPrayer", inManagedObjectContext: context) as! NSManagedObject
        prayer.setValue(values.objectForKey("id"), forKey: "serverID")
        prayer.setValue(values.objectForKey("prayer"), forKey: "prayer")
        prayer.setValue(values.objectForKey("location"), forKey: "location")
        
        // no idea why the URL is nested in the .... URL... WHY?!!
        if let firstURL = values.objectForKey("url") as? NSDictionary {
            let webURL = NSURL(string: firstURL.objectForKey("url") as! String)
            let data = NSData(contentsOfURL: webURL!)
            prayer.setValue(data, forKey: "photo")
        }
        
        prayer.setValue(values.objectForKey("for_date"), forKey: "date")
        
        var error: NSError?
        if (!context.save(&error)) {
            println("ERROR saving Coupon \(error), \(error?.userInfo)")
        }
    }
    
    class func checkForPrayerOnDate(date: String) -> Bool {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "PhotoPrayer")
        let searchQuery = NSPredicate(format: "date == %@", date)
        
        fetchRequest.predicate = searchQuery
        
        var error: NSError?
        
        let fetchResults = context.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]?
        
        if (fetchResults?.count > 0) {
            return true
        }

        return false
    }
    
    class func getPrayerForDate(date: String) -> PhotoPrayer? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "PhotoPrayer")
        let searchQuery = NSPredicate(format: "date == %@", date)
        
        fetchRequest.predicate = searchQuery
        
        var error: NSError?
        
        let fetchResults = context.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]?
        
        if (fetchResults?.count > 0) {
            let prayer = fetchResults?[0] as! PhotoPrayer
            return prayer
        } else {
            return nil
        }

    }
}