//
//  RFPairingControllerExtension.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 26.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

extension RFPairingController1 {
    
    func prepareSubview() {
        
        pairingView.addSubview(rotationView)

        rotationView.layer.bounds = CGRect(x:0, y:0, width:2*dottedCircle.center.y, height:2*dottedCircle.center.y)
        
        rotationView.backgroundColor = UIColor.white
        
        rotationView.addSubview(dottedCircle)
        rotationView.bringSubviewToFront(dottedCircle)
        rotationView.addSubview(remotePicker)
        rotationView.bringSubviewToFront(remotePicker)
        rotationView.addSubview(submitButton1)
        rotationView.bringSubviewToFront(submitButton1)
    }
}
