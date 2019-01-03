//
//  RFPairingController3.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 27.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

class RFPairingController3: UIViewController {
    
    @IBOutlet weak var dottedCircleImage: UIImageView!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet var pairingView: UIView!
    let backgroundView = UIView()
    
    @IBOutlet weak var remoteImageView: UIImageView!
    
    var selectedRemote: Remote = Remote()
    
    var remoteImage: UIImage = UIImage()
    
    override func viewDidLoad() {
        
        if selectedRemote.image != nil {
            remoteImage = selectedRemote.image
        } else {
            print("ERROR: remote not found")
        }
        
        remoteImageView.image = remoteImage
        
        if selectedRemote.highlightList.count == 0 {
            textLabel.text = "Press any button on your remote"
        } else {
            textLabel.text = "Press the shown buttons on your remote"
            for pos in selectedRemote.highlightList {
                animate(atPosition: pos)
            }
        }
    }
    
    func animate (atPosition: CGPoint) {
        let animationView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        animationView.center = atPosition
        
        let circleBlueView = UIImageView(image: UIImage(named: "circleBlue"))
        let circleGrayView = UIImageView(image: UIImage(named: "circleGray"))
        
        circleGrayView.alpha = 0.5
        circleGrayView.frame.size = CGSize(width: 80, height: 80)
        circleBlueView.frame.size = CGSize(width: 80, height: 80)
        
        pairingView.addSubview(animationView)
        
        animationView.addSubview(circleBlueView)
        animationView.addSubview(circleGrayView)
        animationView.contentMode = .scaleAspectFit
        animationView.layer.anchorPoint = CGPoint(x:0.5, y:0.5)
        
        remoteImageView.addSubview(animationView)
        
        animationView.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        
        UIView.animate(withDuration: 1.0, delay: 2.5, animations: {
            animationView.transform = CGAffineTransform.identity
        })
        
        UIView.animate(withDuration: 2.0, delay: 1.0, options: [.repeat, .autoreverse], animations: {
            animationView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }, completion: nil)
    }
}
