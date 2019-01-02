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
        return NSFetchRequest<DeviceTimer>(entityName: "DeviceTimer")
    }

    @NSManaged public var timerName: String?
    @NSManaged public var timerTime: Date?
    @NSManaged public var isEnabled: Bool
    @NSManaged public var repeatInterval: String?

}
