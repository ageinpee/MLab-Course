//
//  AddPresetController.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 30.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

class AddPresetController: UIViewController {
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var nameTextfield: UITextField!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    var memoryStates: [MemoryState] = [MemoryState]()
    var selectedMemory: Int = Int()
    
    var selectedButton: UIButton = UIButton()
    
    var data: [String] = [String]()
    
    override func viewDidLoad() {
        
        memoryStates = [.empty, .loaded, .empty]
        
        createButtons(withStates: memoryStates)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if nameTextfield.text != "" {
            data = [nameTextfield.text!, String(selectedMemory)]
        }
    }
    
    func createButtons (withStates: [MemoryState]) {
        for (count, state) in withStates.enumerated() {
            let stateButton = UIButton()
            stateButton.tag = count+1
            stateButton.setTitle(("Memory \(count)"), for: .normal)
            stateButton.setTitleColor(UIColor.init(displayP3Red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0), for: .normal)
            stateButton.layer.borderWidth = 0.5
            stateButton.layer.borderColor = UIColor.gray.cgColor
            stateButton.layer.cornerRadius = 10
            
            if state == MemoryState.loaded {
                stateButton.backgroundColor = UIColor.lightGray
                stateButton.alpha = 0.5
                stateButton.setTitle(("Memory \(count) already used"), for: .normal)
                stateButton.tag = -(count+1)
            }
            
            let topMargin = count*70 + 20
            
            buttonView.addSubview(stateButton)
            stateButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: stateButton, attribute: .leading, relatedBy: .equal, toItem: buttonView.superview, attribute: .leading, multiplier: 1, constant: 50).isActive = true
            NSLayoutConstraint(item: stateButton, attribute: .trailing, relatedBy: .equal, toItem: buttonView.superview, attribute: .trailing, multiplier: 1, constant: -50).isActive = true
            NSLayoutConstraint(item: stateButton, attribute: .top, relatedBy: .equal, toItem: buttonView, attribute: .top, multiplier: 1, constant: CGFloat(topMargin)).isActive = true
            NSLayoutConstraint(item: stateButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
            
            stateButton.addTarget(self, action: #selector(stateButtonActionEnd), for: .touchUpInside)
            stateButton.addTarget(self, action: #selector(stateButtonAction), for: .touchDown)
            print(stateButton.tag)
        }
    }
    
    @objc func stateButtonAction(sender: UIButton!) {
        if sender.tag < 0 {
            sender.backgroundColor = UIColor.lightGray
            shake(view: sender, for: 0.2, withTranslation: 500)
        }
        else
        {
            memoryStates[sender.tag-1] = .loaded
            selectedMemory = sender.tag-1
            
            sender.backgroundColor = UIColor.lightGray
            sender.alpha = 0.5
            
            selectedButton.backgroundColor = UIColor.white
            selectedButton.alpha = 1
            selectedButton = sender
            
            switch sender.tag {
            case 1:
                print("yyy")
            case 2:
                print("zzz")
            case 3:
                print("abc")
            default:
                print("default")
            }
        }
    }
    
    @objc func stateButtonActionEnd(sender: UIButton!) {
        if sender.tag > 0 {
            sender.backgroundColor = UIColor.white
            sender.alpha = 1
            
            selectedButton.backgroundColor = UIColor.lightGray
            selectedButton.alpha = 0.75
            
            switch sender.tag {
            case 1:
                print("xxxx")
            case 2:
                print("xyyy")
            case 3:
                print("xzzz")
            default:
                print("default")
            }
        }
    }
    
    func shake(view: UIView, for duration: TimeInterval = 0.5, withTranslation translation: CGFloat = 10) {
        let propertyAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.3) {
            view.transform = CGAffineTransform(translationX: translation, y: 0)
        }
        
        propertyAnimator.addAnimations({
            view.transform = CGAffineTransform(translationX: 0, y: 0)
        }, delayFactor: 0.2)
        
        propertyAnimator.startAnimation()
    }
}


//==================================================
//==================================================
//==================================================

enum MemoryState {
    case empty
    case loaded
}
