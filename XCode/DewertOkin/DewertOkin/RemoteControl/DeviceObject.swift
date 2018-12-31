//
//  Device.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 31.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit.UIImage

class DeviceObject {
    
    var id: Int = Int()
    var name: String = String()
    var type: DeviceType = .NaN
    var style: DeviceStyle = DeviceStyle()
    
    init(withID: Int, named: String, asType: DeviceType, withStyle: DeviceStyle) {
        id = withID
        name = named
        type = asType
        style = withStyle
    }
    
}

enum DeviceType {
    case NaN
    case chair_2Motors
    case bed_2Motors
    case table
}
