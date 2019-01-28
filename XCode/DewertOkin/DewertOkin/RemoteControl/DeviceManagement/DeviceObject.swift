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


var globalDeviceObject = DeviceObject() {
    didSet {
        //Health.shared.updateBulletinImage()
    }
}


class DeviceObject {
    
    var uuid: String = ""                                               // Identifier for the device
    var name: String = ""                                               // Name given by user
    var handheldID: String = ""                                         // Art-Nr. of handheld in csv file
    var handheldData: [String] = [String]()                             // all data of a handheld extracted from handsender.csv file
    
    // these parameters are important for the remote screen and the correct visual representation of the remote
    var type: String = "NaN"                                            // describes the type of a device, eg. chair, table, ...
    var style: String = "filled"                                         // descibes the style of a device shown in the remote screen. currently containing filled or empty
    
    // These parameters values are loaded during init with the help of style and type parameters
    var deviceImages: [UIImage] = [UIImage]()                           // images loaded by other class
    
    // These parameters values are loaded during init() with the csv file
    var availableMotors: [Motors] = [Motors]()                          // list of available motors
    var availableMemories: [Memories] = [Memories]()                    // list of available memory functions + save memory
    var availableExtraFunctions: [ExtraFunctions] = [ExtraFunctions]()  // list of available extra functions
    
    // These parameters are important for the BLE-Service
    var commandService: CBUUID = CBUUID()                               //  \
    var keycodeUUID: CBUUID = CBUUID()                                  //   } used for BLE service
    var feedbackUUID: CBUUID = CBUUID()                                 //  /
    
    // These parameters save the device specific features
    var presets: String = String()                                      // placeholder for device specific presets-array
    var Timers: [String] = [String]()                                   // placeholder for device specific Timers-array
    var Reminders: [String] = [String]()                                // placeholder for device specific Remidners-array
    
    init() {
        uuid = UUID().uuidString
        name = "No Device"
        handheldID = "no-device"
        style = "filled"
        
        let csvData = CSVReader().readCSV(fileName: "handsender1_extended", fileType: "csv")
        
        for row in csvData {
            if row[0] == handheldID {
                handheldData = row
                break
            }
        }
        
        if !(handheldData == []) {
            initializeFunctionality()
            chooseDeviceType()
            deviceImages = DeviceStyleManager().getImages(inStyle: DeviceStyle(rawValue: style)!,
                                                          forDevice: DeviceType(rawValue: type)!)
        }
        else {
            print("ERROR - couldn't find handheld data")
            type = "NaN"
            deviceImages = DeviceStyleManager().getImages(inStyle: DeviceStyle(rawValue: style)!,
                                                          forDevice: DeviceType(rawValue: type)!)
        }
        //deviceImages = DeviceStyleManager().getImages(inStyle: DeviceStyle(rawValue: style)!,
        //                                              forDevice: DeviceType(rawValue: type)!)
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
        
        if !(handheldData == []) {
            initializeFunctionality()
            chooseDeviceType()
            deviceImages = DeviceStyleManager().getImages(inStyle: DeviceStyle(rawValue: style)!,
                                                          forDevice: DeviceType(rawValue: type)!)
        }
        else {
            print("ERROR - couldn't find handheld data")
            type = "NaN"
            deviceImages = DeviceStyleManager().getImages(inStyle: DeviceStyle(rawValue: style) ?? .filled,
                                                          forDevice: DeviceType(rawValue: type) ?? .NaN)
        }
    }
    
