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
        
        pairingView.addSubview(backgroundView)

        backgroundView.layer.bounds = CGRect(x:0, y:0, width:3*dottedCircle.center.y, height:3*dottedCircle.center.y)
        
        backgroundView.backgroundColor = UIColor.white
        
        backgroundView.addSubview(dottedCircle)
        backgroundView.bringSubviewToFront(dottedCircle)
        backgroundView.addSubview(remotePicker)
        backgroundView.bringSubviewToFront(remotePicker)
        backgroundView.addSubview(submitButton1)
        backgroundView.bringSubviewToFront(submitButton1)
    }
}
