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
        
        functionsList = [.massage_back, .massage_head, .massage_legs, .ubl]
        functionsHexCodes = ["0x00", "0x00", "0x00", "0x00"]
        
    }
    
    func createButtons (withFunctions functions: [ExtraFunctions], withHexCodes: [String]) {
        print("no implementation at the moment")
    }
    
}

enum ExtraFunctions {
    case massage_back
    case massage_head
    case massage_legs
    case ubl
}
