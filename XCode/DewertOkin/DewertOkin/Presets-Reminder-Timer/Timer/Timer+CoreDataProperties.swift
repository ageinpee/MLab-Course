//
//  Timer+CoreDataProperties.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 19.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//
//

import Foundation
import CoreData


extension DeviceTimer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DeviceTimer> {
        return NSFetchRequest<DeviceTimer>(entityName: "Timer")
    }

    @NSManaged public var timerName: String?
    @NSManaged public var timerTime: Date

}
