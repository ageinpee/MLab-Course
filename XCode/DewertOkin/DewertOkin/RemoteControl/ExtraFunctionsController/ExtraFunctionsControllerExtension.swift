//
//  ExtraFunctionsControllerExtension.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 30.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

extension ExtraFunctionsController {
    
    func createButtons(withFunctions functions: [ExtraFunction]) {
        print("no implementation at the moment")
        if functions.count == 0 {
            // set Textfield in grey with info where to find extra functions
            noFunctionsLabel.isHidden = false
        }
        else if functions.count == 1 {
            // set one button centered horizontally and vertically
            var button = UIButton()
            button = styleButton(forButton: button, withFunction: functions[0])
            button.tag = 0
            
            contentView.addSubview(button)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: contentView.superview, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: contentView.superview, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            
            NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: contentView.frame.width/3).isActive = true
            NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: contentView.frame.width/3).isActive = true
            
            button.addTarget(self, action: #selector(handleButtonPress), for: .touchDown)
        }
        else if functions.count >= 2 {
            // set the buttons in two columns
            var flagLeftRight = true //true == left, false == right
            var offset = 0
            
            for (count, function) in functions.enumerated() {
                var button = UIButton()
                let contentViewHeight = Int(contentView.frame.height)
                let contentViewWidth = Int(contentView.frame.width)
                button.tag = count
                
                if count % 2 == 0 {
                    offset = offset + contentViewWidth/4 + 80
                }
                
                contentView.addSubview(button)
                button.translatesAutoresizingMaskIntoConstraints = false
                
                if flagLeftRight {
                    NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: contentView.superview, attribute: .centerX, multiplier: 1, constant: CGFloat(-contentViewWidth/4)).isActive = true
                    flagLeftRight = false
                }
                else {
                    NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: contentView.superview, attribute: .centerX, multiplier: 1, constant: CGFloat(contentViewWidth/4)).isActive = true
                    flagLeftRight = true
                }
                
                NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: button, attribute: .height, multiplier: 1, constant: 0).isActive = true
                NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: button, attribute: .width, multiplier: 1, constant: 0).isActive = true
                
                NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: contentView.superview, attribute: .bottom, multiplier: 1, constant: CGFloat(((-1/2)*contentViewHeight/functions.count)-offset)).isActive = true
                
                button.imageView?.contentMode = .scaleAspectFit
                button = styleButton(forButton: button, withFunction: function)
                
                button.addTarget(self, action: #selector(handleButtonPress), for: .touchDown)
            }
        }
    }
    
    
    func styleButton(forButton button: UIButton, withFunction function: ExtraFunction) -> UIButton {
        button.setTitle(function.title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        switch function.type {
        case .massage_back:
            var image = UIImage(named: "massageBackHRWhiteCurly")
            image = image?.resize(size: CGSize(width: 100, height: 100))
            button.setImage(image, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -1*(image!.size.width)-20)
            button.titleEdgeInsets = UIEdgeInsets(top: 200, left: -1*(image!.size.width), bottom: 0, right: 0)
        case .ubl:
            var image = UIImage(named: "ublHRWhite")
            image = image?.resize(size: CGSize(width: 100, height: 100))
            button.setImage(image, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -1*(image!.size.width)-20)
            button.titleEdgeInsets = UIEdgeInsets(top: 200, left: -1*(image!.size.width), bottom: 0, right: 0)
        case .massage_neck:
            var image = UIImage(named: "massageNeckHRWhiteCurly")
            image = image?.resize(size: CGSize(width: 100, height: 100))
            button.setImage(image, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -1*(image!.size.width)-20)
            button.titleEdgeInsets = UIEdgeInsets(top: 200, left: -1*(image!.size.width), bottom: 0, right: 0)
        case .massage_legs:
            var image = UIImage(named: "massageLegHRWhiteCurly")
            image = image?.resize(size: CGSize(width: 100, height: 100))
            button.setImage(image, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -1*(image!.size.width)+20)
            button.titleEdgeInsets = UIEdgeInsets(top: 200, left: -1*(image!.size.width), bottom: 0, right: 0)
        case .NaN:
            print("this is not a valid value")
        }
        
        return button
    }
}
