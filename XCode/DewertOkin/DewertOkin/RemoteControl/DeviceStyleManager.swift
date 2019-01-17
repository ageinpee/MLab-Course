//
//  deviceStyle.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 29.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit.UIImage

class DeviceStyleManager {
    var stylesString: [String] = [String]()
    var stylesImages: [UIImage] = [UIImage]()
    
    init() {
        
    }
    
    init(withStrings: [String]) {
        setWithStrings(Strings: withStrings)
    }
    
    init(withImages: [UIImage]) {
        stylesImages = withImages
    }
    
    private func setWithStrings(Strings: [String]) {
        stylesString = Strings
        for string in stylesString {
            stylesImages.append(UIImage(named: string)!)
        }
    }
    
    
    func getImages(inStyle style: DeviceStyle, forDevice device: DeviceType) -> [UIImage] {
        switch style {
        case .empty:
            setEmptyStyle(forDevice: device)
        case .filled:
            setFilledStyle(forDevice: device)
        }
        return stylesImages
    }
    
    
    func setStyle(inStyle style: DeviceStyle, forDevice device: DeviceType) {
        switch style {
        case .empty:
            setEmptyStyle(forDevice: device)
        case .filled:
            setFilledStyle(forDevice: device)
        }
    }
    
    
    
    func setFilledStyle(forDevice: DeviceType) {
        switch forDevice {
        case .chair_2Motors:
            let filledStyle = ["chair_normal_arrows",
                               "chair_full_normal",
                               "chair_full_chestUp",
                               "chair_full_chestDown",
                               "chair_full_feetUp",
                               "chair_full_feetDown"]
            setWithStrings(Strings: filledStyle)
        case .bed_2Motors:
            let filledStyle = ["bed_normal_arrows",
                               "bed_full_normal",
                               "bed_full_chestUp",
                               "bed_full_chestDown",
                               "bed_full_feetUp",
                               "bed_full_feetDown"]
            setWithStrings(Strings: filledStyle)
        case .table:
            let filledStyle = ["table_normal_arrows",
                               "table_full_normal",
                               "table_full_up",
                               "table_full_down"]
            setWithStrings(Strings: filledStyle)
        case .NaN:
            print("no deviceType found")
        case .chair_1Motors:
            print("not implemented yet")
        case .chair_3Motors:
            print("not implemented yet")
        case .chair_4Motors:
            print("not implemented yet")
        case .chair_5Motors:
            print("not implemented yet")
        case .bed_1Motors:
            print("not implemented yet")
        case .bed_3Motors:
            print("not implemented yet")
        case .bed_4Motors:
            print("not implemented yet")
        case .bed_5Motors:
            print("not implemented yet")
        }
    }
    
    func setEmptyStyle(forDevice: DeviceType) {
        switch forDevice {
        case .chair_2Motors:
            let filledStyle = ["chair_normal_arrows",
                               "chair_empty_normal",
                               "chair_empty_chestUp",
                               "chair_empty_chestDown",
                               "chair_empty_feetUp",
                               "chair_empty_feetDown"]
            setWithStrings(Strings: filledStyle)
        case .bed_2Motors:
            let filledStyle = ["bed_normal_arrows",
                               "bed_empty_normal",
                               "bed_empty_chestUp",
                               "bed_empty_chestDown",
                               "bed_empty_feetUp",
                               "bed_empty_feetDown"]
            setWithStrings(Strings: filledStyle)
        case .table:
            let filledStyle = ["table_normal_arrows",
                               "table_empty_normal",
                               "table_empty_up",
                               "table_empty_down"]
            setWithStrings(Strings: filledStyle)
        case .NaN:
            print("no deviceType found")
        case .chair_1Motors:
            print("not implemented yet")
        case .chair_3Motors:
            print("not implemented yet")
        case .chair_4Motors:
            print("not implemented yet")
        case .chair_5Motors:
            print("not implemented yet")
        case .bed_1Motors:
            print("not implemented yet")
        case .bed_3Motors:
            print("not implemented yet")
        case .bed_4Motors:
            print("not implemented yet")
        case .bed_5Motors:
            print("not implemented yet")
        }
    }
}
