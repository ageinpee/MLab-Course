//
//  RFPairingControllerExtension.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 26.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

extension RFPairingController {
    
    func step1(){
        UIView.animate(withDuration:3.0, animations: {
            self.dottedCircle.transform = CGAffineTransform(rotationAngle: CGFloat(90))
        })
    }
    
    func step2(){
        
    }
    
    func step3(){
        
    }
}
