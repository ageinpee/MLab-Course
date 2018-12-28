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
    
    @IBOutlet var pairingView: UIView!
    let backgroundView = UIView()
    
    var selectedRemote: String = ""
    
    override func viewDidLoad() {
        print(selectedRemote)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "pairingTransition2") {
            if let vc = segue.destination as? RFPairingController3 {
                vc.selectedRemote = selectedRemote
            }
        }
        
    }
}
