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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        
        let prayer = NSEntityDescription.insertNewObject(forEntityName: "PhotoPrayer", into: context)
        prayer.setValue(values.object(forKey: "id"), forKey: "serverID")
        prayer.setValue(values.object(forKey: "prayer"), forKey: "prayer")
        prayer.setValue(values.object(forKey: "location"), forKey: "location")
        
        // no idea why the URL is nested in the .... URL... WHY?!!
        if let firstURL = values.object(forKey: "url") as? NSDictionary,
           let webURL = NSURL(string: firstURL.object(forKey: "url") as! String),
           let data = try? Data(contentsOf: webURL as URL) {
            prayer.setValue(webURL.absoluteString, forKey: "photoURL")
            prayer.setValue(data, forKey: "photo")
        }
        
        prayer.setValue(values.object(forKey: "for_date"), forKey: "date")
        
        do {
            try context.save()

        } catch let error as NSError {
            print(error)
        }
    }
    
    class func editPhotoPrayerFromDictionary(values: NSDictionary, date: String) {
 
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PhotoPrayer")
        let searchQuery = NSPredicate(format: "date == %@", date)
        
        fetchRequest.predicate = searchQuery
        
        do {
            let fetchResults = try context.fetch(fetchRequest)
            
            if (fetchResults.count > 0) {
               // let prayer = fetchResults[0] as! PhotoPrayer
                let managedObject = fetchResults[0]

                (managedObject as AnyObject).setValue(values.object(forKey: "id"), forKey: "serverID")
                (managedObject as AnyObject).setValue(values.object(forKey: "prayer"), forKey: "prayer")
                (managedObject as AnyObject).setValue(values.object(forKey: "location"), forKey: "location")
                
                // no idea why the URL is nested in the .... URL... WHY?!!
                if let firstURL = values.object(forKey: "url") as? NSDictionary,
                    let webURL = NSURL(string: firstURL.object(forKey: "url") as! String),
                    let data = try? Data(contentsOf: webURL as URL) {
                    (managedObject as AnyObject).setValue(webURL.absoluteString, forKey: "photoURL")
                    (managedObject as AnyObject).setValue(data, forKey: "photo")
                }
                
                (managedObject as AnyObject).setValue(values.object(forKey: "for_date"), forKey: "date")
                
                do {
                    try context.save()
                } catch let error as NSError {
                    print(error)
                }
                
                
                // return prayer
            } else {
                //return nil
            }
        } catch let error as NSError {
            print(error)
        }
    }
 
    class func checkForPrayerOnDate(date: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PhotoPrayer")
        let searchQuery = NSPredicate(format: "date == %@", date)
        
        fetchRequest.predicate = searchQuery
        
        do {
            let fetchResults = try context.fetch(fetchRequest)
            
            if (fetchResults.count > 0) {
                return true
            }
        } catch let error as NSError {
            print(error)
        }

        return false
    }
    
    class func getPrayerForDate(date: String) -> PhotoPrayer? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PhotoPrayer")
        let searchQuery = NSPredicate(format: "date == %@", date)
        
        fetchRequest.predicate = searchQuery
        
        do {
            let fetchResults = try context.fetch(fetchRequest)
        
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
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.date(from: date)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let day = myCalendar?.component(NSCalendar.Unit.weekday, from: todayDate) as Int?
        
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
