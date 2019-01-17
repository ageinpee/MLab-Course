//
//  Device.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 31.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit.UIImage
import CoreBluetooth

class DeviceObject {
    
    var id: Int = Int()
    var name: String = String()
    var description: String = String()
    var type: DeviceType = .NaN
    var style: DeviceStyle = DeviceStyle()
    var commandService: CBUUID = CBUUID()
    var keycodeUUID: CBUUID = CBUUID()
    var feedbackUUID: CBUUID = CBUUID()
    var Timers: [String] = [String]()   //placeholder for device specific Timers-array
    var Reminders: [String] = [String]()    //placeholder for device specific Remidners-array
    
    init() {
    
    }
    
    init(withID: Int, named: String, withDescription: String, asType: DeviceType, withStyle: DeviceStyle) {
        id = withID
        name = named
        description = withDescription
        type = asType
        style = withStyle
    }
    
    init(withID: Int, named: String, withDescription: String, asType: DeviceType, withStyle: DeviceStyle, withCMDService: CBUUID, withKeycodeUUID: CBUUID, withFeedbackUUID: CBUUID) {
        id = withID
        name = named
        description = withDescription
        type = asType
        style = withStyle
        commandService = withCMDService
        keycodeUUID = withKeycodeUUID
        feedbackUUID = withFeedbackUUID
    }
    
}


enum DeviceType {
    case NaN
    case chair_2Motors
    case bed_2Motors
    case table
}
