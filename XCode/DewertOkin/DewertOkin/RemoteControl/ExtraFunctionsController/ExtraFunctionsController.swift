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
    @IBOutlet weak var moreFunctionsLabel: UILabel!
    @IBOutlet var globalView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tapView: UIView!
    
    var functionsList: [String] = [String]()
    var totalHeight: Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        functionsList = ["Massage", "UBL", "Torch", "Massage2"]
        
        createButtons(withText: functionsList)
        createViews()
        
    }
    
    @objc func functionsButtonAction(sender: UIButton!) {
        sender.backgroundColor = UIColor.lightGray
        sender.alpha = 0.5
        switch sender.tag {
        case 0:
            print("xxx")
        case 1:
            print("yyy")
        case 2:
            print("zzz")
        case 3:
            print("aaa")
        case 4:
            print("bbb")
        case 5:
            print("ccc")
        default:
            print("default")
        }
    }
    
    @objc func functionsButtonActionEnd(sender: UIButton!) {
        sender.backgroundColor = UIColor.white
        sender.alpha = 1
        switch sender.tag {
        case 0:
            print("xxxx")
        case 1:
            print("xyyy")
        case 2:
            print("xzzz")
        case 3:
            print("xaaa")
        case 4:
            print("xbbb")
        case 5:
            print("xccc")
        default:
            print("default")
        }
    }
    
}
