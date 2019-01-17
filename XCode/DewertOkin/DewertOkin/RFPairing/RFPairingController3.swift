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
        
        
        remoteImage = selectedRemote.image
        
        remoteImageView.image = remoteImage
        
        if selectedRemote.highlightList.count == 0 {
            textLabel.text = "Press any button on your remote"
        } else {
            textLabel.text = "Press the shown buttons on your remote"
            for pos in selectedRemote.highlightList {
                animate(atPosition: pos)
            }
        }
        
        layoutConstraints()
        
        let reader = CSVReader()
        let remoteData = reader.readCSV(fileName: "handsender1", fileType: "csv")
    }
    
    @objc
    private func dismissSelf() {
        self.dismiss(animated: true)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.window = UIWindow(frame: UIScreen.main.bounds)
            delegate.window?.makeKeyAndVisible()
            delegate.window?.rootViewController = MainViewController()
        }
//        present(MainViewController(), animated: true, completion: nil)
        
        
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
    
    
    
    
    func layoutConstraints() {
        remoteImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: remoteImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: pairingView.frame.height/2).isActive = true
        dottedCircleImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: dottedCircleImage, attribute: .top, relatedBy: .equal, toItem: pairingView, attribute: .top, multiplier: 1, constant: 3*(pairingView.frame.height/4)).isActive = true
        
        proceedButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
    }
}
