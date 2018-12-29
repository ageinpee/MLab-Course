//
//  pullUpSegue.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 29.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

class pullUpSegue: UIStoryboardSegue {
    
    override func perform() {
        
    }
    
    func animateSegue() {
        
        // Assign the source and destination views to local variables.
        var firstVCView = self.source.view as UIView!
        var secondVCView = self.destination.view as UIView!
        
        // Get the screen width and height.
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        // Specify the initial position of the destination view.
        secondVCView!.frame = CGRect(0.0, screenHeight, screenWidth, screenHeight)
        
    }
}
