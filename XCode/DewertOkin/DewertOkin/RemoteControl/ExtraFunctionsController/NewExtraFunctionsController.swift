//
//  NewExtraFunctionsController.swift
//  DewertOkin
//
//  Created by Henrik Peters on 24.01.19.
//  Copyright © 2019 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit

class NewExtraFunctionsController: UIViewController {
    var device = globalDeviceObject
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var exploreButton: UIButton!
    @IBOutlet weak var noFunctionsLabel: UILabel!

    // [ Extrafunction-Enum-Entry: (Title | Data for Bluetooth | Image for .normal | Image for .highlighted | tag for functionallity)]
    var functionsMetadata = [ExtraFunctions.massage_back: ("Massage Back", Data(), UIImage(named: "massageBackHRWhiteCurly"), UIImage(named: "massageBackHRCurlyHighlighted"), 0),
                             ExtraFunctions.massage_neck: ("Massage Neck", Data(), UIImage(named: "massageNeckHRWhiteCurly"), UIImage(named: "massageNeckHRCurlyHighlighted"), 1),
                             ExtraFunctions.massage_legs: ("Massage Legs", Data(), UIImage(named: "massageLegHRWhiteCurly"), UIImage(named: "massageLegHRCurlyHighlighted"), 2),
                             ExtraFunctions.ubl: ("Under Bed Lighting", Data(), UIImage(named: "ublHRWhite"), UIImage(named: "ublHRHighlighted"), 3),
                             //Extrafunctions from Explore
                             ExtraFunctions.satellite_speaker: ("Satellite Speaker", Data(), UIImage(named: "satellite_speaker"), UIImage(named: "satellite_speaker_highlighted"), 4),
                             ExtraFunctions.subwoofer_speaker: ("Subwoofer Speaker", Data(), UIImage(named: "subwoofer_speaker"), UIImage(named: "subwoofer_speaker_highlighted"), 5),
                             ExtraFunctions.massage_motor: ("Massage Motor", Data(), UIImage(named: "massage_motor"), UIImage(named: "massage_motor_highlighted"), 6),
                             ExtraFunctions.under_bed_lighting: ("Under Bed Lighting", Data(), UIImage(named: "ublHRWhite"), UIImage(named: "ublHRHighlighted"), 7),
                             ExtraFunctions.light_strip: ("Light Strip", Data(), UIImage(named: "ublHRWhite"), UIImage(named: "ublHRHighlighted"), 8),
                             ExtraFunctions.seat_heating: ("Seat Heating", Data(), UIImage(named: "seat_heating"), UIImage(named: "seat_heating_highlighted"), 9),
                             ExtraFunctions.hands_free_kit: ("Hands Free Kit", Data(), UIImage(named: "hands_free_kit"), UIImage(named: "hands_free_kit_highlighted"), 10),
                             ExtraFunctions.rgb_lighting_strip: ("RGB Strip", Data(), UIImage(named: "rgb_strip"), UIImage(named: "rgb_strip_highlighted"), 11),
                             ExtraFunctions.rgb_lighting_control_unit: ("RGB Control Box", Data(), UIImage(named: "rgb_strip_controller"), UIImage(named: "rgb_strip_controller_highlighted"), 12),
                             //Default Handler
                             ExtraFunctions.NaN: ("NaN", Data(), UIImage(named: "NaN"), UIImage(named: "NaN_highlighted"), 13)]
    
    override func viewDidLoad() {
        self.device = globalDeviceObject
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        self.noFunctionsLabel.isHidden = true
        self.setStaticButtons()
        self.setDynamicButtons()
        
        self.scrollView.isScrollEnabled = true
        self.scrollView.isUserInteractionEnabled = true
        self.scrollView.contentSize = self.contentView.bounds.size
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func exploreButtonAction(_ sender: Any) {
        movetoExplore()
    }
    
    // Call this when Extras is empty and the user presses the explore button
    private func movetoExplore() {
        self.dismiss(animated: true) {
            if let tabbar = UIApplication.shared.keyWindow?.rootViewController as? MainViewController {
                tabbar.selectedIndex = 2
            }
        }
    }
    
    @objc
    func handleButtonPress(sender: UIButton!) {
        switch sender.tag{      // tag defines bluetoothfunction to call
        case 0:
            executeFunction(withHex: functionsMetadata[ExtraFunctions.massage_back]?.1 ?? Data())
        case 1:
            executeFunction(withHex: functionsMetadata[ExtraFunctions.massage_neck]?.1 ?? Data())
        case 2:
            executeFunction(withHex: functionsMetadata[ExtraFunctions.massage_legs]?.1 ?? Data())
        case 3:
            executeFunction(withHex: functionsMetadata[ExtraFunctions.ubl]?.1 ?? Data())
        case 4:
            executeFunction(withHex: functionsMetadata[ExtraFunctions.satellite_speaker]?.1 ?? Data())
        case 5:
            executeFunction(withHex: functionsMetadata[ExtraFunctions.subwoofer_speaker]?.1 ?? Data())
        case 6:
            executeFunction(withHex: functionsMetadata[ExtraFunctions.massage_motor]?.1 ?? Data())
        case 7:
            executeFunction(withHex: functionsMetadata[ExtraFunctions.under_bed_lighting]?.1 ?? Data())
        case 8:
            executeFunction(withHex: functionsMetadata[ExtraFunctions.light_strip]?.1 ?? Data())
        case 9:
            executeFunction(withHex: functionsMetadata[ExtraFunctions.seat_heating]?.1 ?? Data())
        case 10:
            executeFunction(withHex: functionsMetadata[ExtraFunctions.hands_free_kit]?.1 ?? Data())
        case 11:
            executeFunction(withHex: functionsMetadata[ExtraFunctions.rgb_lighting_strip]?.1 ?? Data())
        case 12:
            executeFunction(withHex: functionsMetadata[ExtraFunctions.rgb_lighting_control_unit]?.1 ?? Data())
        case 13:
            executeFunction(withHex: functionsMetadata[ExtraFunctions.NaN]?.1 ?? Data())
        default:
            print("something went wrong, can't find the correct function data")
        }
    }
    
    private func executeFunction(withHex hex: Data) {
        print("placehodler for bluetooth function with hexcode \(hex)")
    }
    
}
