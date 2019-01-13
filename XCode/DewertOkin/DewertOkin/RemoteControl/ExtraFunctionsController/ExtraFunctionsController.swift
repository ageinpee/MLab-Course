//
//  ExtraFunctionsController.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 29.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

class ExtraFunctionsController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var noFunctionsLabel: UILabel!
    
    
    var functionsList: [ExtraFunctions] = [ExtraFunctions]()
    var functionsHexCodes: [String] = [String]()
    var totalHeight: Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noFunctionsLabel.text = "Your device currently has no additionaly features. You can find accessories for your device in the 'Explore' section. "
        noFunctionsLabel.textColor = UIColor.gray
        noFunctionsLabel.isHidden = true
        
        functionsList = [.massage_back, .massage_neck, .massage_legs, .ubl]
        functionsHexCodes = ["0x00", "0x00", "0x00", "0x00"]
        
        createButtons(withFunctions: functionsList, withHexCodes: functionsHexCodes)
    }
    
    func createButtons (withFunctions functions: [ExtraFunctions], withHexCodes: [String]) {
        print("no implementation at the moment")
        if functions.count == 0 {
            // set Textfield in grey with info where to find extra functions
            noFunctionsLabel.isHidden = false
        }
        else if functions.count == 1 {
            // set one button centered horizontally and vertically
            let button = styleButton(withFunction: functions[0])
            
            contentView.addSubview(button)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: contentView.superview, attribute: .leading, multiplier: 1, constant: contentView.frame.width/4+20).isActive = true
            NSLayoutConstraint(item: button, attribute: .trailing, relatedBy: .equal, toItem: contentView.superview, attribute: .trailing, multiplier: 1, constant: contentView.frame.width/4+20).isActive = true
            
            NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: contentView.superview, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: contentView.superview, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            
            NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: button, attribute: .width, multiplier: 1/1, constant: 0).isActive = true
            
            button.addTarget(self, action: #selector(handleButtonPress), for: .touchDown)
        }
        else if functions.count >= 2 {
            // set the buttons in two columns
            var flagLeftRight = true //true == left, false == right
            var counterUp = 0 //counts the buttons in the loop
            var offset = 0
            
            for (count, function) in functions.enumerated() {
                let button = styleButton(withFunction: function)
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
                
                NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: contentView.superview, attribute: .bottom, multiplier: 1, constant: CGFloat((-contentViewHeight/functions.count)-offset)).isActive = true
                
                button.addTarget(self, action: #selector(handleButtonPress), for: .touchDown)
            }
        }
    }
    
    @objc
    func handleButtonPress(sender: UIButton!) {
        
    }
    
    func styleButton(withFunction function: ExtraFunctions) -> UIButton {
        let button = UIButton()
        button.setTitle(function.rawValue, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 200.0, left: 0.0, bottom: 0.0, right: 0.0)
        button.setTitleColor(UIColor.black, for: .normal)
        
        switch function {
        case .massage_back:
            button.setBackgroundImage(UIImage(named: "massageBack"), for: .normal)
        case .ubl:
            button.setBackgroundImage(UIImage(named: "ubl"), for: .normal)
        case .massage_neck:
            button.setBackgroundImage(UIImage(named: "massageNeck"), for: .normal)
        case .massage_legs:
            button.setBackgroundImage(UIImage(named: "massageLeg"), for: .normal)
        }
        
        return button
    }
    
}

enum ExtraFunctions: String {
    case massage_back
    case massage_neck
    case massage_legs
    case ubl
}
