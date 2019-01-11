//
//  Accessorie.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 11.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

class Accessorie: NSObject {
    
    let image: UIImage
    let name: String
    let accessorieDescription: String
    
    init(image: UIImage, name: String, accessorieDescription: String) {
        self.image = image
        self.name = name
        self.accessorieDescription = accessorieDescription
        
        super.init()
    }
    
}
