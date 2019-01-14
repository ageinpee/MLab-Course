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
    
    @IBOutlet var globalView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var noFunctionsLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    
    var functionsList: [ExtraFunction] = [ExtraFunction]()
    var totalHeight: Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        globalView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        noFunctionsLabel.text = "Your device currently has no additionaly features. You can find accessories for your device in the 'Explore' section. "
        noFunctionsLabel.textColor = UIColor.gray
        noFunctionsLabel.isHidden = true
        
        functionsList = [ExtraFunction(asType: .massage_back, withTitle: "Back Massage", withHex: "0x01"),
                         ExtraFunction(asType: .massage_neck, withTitle: "Neck Massage", withHex: "0x02"),
                         ExtraFunction(asType: .massage_legs, withTitle: "Leg Massage", withHex: "0x03"),
                         ExtraFunction(asType: .ubl, withTitle: "Under Bed Lights", withHex: "0x04")]
        
        createButtons(withFunctions: functionsList)
    }
    
    func createButtons (withFunctions functions: [ExtraFunction]) {
        print("no implementation at the moment")
        if functions.count == 0 {
            // set Textfield in grey with info where to find extra functions
            noFunctionsLabel.isHidden = false
        }
        else if functions.count == 1 {
            // set one button centered horizontally and vertically
            let button = styleButton(withFunction: functions[0])
            button.tag = 0
            
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
            var offset = 0
            
            for (count, function) in functions.enumerated() {
                let button = styleButton(withFunction: function)
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
                
                NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: contentView.superview, attribute: .bottom, multiplier: 1, constant: CGFloat((-contentViewHeight/functions.count)-offset)).isActive = true
                
                button.addTarget(self, action: #selector(handleButtonPress), for: .touchDown)
            }
        }
    }
    
    @objc
    func handleButtonPress(sender: UIButton!) {
        switch sender.tag{
        case 0:
            executeFunction(withHex: functionsList[0].hex)
        case 1:
            executeFunction(withHex: functionsList[1].hex)
        case 2:
            executeFunction(withHex: functionsList[2].hex)
        case 3:
            executeFunction(withHex: functionsList[3].hex)
        case 4:
            executeFunction(withHex: functionsList[4].hex)
        case 5:
            executeFunction(withHex: functionsList[5].hex)
        case 6:
            executeFunction(withHex: functionsList[6].hex)
        case 7:
            executeFunction(withHex: functionsList[7].hex)
        case 8:
            executeFunction(withHex: functionsList[8].hex)
        default:
            executeFunction(withHex: "0x00")
        }
    }
    
    private func executeFunction(withHex hex: String) {
        print("placehodler for bluetooth function with hexcode \(hex)")
    }
    
    func styleButton(withFunction function: ExtraFunction) -> UIButton {
        let button = UIButton()
        button.setTitle(function.title, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 200.0, left: 0.0, bottom: 0.0, right: 0.0)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        switch function.type {
        case .massage_back:
            button.setBackgroundImage(UIImage(named: "massageBack"), for: .normal)
        case .ubl:
            button.setBackgroundImage(UIImage(named: "ubl"), for: .normal)
        case .massage_neck:
            button.setBackgroundImage(UIImage(named: "massageNeck"), for: .normal)
        case .massage_legs:
            button.setBackgroundImage(UIImage(named: "massageLeg"), for: .normal)
        case .NaN:
            print("this is not a valid value")
        }
        
        return button
    }
    
}

//====================================================================================
//====================================================================================
//====================================================================================

class ExtraFunction {
    
    var type: ExtraFunctions = .NaN
    var title: String = String()
    var hex: String = String()
    
    init() {
        
    }
    
    init(asType: ExtraFunctions, withTitle: String, withHex: String) {
        type = asType
        title = withTitle
        hex = withHex
    }
}

enum ExtraFunctions: String {
    case massage_back
    case massage_neck
    case massage_legs
    case ubl
    case NaN
}
