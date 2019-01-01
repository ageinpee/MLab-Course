//
//  PresetsController.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 29.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

class PresetsController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addPresetButton: UIButton!
    
    var presetsList: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presetsList = ["sleeping", "mornings", "relaxing"]
        
        setupAddButton()
        createButtons(withText: presetsList)
    }
    
    func setupAddButton () {
        let width = addPresetButton.frame.width
        addPresetButton.layer.cornerRadius = width/2
        addPresetButton.layer.masksToBounds = true
        addPresetButton.layer.borderWidth = 2
        addPresetButton.layer.borderColor = UIColor.init(displayP3Red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0).cgColor
    }
    
    @objc func functionsButtonAction(sender: UIButton!) {
        switch sender.tag {
        case 0:
            print("xxx")
            sender.backgroundColor = UIColor.lightGray
        case 1:
            print("yyy")
            sender.backgroundColor = UIColor.lightGray
        case 2:
            print("zzz")
            sender.backgroundColor = UIColor.lightGray
        default:
            print("default")
        }
    }
    
    @objc func functionsButtonActionEnd(sender: UIButton!) {
        switch sender.tag {
        case 0:
            sender.backgroundColor = UIColor.white
        case 1:
            sender.backgroundColor = UIColor.white
        case 2:
            sender.backgroundColor = UIColor.white
        default:
            print("default")
        }
    }
}
