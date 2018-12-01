//
//  RemoteController.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 29.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit


class RemoteController: UIViewController{
    
    @IBOutlet weak var PresetsButtonObj: UIButton!
    @IBOutlet weak var AddPresetsButtonObj: UIButton!
    @IBOutlet weak var ExtraFunctionsButtonObj: UIButton!
    
    //----------------------------------------
    //--------------- Setup ------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var width = PresetsButtonObj.frame.width
        PresetsButtonObj.layer.cornerRadius = width/2
        PresetsButtonObj.layer.masksToBounds=true
        PresetsButtonObj.layer.borderWidth = 1
        PresetsButtonObj.layer.borderColor = UIColor.gray.cgColor
        
        width = AddPresetsButtonObj.frame.width
        AddPresetsButtonObj.layer.cornerRadius = width/2
        AddPresetsButtonObj.layer.masksToBounds = true
        AddPresetsButtonObj.layer.borderWidth = 1
        AddPresetsButtonObj.layer.borderColor = UIColor.gray.cgColor
        
        width = ExtraFunctionsButtonObj.frame.width
        ExtraFunctionsButtonObj.layer.cornerRadius = width/2
       ExtraFunctionsButtonObj.layer.masksToBounds = true
        ExtraFunctionsButtonObj.layer.borderWidth = 1
        ExtraFunctionsButtonObj.layer.borderColor = UIColor.gray.cgColor
    }
    
    //----------------------------------------
    //----- generic remote design buttons ----
    
    @IBAction func headUpBtn(_ sender: Any) {
        
    }
    
    @IBAction func headDownBtn(_ sender: Any) {
        print("asdadasdasdadsadasd is an overload!")

    }
    
    @IBAction func FootUpBtn(_ sender: Any) {
    }
    
    @IBAction func FootDownBtn(_ sender: Any) {
    }
    
    
    @IBAction func RestPosBtn(_ sender: Any) {
    }
    
    @IBAction func FlatPosBtn(_ sender: Any) {
    }
    
    @IBAction func M1Btn(_ sender: Any) {
    }
    
    @IBAction func M2Btn(_ sender: Any) {
    }
    
    @IBAction func SaveBtn(_ sender: Any) {
    }
    
    
    @IBAction func UblBtn(_ sender: Any) {
    }
    
    @IBAction func TourchBtn(_ sender: Any) {
    }
    
    //---------------------------------------
    //----- Fancy Design Remote Actions -----
    
    @IBAction func PresetsButton(_ sender: Any) {
    }
    
    @IBAction func AddPresetsButton(_ sender: Any) {
    }
    
    @IBAction func ExtraFunctions(_ sender: Any) {
    }
    
}

