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
        let selectorLeft = #selector(handleLeftPanGesture(panRecognizer:))
        
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
        PresetsButtonObj.addTarget(self, action: #selector(showPresetsView), for: .touchUpInside)
        
        width = TimerButtonObj.frame.width
        TimerButtonObj.layer.cornerRadius = width/2
        TimerButtonObj.layer.masksToBounds = true
        TimerButtonObj.layer.borderWidth = 1
        TimerButtonObj.layer.borderColor = UIColor.init(displayP3Red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0).cgColor
        TimerButtonObj.addTarget(self, action: #selector(pushTimerViewController), for: .touchUpInside)
        
        width = ExtraFunctionsButtonObj.frame.width
        ExtraFunctionsButtonObj.layer.cornerRadius = width/2
        ExtraFunctionsButtonObj.layer.masksToBounds = true
        ExtraFunctionsButtonObj.layer.borderWidth = 1
        ExtraFunctionsButtonObj.layer.borderColor = UIColor.init(displayP3Red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0).cgColor
        
        devicesListButton.setBackgroundImage(UIImage(named: "devices_list2"), for: .normal)
        devicesListButton.setBackgroundImage(UIImage(named: "devices_list2_highlighted"), for: .highlighted)
    }
    
    @objc
    private func showPresetsView() {
        let nc = UINavigationController(rootViewController: PresetsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        present(nc, animated: true, completion: nil)

    }
    
    @objc
    private func pushTimerViewController() {
        present(UINavigationController(rootViewController: NewTimerListTableViewController()), animated: true, completion: nil)
    }
    
    @objc
    func actionLeft() {
        if (recognizerState == .began) || (recognizerState == .changed) {
            if translation == .down {
                impact.impactOccurred()
                moveFeetDown()
            }
            else if translation == .up {
                impact.impactOccurred()
                moveFeetUp()
            }
        } else {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc
    func actionRight() {
        if (recognizerState == .began) || (recognizerState == .changed) {
            if translation == .down {
                impact.impactOccurred()
                moveHeadDown()
            }
            else if translation == .up {
                impact.impactOccurred()
                moveHeadUp()
            }
        } else {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc
    func handleRightPanGesture(panRecognizer: UIPanGestureRecognizer) {
        recognizerState = panRecognizer.state
        let deviceType = DeviceType(rawValue: self.device.type)!
        
        switch panRecognizer.state {
        case .began:
            translation = .began
            arrowsImageView.alpha = 0
            if bluetoothBackgroundHandler.checkStatus(){
                timer = Timer.scheduledTimer(timeInterval: 0.1,
                                             target: self,
                                             selector: #selector(actionRight),
                                             userInfo: nil,
                                             repeats: true)
            }
        case .changed:
            if(panRecognizer.translation(in: rightPanArea).y >= 40) {
                translation = .down
                switch deviceType {
                case .chair_2Motors:
                    Image.image = device.deviceImages[3]
                case .bed_2Motors:
                    Image.image = device.deviceImages[3]
                case .table:
                    Image.image = device.deviceImages[3]
                default:
                    print("no device found")
                }
                
            } else if (panRecognizer.translation(in: rightPanArea).y <= -40) {
                translation = .up
                switch deviceType {
                case .chair_2Motors:
                    Image.image = device.deviceImages[2]
                case .bed_2Motors:
                    Image.image = device.deviceImages[2]
                case .table:
                    Image.image = device.deviceImages[2]
                default:
                    print("no device found")
                    
                }
            }
        case .ended:
            translation = .ended
            Image.image = device.deviceImages[1]
            fadeInArrows(withAlpha: opacity)
        default: break
        }
    }
    
    
    @objc
    func handleLeftPanGesture(panRecognizer: UIPanGestureRecognizer) {
        recognizerState = panRecognizer.state
        let deviceType = DeviceType(rawValue: self.device.type)!
        
        switch panRecognizer.state {
        case .began:
            translation = .began
            arrowsImageView.alpha = 0
            if bluetoothBackgroundHandler.checkStatus() {
                timer = Timer.scheduledTimer(timeInterval: 0.1,
                                             target: self,
                                             selector: #selector(actionLeft),
                                             userInfo: nil,
                                             repeats: true)
            }
        case .changed:
            if(panRecognizer.translation(in: leftPanArea).y >= 40) {
                translation = .down
                switch deviceType {
                case .chair_2Motors:
                    Image.image = device.deviceImages[5]
                case .bed_2Motors:
                    Image.image = device.deviceImages[5]
                case .table:
                    Image.image = device.deviceImages[3]
                default:
                    print("no device found")
                }
                
            } else if (panRecognizer.translation(in: leftPanArea).y <= -40) {
                translation = .up
                switch deviceType {
                case .chair_2Motors:
                    Image.image = device.deviceImages[4]
                case .bed_2Motors:
                    Image.image = device.deviceImages[4]
                case .table:
                    Image.image = device.deviceImages[2]
                default:
                    print("no device found")
                }
                
            }
        case .ended:
            translation = .ended
            Image.image = device.deviceImages[1]
            fadeInArrows(withAlpha: opacity)
        default: break
        }
    }
    
    func fadeInArrows(withAlpha: CGFloat) {
        UIView.animate(withDuration: 2.0, delay: 5.0, options: [], animations: {
            self.arrowsImageView.alpha = withAlpha
        }, completion: nil)
    }
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
