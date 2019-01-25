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
            let button = styleButton(withFunction: self.device.availableExtraFunctions[0])
            
            contentView.addSubview(button)
            
            button.translatesAutoresizingMaskIntoConstraints = true
            button.center = CGPoint(x: self.contentView.bounds.midX,
                                     y: self.contentView.bounds.midY)
            button.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
            
            button.addTarget(self, action: #selector(handleButtonPress), for: .touchDown)
        }
        else if self.device.availableExtraFunctions.count > 1 {
            var flagLeftRight = true //true == left, false == right
            var offset = 0
            
            for (count, function) in self.device.availableExtraFunctions.enumerated() {
                let button = styleButton(withFunction: function)
                let contentViewWidth = Int(contentView.frame.width)
                
                if count % 2 == 0 {
                    offset = offset + contentViewWidth/4 + 80
                }
                
                contentView.addSubview(button)
                button.translatesAutoresizingMaskIntoConstraints = true
                if flagLeftRight {
                    button.center = CGPoint(x: ((self.contentView.bounds.midX) - CGFloat(contentViewWidth) / CGFloat(5)),
                                            y: ((self.contentView.bounds.midY) + CGFloat(300)) - CGFloat(offset))
                    flagLeftRight = false
                }
                else {
                    button.center = CGPoint(x: ((self.contentView.bounds.midX) + CGFloat(contentViewWidth) / CGFloat(5)),
                                            y: ((self.contentView.bounds.midY) + CGFloat(300)) - CGFloat(offset))
                    flagLeftRight = true
                }
                button.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
                
                button.imageView?.contentMode = .scaleAspectFill
                
                button.addTarget(self, action: #selector(handleButtonPress), for: .touchDown)
            }
        }
    }
    
    
    
    
    private func styleButton(withFunction: ExtraFunctions) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height:100))
        button.setTitle(functionsMetadata[withFunction]?.0, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: self.view.frame.width/23)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping
        
        var image = functionsMetadata[withFunction]?.2
        var imageHighlighted = functionsMetadata[withFunction]?.3
        
        let imageSize = CGSize(width: (image?.size.width ?? 1400)/14, height: 100)
        image = image?.resize(size: imageSize)
        imageHighlighted = imageHighlighted?.resize(size: imageSize)
        button.setImage(image, for: .normal)
        button.setImage(imageHighlighted, for: .highlighted)
        button.titleEdgeInsets = UIEdgeInsets(top: 200, left: -imageSize.width, bottom: 0, right: 0)
        
        button.tag = functionsMetadata[withFunction]?.4 ?? 13
        return button
    }
    
    
}
