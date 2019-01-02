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
    @IBOutlet weak var choosePresetLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    var presetsList: [String] = [String]()
    var presetsData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presetsList = []//["sleeping", "mornings", "relaxing"]
        
        checkPresetsList()
        
        setupAddButton()
        createButtons(withText: presetsList)
    }
    
    @IBAction func unwindFromAddPreset(_ sender: UIStoryboardSegue) {
        if sender.source is AddPresetController {
            if let senderVC = sender.source as? AddPresetController {
                presetsData = senderVC.data
                presetsList.append(presetsData[0])
            }
            checkPresetsList()
            createButtons(withText: presetsList)
        }
    }
    
    func checkPresetsList() {
        if presetsList.count != 0 {
            textLabel.isHidden = true
        } else {
            choosePresetLabel.isHidden = true
        }
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
