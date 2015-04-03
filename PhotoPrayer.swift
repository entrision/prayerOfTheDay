//
//  PhotoPrayer.swift
//  PrayerOfTheDay
//
//  Created by Travis Wade on 4/2/15.
//  Copyright (c) 2015 OperationBlessing. All rights reserved.
//

import Foundation
import CoreData

@objc(PhotoPrayer)

class PhotoPrayer: NSManagedObject {

    @NSManaged var date: String
    @NSManaged var location: String
    @NSManaged var photo: NSData
    @NSManaged var prayer: String
    @NSManaged var serverID: NSNumber

}
