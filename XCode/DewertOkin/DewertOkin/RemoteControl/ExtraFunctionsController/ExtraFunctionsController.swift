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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var functionsList: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        functionsList = ["Massage", "UBL", "Torch", "Massage2"]
        
        createButtons(withText: functionsList)
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
