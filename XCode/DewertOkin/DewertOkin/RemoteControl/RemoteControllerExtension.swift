//
//  RemoteControllerExtension.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 29.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

extension RemoteController {
    
    func setupPanAreas() {
        leftPanArea.isUserInteractionEnabled = true
        rightPanArea.isUserInteractionEnabled = true
        let panRecLeft = UIPanGestureRecognizer(target: self, action: #selector(handleLeftPanGesture(recognizer:)))
        let panRecRight = UIPanGestureRecognizer(target: self, action: #selector(handleRightPanGesture(recognizer:)))
        leftPanArea.addGestureRecognizer(panRecLeft)
        rightPanArea.addGestureRecognizer(panRecRight)
        
        leftPanArea.backgroundColor = UIColor.clear
        rightPanArea.backgroundColor = UIColor.clear
    }
    
    func setupButtons() {
        var width = PresetsButtonObj.frame.width
        PresetsButtonObj.layer.cornerRadius = width/2
        PresetsButtonObj.layer.masksToBounds = true
        PresetsButtonObj.layer.borderWidth = 1
        PresetsButtonObj.layer.borderColor = UIColor.gray.cgColor
        
        width = AddPresetsButtonObj.frame.width
        AddPresetsButtonObj.layer.cornerRadius = width/2
        AddPresetsButtonObj.layer.masksToBounds = true
        AddPresetsButtonObj.layer.borderWidth = 1
        AddPresetsButtonObj.layer.borderColor = UIColor.gray.cgColor
        
        width = ExtraFunctionsButtonObj.frame.width
        ExtraFunctionsButtonObj.layer.cornerRadius = width/2
        ExtraFunctionsButtonObj.layer.masksToBounds = true
        ExtraFunctionsButtonObj.layer.borderWidth = 1
        ExtraFunctionsButtonObj.layer.borderColor = UIColor.gray.cgColor
    }
    
    @objc
    func handleRightPanGesture(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            print("Pan in Right Area ended")
            
        case .changed:
            if(recognizer.translation(in: rightPanArea).y >= 40) {
                print("moving down" + String(Int(recognizer.translation(in: rightPanArea).y)))
                arrowsImageView.alpha = 0
                Image.image = currentStyle.stylesImages[2]
                goDown()
            } else if (recognizer.translation(in: rightPanArea).y <= -40) {
                print("moving up" + String(Int(recognizer.translation(in: rightPanArea).y)))
                arrowsImageView.alpha = 0
                Image.image = currentStyle.stylesImages[1]
                goUp()
            }
        case .ended:
            print("Pan in Right Area ended")
            Image.image = currentStyle.stylesImages[0]
            animateFade(withAlpha: opacity)
        default: break
        }
    }
    
    
    @objc
    func handleLeftPanGesture(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            print("Pan in Left Area")
            break
        case .changed:
            if(recognizer.translation(in: leftPanArea).y >= 40) {
                print("moving down" + String(Int(recognizer.translation(in: leftPanArea).y)))
                arrowsImageView.alpha = 0
                Image.image = currentStyle.stylesImages[4]
                // goFeetDown()
            } else if (recognizer.translation(in: leftPanArea).y <= -40) {
                print("moving up" + String(Int(recognizer.translation(in: leftPanArea).y)))
                arrowsImageView.alpha = 0
                Image.image = currentStyle.stylesImages[3]
                // goFeetUp()
            }
            break
        case .ended:
            print("Pan in Left Area ended")
            Image.image = currentStyle.stylesImages[0]
            animateFade(withAlpha: opacity)
            break
        default: break
        }
    }
    
    func animateFade(withAlpha: CGFloat) {
        UIView.animate(withDuration: 2.0, delay: 5.0, options: [], animations: {
            self.arrowsImageView.alpha = withAlpha
        }, completion: nil)
    }
}