    init(withUUID id: String, named: String, withHandheldID: String, withStyle: String, withExtraFunctions: [ExtraFunctions]) {
        uuid = id
        name = named
        handheldID = withHandheldID
        style = withStyle
        availableExtraFunctions = withExtraFunctions
        
        let csvData = CSVReader().readCSV(fileName: "handsender1_extended", fileType: "csv")
        
        for row in csvData {
            if row[0] == handheldID {
                handheldData = row
                break
            }
        }
        
        if !(handheldData == []) {
            initializeFunctionalityWithoutExtraFunctions()
            chooseDeviceType()
            deviceImages = DeviceStyleManager().getImages(inStyle: DeviceStyle(rawValue: style)!,
                                                          forDevice: DeviceType(rawValue: type)!)
        }
        else {
            print("ERROR - couldn't find handheld data")
            type = "NaN"
            deviceImages = DeviceStyleManager().getImages(inStyle: DeviceStyle(rawValue: style)!,
                                                          forDevice: DeviceType(rawValue: type)!)
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
    
    private func initializeFunctionalityWithoutExtraFunctions() {
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
    
    func getMotorKeycode(for motor: Motors, with action: Action) -> Data {
        switch motor {
        case .M1:
            if action == .up { return RemoteControlConfig().getKeycode(name: .m1Out)}
            else if action == .down { return RemoteControlConfig().getKeycode(name: .m1In)}
        case .M2:
            if action == .up { return RemoteControlConfig().getKeycode(name: .m2Out)}
            else if action == .down { return RemoteControlConfig().getKeycode(name: .m2In)}
        case .M3:
            if action == .up { return RemoteControlConfig().getKeycode(name: .m3Out)}
            else if action == .down { return RemoteControlConfig().getKeycode(name: .m3In)}
        case .M4:
            if action == .up { return RemoteControlConfig().getKeycode(name: .m4Out)}
            else if action == .down { return RemoteControlConfig().getKeycode(name: .m4In)}
        case .M5:
            print("not implemented yet, instead M4 is triggered")
            if action == .up { return RemoteControlConfig().getKeycode(name: .m4Out)}
            else if action == .down { return RemoteControlConfig().getKeycode(name: .m4In)}
        }
        return Data()
    }
    
    func getExtraFuntionKeycode(for extraFunc: ExtraFunctions) -> Data {
        switch extraFunc {
        case .massage_back:
            return RemoteControlConfig().getKeycode(name: .massage1)
        case .massage_neck:
            return RemoteControlConfig().getKeycode(name: .massage2)
        case .massage_legs:
            return RemoteControlConfig().getKeycode(name: .massage3)
        case .ubl:
            return RemoteControlConfig().getKeycode(name: .ubl)
        default:
            return Data()
        }
    }
    
    func getMemoryKeycode(for memory: Memories) -> Data{
        switch memory {
        case .Mem1:
            return RemoteControlConfig().getKeycode(name: .memory1)
        case .Mem2:
            return RemoteControlConfig().getKeycode(name: .memory2)
        case .Mem3:
            return RemoteControlConfig().getKeycode(name: .memory3)
        case .Mem4:
            return RemoteControlConfig().getKeycode(name: .memory4)
        case .MemSave:
            return RemoteControlConfig().getKeycode(name: .storeMemoryPosition)
        }
    }
    
    
    static func convertExtraFunctionsToString(functions: [ExtraFunctions]) -> String {
        var output = ""
        for (i,f) in functions.enumerated() {
            if i != functions.count-1 {
                output.append(f.rawValue + ";")
            }
            else {
                output.append(f.rawValue)
            }
        }
        return output
    }
    
    static func convertStringToExtraFunctions(withString: String) -> [ExtraFunctions] {
        var output = [ExtraFunctions]()
        var stringArray = withString.components(separatedBy: ";")
        if stringArray == [""] { stringArray = [] }
        for string in stringArray {
            output.append(ExtraFunctions(rawValue: string) ?? .NaN)
        }
        return output
    }
    
    
}




//===============================================================================//
//=================               ENUMS                  ========================//
//===============================================================================//



enum DeviceType: String { // implemented graphics is marked with <--
    case NaN = "NaN" // <--
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
    
    //Accessory names
    case satellite_speaker = "Satellite Speaker"
    case subwoofer_speaker = "Subwoofer Speaker"
    case massage_motor = "Massage Motor"
    case under_bed_lighting = "Under Bed Lighting"
    case light_strip = "Light Strip"
    case seat_heating = "Seat Heating"
    case hands_free_kit = "Hands Free Kit"
    case rgb_lighting_control_unit = "RGB Lighting Control Unit"
    case rgb_lighting_strip = "RGB Lighting Strip"
    
    
    
    
}

enum Motors: String {
    case M1 = "M1"
    case M2 = "M2"
    case M3 = "M3"
    case M4 = "M4"
    case M5 = "M5"
}

enum Memories: String {
    case Mem1 = "Memory 1"
    case Mem2 = "Memory 2"
    case Mem3 = "Memory 3"
    case Mem4 = "Memory 4"
    case MemSave = "Save Memory"
}

enum Action: String {
    case up = "up"
    case down = "down"
}
