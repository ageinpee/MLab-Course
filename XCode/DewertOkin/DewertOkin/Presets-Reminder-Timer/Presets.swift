//
//  Presets.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 08.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import CoreData

class Presets {
    var name : String = ""
    var preset_description : String = ""
    var ded_device : String = ""
    var mem_flag : Bool = false
    // memory presets --> these presets are saved on the devices memory
    var mem_no : Int = 0
    // app presets --> these presets are saved on the device.
    var device_servo_1 : Int = 0
    var device_servo_2 : Int = 0
    var device_servo_3 : Int = 0
    var device_servo_4 : Int = 0
    var device_servo_5 : Int = 0
    var device_servo_6 : Int = 0
    var device_light_1 : Bool = false
    var device_light_2 : Bool = false
    var device_massage_1 : Bool = false
    var device_massage_2 : Bool = false
    
    func `init`() {
        
    }
}
