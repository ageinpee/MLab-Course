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
    
    var uuid: String = String()
    var name: String = String()
    var handheld: String = String()
    var handheldData: [String] = [String]() // get these data via handsender1.csv file. represents one row matching the handheld
    var type: String = String() // --> type with enum and string matching
    var style: String = String() // --> get style via extra class and matching with 'type' and 'style'. style = filled or empty
    var deviceImages: [UIImage] = [UIImage]() // images loaded by other class
    var presets: String = String()
    
    
    var commandService: CBUUID = CBUUID()
    var keycodeUUID: CBUUID = CBUUID()
    var feedbackUUID: CBUUID = CBUUID()
    
    var Timers: [String] = [String]()   //placeholder for device specific Timers-array
    var Reminders: [String] = [String]()    //placeholder for device specific Remidners-array
    
    init() {
        
    }
    
    init(withUUID id: UUID,
         named: String,
         withHandheld: String,
         withStyle: DeviceStyle) {
        uuid = id.uuidString
        name = named
        handheld = withHandheld
        style = withStyle.rawValue
        
        //CSVReader.readCSV(fileName: "handsender1.csv", fileType: "csv")
        
    }
    
}


enum DeviceType: String {
    case NaN = "NaN"
    case chair_2Motors = "chair_2Motors"
    case bed_2Motors = "bed_2Motors"
    case table = "table"
}

enum DeviceStyle: String {
    case empty = "empty"
    case filled = "filled"
}


// ================================================================
// ========                 NOTES                        ==========
// ================================================================

//                         CORE DATA
// ================================================================

// 1) fetch: --> get all devices as array
// 2) work with as usuall
// 3) on edit --> save context
// 4) bleuprint: devices class


//                           OTHER
// =================================================================

// - "skip RF Pairing" Button has to be deleted
// - 
