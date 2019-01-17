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
    @IBOutlet weak var plugLabel: UILabel!
    
    @IBOutlet var pairingView: UIView!
    let backgroundView = UIView()
    
    var selectedRemote: Remote = Remote()
    
    override func viewDidLoad() {
        print(selectedRemote)
        
        plugImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: plugImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: pairingView.frame.height/2).isActive = true
        
        plugLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: plugLabel, attribute: .top, relatedBy: .equal, toItem: plugImage, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        dottedCircleImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: dottedCircleImage, attribute: .top, relatedBy: .equal, toItem: pairingView, attribute: .top, multiplier: 1, constant: 3*(pairingView.frame.height/4)).isActive = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "pairingTransition2") {
            if let vc = segue.destination as? RFPairingController3 {
                vc.selectedRemote = selectedRemote
            }
        }
        
    }
}
