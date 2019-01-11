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
    
    var functionsList: [ExtraFunctions] = [ExtraFunctions]()
    var functionsHexCodes: [String] = [String]()
    var totalHeight: Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        functionsList = [.massage_back] //, .massage_neck, .massage_legs, .ubl]
        functionsHexCodes = ["0x00", "0x00", "0x00", "0x00"]
        
        createButtons(withFunctions: functionsList, withHexCodes: functionsHexCodes)
    }
    
    func createButtons (withFunctions functions: [ExtraFunctions], withHexCodes: [String]) {
        print("no implementation at the moment")
        if functions.count == 0 {
            // set Textfield in grey with info where to find extra functions
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
        }
        else if functions.count >= 2 {
            // set the buttons in two columns
        }
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
