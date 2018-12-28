//
//  Remote.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 28.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit.UIImage

class Remote {
    var id: String = ""
    var image: UIImage = UIImage()
    var highlightList: [CGPoint] = [CGPoint]()
    
    init() {
        
    }
    
    init(withID: String, withImage: UIImage) {
        id = withID
        image = withImage
    }
    
    init(withID: String, withImage: UIImage, withHighlights: [CGPoint]) {
        id = withID
        image = withImage
        highlightList = withHighlights
    }
}
