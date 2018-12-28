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
    @IBOutlet weak var dottedCircleImage: UIImageView!
    
    @IBOutlet weak var plugImage: UIImageView!
    @IBOutlet weak var socketImage: UIImageView!
    
    @IBOutlet var pairingView: UIView!
    let backgroundView = UIView()
    
    override func viewDidLoad() {
        animateImages()
    }
    
    func animateImages () {
        UIView.animate(withDuration: 4.0, delay: 2.0, options: [.repeat, .autoreverse], animations: {
            
            self.plugImage.transform = CGAffineTransform(translationX: CGFloat(150), y: 0)
            
        }, completion: nil)
    }
}
