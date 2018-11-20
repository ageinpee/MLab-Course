//
//  Reminder+CoreDataProperties.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 19.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import CoreData


extension Reminder {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }
    
    @NSManaged public var reminderName: String?
    @NSManaged public var reminderDescription: String?
    @NSManaged public var reminderTime: Date
    
}
