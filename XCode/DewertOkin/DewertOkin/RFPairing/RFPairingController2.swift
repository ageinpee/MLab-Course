//
//  RFPairingController2.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 27.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

class RFPairingController2: UIViewController {
    
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var plugImage: UIImageView!
    @IBOutlet weak var socketImage: UIImageView!
    
    override func viewDidLoad() {
        
        UIView.animate(withDuration: 4.0, delay: 2.0, options: [.repeat, .autoreverse], animations: {
            
            self.plugImage.transform = CGAffineTransform(translationX: CGFloat(150), y: 0)
            
        }, completion: nil)
    }
}
