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
        var title = ""
        for extra in globalDeviceObject.availableExtraFunctions {
            switch extra {
            case .massage_back:
                title = ExtraFunctionsTitle.massage_back.rawValue
            case .massage_neck:
                title = ExtraFunctionsTitle.massage_neck.rawValue
            case .massage_legs:
                title = ExtraFunctionsTitle.massage_legs.rawValue
            case .ubl:
                title = ExtraFunctionsTitle.ubl.rawValue
            case .NaN:
                title = ExtraFunctionsTitle.NaN.rawValue
            }
            
            functionsList.append(ExtraFunction(asType: extra, withTitle: title, withHex: "0x00"))//placeholder
        }
        
        globalView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        noFunctionsLabel.text = "Your device currently has no additional features. You can find accessories for your device in the 'Explore' section. "
        noFunctionsLabel.textColor = UIColor.lightGray
        noFunctionsLabel.isHidden = true
        
        /*
        functionsList = [ExtraFunction(asType: .massage_back, withTitle: "Back Massage", withHex: "0x01"),
                         ExtraFunction(asType: .massage_neck, withTitle: "Neck Massage", withHex: "0x02"),
                         ExtraFunction(asType: .massage_legs, withTitle: "Leg Massage", withHex: "0x03"),
                         ExtraFunction(asType: .ubl, withTitle: "Under Bed Lights", withHex: "0x04")]
         */
        
        createButtons(withFunctions: functionsList)
    }
    
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    
    
}

//====================================================================================
//====================================================================================
//====================================================================================

extension UIImage {
    func resize(width: CGFloat) -> UIImage {
        let height = (width/self.size.width)*self.size.height
        return self.resize(size: CGSize(width: width, height: height))
    }
    
    func resize(height: CGFloat) -> UIImage {
        let width = (height/self.size.height)*self.size.width
        return self.resize(size: CGSize(width: width, height: height))
    }
    
    func resize(size: CGSize) -> UIImage {
        let widthRatio  = size.width/self.size.width
        let heightRatio = size.height/self.size.height
        var updateSize = size
        if(widthRatio > heightRatio) {
            updateSize = CGSize(width:self.size.width*heightRatio, height:self.size.height*heightRatio)
        } else if heightRatio > widthRatio {
            updateSize = CGSize(width:self.size.width*widthRatio,  height:self.size.height*widthRatio)
        }
        UIGraphicsBeginImageContextWithOptions(updateSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: .zero, size: updateSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}



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

enum ExtraFunctionsTitle: String {
    case massage_back = "Massage Back"
    case massage_neck = "Massage Neck"
    case massage_legs = "Massage Legs"
    case ubl = "UBL"
    case NaN = "NaN"
}
