//
//  OldRemoteViewController.swift
//  DewertOkin
//
//  Created by Jan Robert on 03.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import UIKit

class OldRemoteViewController: UIViewController {
    
    @IBOutlet weak var remoteView: UIView!
    
    @IBOutlet weak var backUpButton: UIButton!
    @IBOutlet weak var backDownButton: UIButton!
    @IBOutlet weak var feetUpButton: UIButton!
    @IBOutlet weak var feetDownButton: UIButton!
    @IBOutlet weak var bothUpButton: UIButton!
    @IBOutlet weak var bothDownButton: UIButton!
    @IBOutlet weak var memory1Button: UIButton!
    @IBOutlet weak var memory2Button: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var ublButton: UIButton!
    @IBOutlet weak var torchButton: UIButton!
    
    var buttonList: [UIButton] = [UIButton]()
    var buttonList2: [UIButton] = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonList = [backUpButton, backDownButton,
                      feetUpButton, feetDownButton,
                      bothUpButton, bothDownButton,
                      memory1Button, memory2Button,
                      saveButton, ublButton,
                      torchButton]
        buttonList2 = [backUpButton, backDownButton,
                       feetUpButton, feetDownButton,
                       bothUpButton, bothDownButton,
                       memory1Button, memory2Button,
                       saveButton, ublButton]
        
        constrainButtons()
    }
    
    func constrainButtons() {
        
        guard let superView = remoteView.superview else { return }
        
        let frameWidth = superView.frame.width
        let frameHeight = superView.frame.height
        
        let initialOffset = frameHeight/14
        var offset = frameHeight/14
        var rowCount = 0
        
        
        for button in buttonList {
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frameWidth/5.83).isActive = true
            NSLayoutConstraint(item: button, attribute: .height
                , relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frameHeight/18.66).isActive = true
            NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: remoteView, attribute: .top, multiplier: 1, constant: offset).isActive = true
            
            if rowCount%2 != 0 {
                offset = offset + initialOffset
            }
            rowCount = rowCount+1
        }
        
        var flagLeftRight = true //true == left, false == right
        for button in buttonList2 {
            if flagLeftRight {
                
                NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: remoteView, attribute: .centerX, multiplier: 1, constant: (frameWidth/4.06)-40).isActive = true
                
                flagLeftRight = false
                
            } else {
                
                NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: remoteView, attribute: .centerX, multiplier: 1, constant: -(frameWidth/4.06)+40).isActive = true
                
                flagLeftRight = true
            }
        }
        
        NSLayoutConstraint(item: torchButton, attribute: .centerX, relatedBy: .equal, toItem: remoteView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    
    @IBAction func backUpAction(_ sender: Any) {
        
    }
    
    @IBAction func backDownAction(_ sender: Any) {
        
    }
    
    @IBAction func feetUpAction(_ sender: Any) {
        
    }
    
    @IBAction func feetDownAction(_ sender: Any) {
        
    }
    
    @IBAction func bothUpAction(_ sender: Any) {
        
    }
    
    @IBAction func bothDownAction(_ sender: Any) {
        
    }
    
    @IBAction func memory1Action(_ sender: Any) {
        
    }
    
    @IBAction func memory2Action(_ sender: Any) {
        
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
    }
    
    @IBAction func ublAction(_ sender: Any) {
        
    }
    
    @IBAction func torchAction(_ sender: Any) {
        
    }
    
}
