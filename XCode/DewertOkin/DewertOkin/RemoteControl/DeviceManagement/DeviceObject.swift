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


var globalDeviceObject = DeviceObject()


class DeviceObject {
    
    var uuid: String = ""
    var name: String = ""
    var handheldID: String = "" // Art-Nr. of handheld in csv file
    var handheldData: [String] = [String]() // get these data via handsender1.csv file. represents one row matching the handheld
    
    // these parameters are important for the remote screen and the correct visual representation of the remote
    var type: String = "NaN" // --> type with enum and string matching
    var style: String = "empty" // --> get style via extra class and matching with 'type' and 'style'. style = filled or empty
    
    // These parameters values are loaded during init with the help of style and type parameters
    var deviceImages: [UIImage] = [UIImage]() // images loaded by other class
    
    // These parameters values are loaded during init() with the csv file
    var availableMotors: [Motors] = [Motors]()
    var availableMemories: [Memories] = [Memories]()
    var availableExtraFunctions: [ExtraFunctions] = [ExtraFunctions]()
    
    // These parameters are important for the BLE-Service
    var commandService: CBUUID = CBUUID()
    var keycodeUUID: CBUUID = CBUUID()
    var feedbackUUID: CBUUID = CBUUID()
    
    // These parameters save the device specific features
    var presets: String = String()
    var Timers: [String] = [String]()   //placeholder for device specific Timers-array
    var Reminders: [String] = [String]()    //placeholder for device specific Remidners-array
    
    init() {
        deviceImages = DeviceStyleManager().getImages(inStyle: DeviceStyle(rawValue: style)!,
                                                      forDevice: DeviceType(rawValue: type)!)
    }
    
    init(withUUID id: String, named: String, withHandheldID: String, withStyle: String) {
        uuid = id
        name = named
        handheldID = withHandheldID
        style = withStyle
        
        let csvData = CSVReader().readCSV(fileName: "handsender1_extended", fileType: "csv")
        
        for row in csvData {
            if row[0] == handheldID {
                handheldData = row
                break
            }
        }
        
        chooseDeviceType()
        
        if !(handheldData == []) {
            initializeFunctionality()
            
            deviceImages = DeviceStyleManager().getImages(inStyle: DeviceStyle(rawValue: style)!,
                                                          forDevice: DeviceType(rawValue: type)!)
        }
        else {
            print("ERROR - couldn't find handheld data")
        }
        
    }
    
    
    private func initializeFunctionality() {
        for (i, value) in handheldData.enumerated() {
            if i == 4 && value == "ja" { // only check for M1 up to save performance.
                availableMotors.append(.M1)
            }
            else if i == 6 && value == "ja" {
                availableMotors.append(.M2)
            }
            else if i == 8 && value == "ja" {
                availableMotors.append(.M3)
            }
            else if i == 10 && value == "ja" {
                availableMotors.append(.M4)
            }
            else if i == 12 && value == "ja" {
                availableMotors.append(.M5)
            }
            else if i == 16 && value == "ja" {
                availableMemories.append(.Mem1)
            }
            else if i == 17 && value == "ja" {
                availableMemories.append(.Mem2)
            }
            else if i == 18 && value == "ja" {
                availableMemories.append(.Mem3)
            }
            else if i == 19 && value == "ja" {
                availableMemories.append(.Mem4)
            }
            else if i == 20 && value == "ja" {
                availableMemories.append(.MemSave)
            }
            else if i == 22 && value == "ja" {
                availableExtraFunctions.append(.ubl)
            }
            else if i == 25 && value == "ja" {
                availableExtraFunctions.append(.massage_neck)
            }
            else if i == 26 && value == "ja" {
                availableExtraFunctions.append(.massage_back)
            }
            else if i == 27 && value == "ja" {
                availableExtraFunctions.append(.massage_legs)
            }
        }
    }
    
    private func chooseDeviceType() {
        if handheldData[2] == "bedding" && availableMotors.count == 2 {
            type = DeviceType.bed_2Motors.rawValue
        }
        else if handheldData[2] == "seating" && availableMotors.count == 2 {
            type = DeviceType.chair_2Motors.rawValue
        }
        else if handheldData[2] == "office" && availableMotors.count == 1 {
            type = DeviceType.table.rawValue
        }
        else {
            type = DeviceType.NaN.rawValue
        }
    }
    
}




//===============================================================================//
//=================               ENUMS                  ========================//
//===============================================================================//



enum DeviceType: String { // implemented graphics is marked with <--
    case NaN = "NaN"
    case chair_1Motors = "chair_1Motors"
    case chair_2Motors = "chair_2Motors" // <--
    case chair_3Motors = "chair_3Motors"
    case chair_4Motors = "chair_4Motors"
    case chair_5Motors = "chair_5Motors"
    case bed_1Motors = "bed_1Motors"
    case bed_2Motors = "bed_2Motors" // <--
    case bed_3Motors = "bed_3Motors"
    case bed_4Motors = "bed_4Motors"
    case bed_5Motors = "bed_5Motors"
    case table = "table" // <--
}

enum DeviceStyle: String {
    case empty = "empty"
    case filled = "filled"
}

enum ExtraFunctions: String {
    case massage_back = "massage_back"
    case massage_neck = "massage_neck"
    case massage_legs = "massage_legs"
    case ubl = "ubl"
    case NaN = "NaN"
}

enum Motors: String {
    case M1 = "M1"
    case M2 = "M2"
    case M3 = "M3"
    case M4 = "M4"
    case M5 = "M5"
}

enum Memories: String {
    case Mem1 = "Mem1"
    case Mem2 = "Mem2"
    case Mem3 = "Mem3"
    case Mem4 = "Mem4"
    case MemSave = "MemSave"
}

// ================================================================
// ========                  NOTES                       ==========
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
