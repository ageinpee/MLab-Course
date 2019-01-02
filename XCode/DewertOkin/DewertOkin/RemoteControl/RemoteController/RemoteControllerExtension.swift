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
        
        let selectorRight = #selector(handleRightPanGesture(panRecognizer:))
        let selectorLeft = #selector(handleLeftPanGesture(recognizer:))
        
        panRecLeft = UIPanGestureRecognizer(target: self, action: selectorLeft)
        panRecRight = UIPanGestureRecognizer(target: self, action: selectorRight)
        
        leftPanArea.addGestureRecognizer(panRecLeft)
        rightPanArea.addGestureRecognizer(panRecRight)
        
        panRecLeft.delegate = self
        panRecRight.delegate = self
        
        leftPanArea.backgroundColor = UIColor.clear
        rightPanArea.backgroundColor = UIColor.clear
    }
    
    func setupButtons() {
        var width = PresetsButtonObj.frame.width
        PresetsButtonObj.layer.cornerRadius = width/2
        PresetsButtonObj.layer.masksToBounds = true
        PresetsButtonObj.layer.borderWidth = 1
        PresetsButtonObj.layer.borderColor = UIColor.init(displayP3Red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0).cgColor
        
        width = TimerButtonObj.frame.width
        TimerButtonObj.layer.cornerRadius = width/2
        TimerButtonObj.layer.masksToBounds = true
        TimerButtonObj.layer.borderWidth = 1
        TimerButtonObj.layer.borderColor = UIColor.init(displayP3Red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0).cgColor
        
        width = ExtraFunctionsButtonObj.frame.width
        ExtraFunctionsButtonObj.layer.cornerRadius = width/2
        ExtraFunctionsButtonObj.layer.masksToBounds = true
        ExtraFunctionsButtonObj.layer.borderWidth = 1
        ExtraFunctionsButtonObj.layer.borderColor = UIColor.init(displayP3Red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0).cgColor
    }
    
    @objc
    func actionLeft() {
        if (recognizerState == .began) || (recognizerState == .changed) {
            print(Date())
            if translation == .down {
                print("--> down")
            }
            else if translation == .up {
                print("--> up")
            }
        } else {
            print("end")
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc
    func actionRight() {
        if (recognizerState == .began) || (recognizerState == .changed) {
            print(Date())
            if translation == .down {
                print("--> down")
                goDown()
            }
            else if translation == .up {
                print("--> up")
                goUp()
            }
        } else {
            print("end")
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc
    func handleRightPanGesture(panRecognizer: UIPanGestureRecognizer) {
        recognizerState = panRecognizer.state
        
        switch panRecognizer.state {
        case .began:
            print("Pan in Right Area started")
            translation = .began
            timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(actionRight), userInfo: nil, repeats: true)
            
        case .changed:
            if(panRecognizer.translation(in: rightPanArea).y >= 40) {
                translation = .down
                arrowsImageView.alpha = 0
                Image.image = currentStyle.stylesImages[3]
                
            } else if (panRecognizer.translation(in: rightPanArea).y <= -40) {
                translation = .up
                arrowsImageView.alpha = 0
                Image.image = currentStyle.stylesImages[2]
                goUp()
            }
        case .ended:
            print("Pan in Right Area ended")
            print(Date())
            translation = .ended
            Image.image = currentStyle.stylesImages[1]
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
                Image.image = currentStyle.stylesImages[5]
                // goFeetDown()
            } else if (recognizer.translation(in: leftPanArea).y <= -40) {
                print("moving up" + String(Int(recognizer.translation(in: leftPanArea).y)))
                arrowsImageView.alpha = 0
                Image.image = currentStyle.stylesImages[4]
                // goFeetUp()
            }
            break
        case .ended:
            print("Pan in Left Area ended")
            Image.image = currentStyle.stylesImages[1]
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
