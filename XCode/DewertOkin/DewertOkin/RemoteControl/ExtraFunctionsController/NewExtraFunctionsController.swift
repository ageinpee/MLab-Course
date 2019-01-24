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
    

    
    var functionsMetadata = [ExtraFunctions.massage_back: ("Massage Back", Data(), UIImage(named: "massageBackHRWhiteCurly"), UIImage(named: "massageBackHRCurlyHighlighted")),
                             ExtraFunctions.massage_neck: ("Massage Neck", Data(), UIImage(named: "massageNeckHRWhiteCurly"), UIImage(named: "massageNeckHRCurlyHighlighted")),
                             ExtraFunctions.massage_legs: ("Massage Legs", Data(), UIImage(named: "massageLegHRWhiteCurly"), UIImage(named: "massageLegHRCurlyHighlighted")),
                             ExtraFunctions.ubl: ("Under Bed Lighting", Data(), UIImage(named: "ublHRWhite"), UIImage(named: "ublHRHighlighted")),
                             //Extrafunctions from Explore
                             ExtraFunctions.satellite_speaker: ("Satellite Speaker", Data(), UIImage(named: ""), UIImage(named: "")),
                             ExtraFunctions.subwoofer_speaker: ("Subwoofer Speaker", Data(), UIImage(named: ""), UIImage(named: "")),
                             ExtraFunctions.massage_motor: ("Massage Motor", Data(), UIImage(named: ""), UIImage(named: "")),
                             ExtraFunctions.under_bed_lighting: ("Under Bed Lighting", Data(), UIImage(named: ""), UIImage(named: "")),
                             ExtraFunctions.light_strip: ("Light Strip", Data(), UIImage(named: ""), UIImage(named: "")),
                             ExtraFunctions.seat_heating: ("Seat Heating", Data(), UIImage(named: ""), UIImage(named: "")),
                             ExtraFunctions.hands_free_kit: ("Hands Free Kit", Data(), UIImage(named: ""), UIImage(named: "")),
                             ExtraFunctions.rgb_lighting_strip: ("RGB Strip", Data(), UIImage(named: ""), UIImage(named: "")),
                             ExtraFunctions.rgb_lighting_control_unit: ("RGB Control Box", Data(), UIImage(named: ""), UIImage(named: "")),
                             //Default Handler
                             ExtraFunctions.NaN: ("NaN", Data(), UIImage(named: ""), UIImage(named: ""))]
    
    override func viewDidLoad() {
        self.device = globalDeviceObject
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        self.noFunctionsLabel.isHidden = true
        setStaticButtons()
        setDynamicButtons()
        
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
    
    
    
    
    
    
    private func setStaticButtons() {
        self.backButton.layer.borderColor = UIColor.white.cgColor
        self.backButton.layer.borderWidth = 1
        self.backButton.layer.cornerRadius = 10
        
        self.exploreButton.layer.borderColor = UIColor.white.cgColor
        self.exploreButton.layer.borderWidth = 1
        self.exploreButton.layer.cornerRadius = 10
        self.exploreButton.isHidden = true
    }
    
    
    
    
    
    private func setDynamicButtons() {
        if self.device.availableExtraFunctions.count == 0 {
            self.exploreButton.isHidden = false
            self.noFunctionsLabel.isHidden = false
        }
        else if self.device.availableExtraFunctions.count == 1 {
            let button = styleButton(withFunction: self.device.availableExtraFunctions[0],
                                     imageSize: CGSize(width: 100, height: 100))
            button.tag = 0
            
            contentView.addSubview(button)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: contentView.superview, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: contentView.superview, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: contentView.frame.width/3).isActive = true
            NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: contentView.frame.width/3).isActive = true
            
            //button.addTarget(self, action: #selector(handleButtonPress), for: .touchDown)
        }
        else if self.device.availableExtraFunctions.count > 1 {
            
        }
    }
    
    
    private func styleButton(withFunction: ExtraFunctions, imageSize: CGSize) -> UIButton {
        let button = UIButton()
        button.setTitle(functionsMetadata[withFunction]?.0, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: self.view.frame.width/23)
        button.titleEdgeInsets = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping
        
        var image = functionsMetadata[withFunction]?.2
        var imageHighlighted = functionsMetadata[withFunction]?.3
        image = image?.resize(size: imageSize)
        imageHighlighted = imageHighlighted?.resize(size: imageSize)
        button.setBackgroundImage(image, for: .normal)
        button.setBackgroundImage(imageHighlighted, for: .highlighted)
        
        return button
    }
    
}
