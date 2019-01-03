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
    
    func createButtons (withText: [String]) {
        for (count, function) in withText.enumerated() {
            let functionButton = UIButton()
            functionButton.tag = count
            functionButton.setTitle(function, for: .normal)
            functionButton.setTitleColor(UIColor.init(displayP3Red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0), for: .normal)
            functionButton.layer.borderWidth = 1
            functionButton.layer.borderColor = UIColor.gray.cgColor
            functionButton.layer.cornerRadius = 8
            
            let bottomMargin = count*70 + 20 + 50
            
            scrollView.addSubview(functionButton)
            functionButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: functionButton, attribute: .leading, relatedBy: .equal, toItem: scrollView.superview, attribute: .leading, multiplier: 1, constant: 30).isActive = true
            NSLayoutConstraint(item: functionButton, attribute: .trailing, relatedBy: .equal, toItem: scrollView.superview, attribute: .trailing, multiplier: 1, constant: -30).isActive = true
            NSLayoutConstraint(item: functionButton, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1, constant: CGFloat(bottomMargin)).isActive = true
            NSLayoutConstraint(item: functionButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
            
            functionButton.addTarget(self, action: #selector(functionsButtonActionEnd), for: .touchUpInside)
            functionButton.addTarget(self, action: #selector(functionsButtonAction), for: .touchDown)
            print(functionButton.tag)
        }
    }
    
    func createViews () {
        totalHeight = functionsList.count*70 + 20 + 70
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: scrollView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(totalHeight)).isActive = true
        
        moreFunctionsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: moreFunctionsLabel, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: CGFloat(20)).isActive = true
        
        scrollView.backgroundColor = UIColor.white
        scrollView.layer.borderColor = UIColor.darkGray.cgColor
        scrollView.layer.borderWidth = 2.0
        
        tapView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
        globalView.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
        globalView.isOpaque = false
        
        if CGFloat(totalHeight) < globalView.bounds.height {
            backButton.isHidden = true
        } else {
            backButton.isHidden = false
        }
    }
}
