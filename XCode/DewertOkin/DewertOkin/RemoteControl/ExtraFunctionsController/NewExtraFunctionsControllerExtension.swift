//
//  NewExtraFunctionsControllerExtension.swift
//  DewertOkin
//
//  Created by Henrik Peters on 24.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

extension NewExtraFunctionsController {
    
    func setStaticButtons() {
        self.backButton.layer.borderColor = UIColor.white.cgColor
        self.backButton.layer.borderWidth = 1
        self.backButton.layer.cornerRadius = 10
        
        self.exploreButton.layer.borderColor = UIColor.white.cgColor
        self.exploreButton.layer.borderWidth = 1
        self.exploreButton.layer.cornerRadius = 10
        self.exploreButton.isHidden = true
    }
    
    
    
    
    func setDynamicButtons() {
        if self.device.availableExtraFunctions.count == 0 {
            self.exploreButton.isHidden = false
            self.noFunctionsLabel.isHidden = false
        }
        else if self.device.availableExtraFunctions.count == 1 {
            let button = styleButton(withFunction: self.device.availableExtraFunctions[0],
                                     imageSize: CGSize(width: 100, height: 100))
            
            contentView.addSubview(button)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: contentView.superview, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: contentView.superview, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: contentView.frame.width/3).isActive = true
            NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: contentView.frame.width/3).isActive = true
            
            button.addTarget(self, action: #selector(handleButtonPress), for: .touchDown)
        }
        else if self.device.availableExtraFunctions.count > 1 {
            var flagLeftRight = true //true == left, false == right
            var offset = 0
            
            for (count, function) in self.device.availableExtraFunctions.enumerated() {
                let button = styleButton(withFunction: function, imageSize: CGSize(width: 100, height: 100))
                let contentViewHeight = Int(contentView.frame.height)
                let contentViewWidth = Int(contentView.frame.width)
                
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
                
                NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: contentView.superview, attribute: .bottom, multiplier: 1, constant: CGFloat(((-1/2)*contentViewHeight/self.device.availableExtraFunctions.count)-offset)).isActive = true
                
                button.imageView?.contentMode = .scaleAspectFit
                
                button.addTarget(self, action: #selector(handleButtonPress), for: .touchDown)
            }
        }
    }
    
    
    
    
    private func styleButton(withFunction: ExtraFunctions, imageSize: CGSize) -> UIButton {
        let button = UIButton()
        button.setTitle(functionsMetadata[withFunction]?.0, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: self.view.frame.width/23)
        button.titleEdgeInsets = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping
        
        var image = functionsMetadata[withFunction]?.2
        var imageHighlighted = functionsMetadata[withFunction]?.3
        image = image?.resize(size: imageSize)
        imageHighlighted = imageHighlighted?.resize(size: imageSize)
        button.setBackgroundImage(image, for: .normal)
        button.setBackgroundImage(imageHighlighted, for: .highlighted)
        
        button.tag = functionsMetadata[withFunction]?.4 ?? 13
        return button
    }
    
    
}
