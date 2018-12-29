//
//  deviceStyle.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 29.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit.UIImage

class deviceStyle {
    var stylesString: [String] = [String]()
    var stylesImages: [UIImage] = [UIImage]()
    
    init() {
        
    }
    
    init(withStrings: [String]) {
        stylesString = withStrings
        for string in stylesString {
            stylesImages.append(UIImage(named: string)!)
        }
    }
    
    init(withImages: [UIImage]) {
        stylesImages = withImages
    }
}
