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
    
    let imageName: String
    let name: String
    let accessoryDescription: String
    //let image: UIImage
    
    init(imageName: String, name: String, accessoryDescription: String) {
        self.imageName = imageName
        //self.image = UIImage(named: imageName)!
        self.name = name
        self.accessoryDescription = accessoryDescription
        
        super.init()
    }
    
}
