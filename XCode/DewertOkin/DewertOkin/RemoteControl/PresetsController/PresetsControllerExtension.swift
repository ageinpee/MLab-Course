//
//  PresetsControllerExtension.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 30.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

extension PresetsController {
    
    func createButtons (withText: [String]) {
        for (count, function) in withText.enumerated() {
            let functionButton = UIButton()
            functionButton.tag = count
            functionButton.setTitle(function, for: .normal)
            functionButton.setTitleColor(UIColor.init(displayP3Red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0), for: .normal)
            functionButton.layer.borderWidth = 1
            functionButton.layer.borderColor = UIColor.gray.cgColor
            functionButton.layer.cornerRadius = 10
            
            let topMargin = count*70 + 20
            
            scrollView.addSubview(functionButton)
            functionButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: functionButton, attribute: .leading, relatedBy: .equal, toItem: scrollView.superview, attribute: .leading, multiplier: 1, constant: 20).isActive = true
            NSLayoutConstraint(item: functionButton, attribute: .trailing, relatedBy: .equal, toItem: scrollView.superview, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
            NSLayoutConstraint(item: functionButton, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: CGFloat(topMargin)).isActive = true
            NSLayoutConstraint(item: functionButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
            
            functionButton.addTarget(self, action: #selector(functionsButtonActionEnd), for: .touchUpInside)
            functionButton.addTarget(self, action: #selector(functionsButtonAction), for: .touchDown)
            print(functionButton.tag)
        }
    }
}
