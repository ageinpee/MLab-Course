//
//  Accessorie.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 11.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

class Accessory: NSObject {
    
    let image: UIImage
    let name: String
    let accessoryDescription: String
    
    init(image: UIImage, name: String, accessoryDescription: String) {
        self.image = image
        self.name = name
        self.accessoryDescription = accessoryDescription
        
        super.init()
    }
    
}
