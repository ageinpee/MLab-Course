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
    
    //----------------------------------------
    //------ Fancy Remote UI-Elements --------
    @IBOutlet weak var PresetsButtonObj: UIButton!
    @IBOutlet weak var AddPresetsButtonObj: UIButton!
    @IBOutlet weak var ExtraFunctionsButtonObj: UIButton!
    @IBOutlet weak var Image: UIImageView!
    
    
    //----------------------------------------
    //------ Fancy Remote Attributes ---------
    var oldTranslation = 0 //used to define in which direction the old translation was going

    
    //----------------------------------------
    //--------- Fancy Remote Setup -----------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("view loading")
        var width = PresetsButtonObj.frame.width
        PresetsButtonObj.layer.cornerRadius = width/2
        PresetsButtonObj.layer.masksToBounds = true
        PresetsButtonObj.layer.borderWidth = 1
        PresetsButtonObj.layer.borderColor = UIColor.gray.cgColor
        
        width = AddPresetsButtonObj.frame.width
        AddPresetsButtonObj.layer.cornerRadius = width/2
        AddPresetsButtonObj.layer.masksToBounds = true
        AddPresetsButtonObj.layer.borderWidth = 1
        AddPresetsButtonObj.layer.borderColor = UIColor.gray.cgColor
        
        let swipeRec = UISwipeGestureRecognizer(target: self, action: #selector(showOldRemote))
        swipeRec.direction = .up
        ExtraFunctionsButtonObj.addGestureRecognizer(swipeRec)
        
        width = ExtraFunctionsButtonObj.frame.width
        ExtraFunctionsButtonObj.layer.cornerRadius = width/2
        ExtraFunctionsButtonObj.layer.masksToBounds = true
        ExtraFunctionsButtonObj.layer.borderWidth = 1
        ExtraFunctionsButtonObj.layer.borderColor = UIColor.gray.cgColor
        
        Image.image = UIImage(named: "ChairNormal")
        Image.contentMode = .scaleAspectFit
        print("view loaded")
    }
    
    @objc
    private func showOldRemote() {
        print("Swipe recognized")
        let storyBoard: UIStoryboard = UIStoryboard(name: "OldRemote", bundle: nil)
        let newViewController = storyBoard.instantiateInitialViewController() as! OldRemoteViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
    //---------------------------------------
    //----- Fancy Design Remote Actions -----
    
    @IBAction func PresetsButton(_ sender: Any) {
        //shall open presets menu/page/sheet to select a preset
        let alert = UIAlertController(title: "Choose Preset", message: "", preferredStyle: .actionSheet)
        let preset1 = UIAlertAction(title: "Sleeping", style: .default, handler: nil)
        let preset2 = UIAlertAction(title: "Reading", style: .default, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(preset1)
        alert.addAction(preset2)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        print("Presets Button pressed")
    }
    
    @IBAction func AddPresetsButton(_ sender: Any) {
        //shall trigger both buttons that are used to save a preset
        print("Add Presets Button pressed")
    }
    
    @IBAction func ExtraFunctions(_ sender: Any) {
        //maybe a menu with extra functions like massage/ubl/torch etc...
        let alert = UIAlertController(title: "Choose Feature", message: "", preferredStyle: .actionSheet)
        let option1 = UIAlertAction(title: "Massage", style: .default, handler: nil)
        let option2 = UIAlertAction(title: "Under Bed Lighting", style: .default, handler: nil)
        let option3 = UIAlertAction(title: "Torch", style: .default, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(option1)
        alert.addAction(option2)
        alert.addAction(option3)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        print("Extra Functions Button pressed")
    }
    
    
    //-------------------------------------------------------------
    
    
    @IBAction func handlePan(recognizer: UIPanGestureRecognizer) {
        //translation defines the direction of the pan
        let translation = recognizer.translation(in: self.view)
        
        let viewWidth = self.view.frame.width
        let start = recognizer.location(in: self.view)
        
        if start.x <= viewWidth/2 {
            //-------------------------------------------
            //-- Status: Began --> Setup-phase for Pan --
            if recognizer.state == UIGestureRecognizer.State.began {
                if translation.y < 0 {
                    oldTranslation = 1
                    Image.image = UIImage(named: "ChairFeetUp")
                } else if translation.y >= 0 {
                    oldTranslation = -1
                    Image.image = UIImage(named: "ChairFeetDown")
                }
            }
            
            //-------------------------------------------
            //-- Status: Changed --> Pan in Action ------
            else if recognizer.state == UIGestureRecognizer.State.changed {
                if translation.y < 0 {
                    if oldTranslation == -1 {
                        Image.image = UIImage(named: "ChairFeetUp")
                    }
                    oldTranslation = 1
                    
                    // --> Placeholder <--
                    // Put Actuator Function for feet up here
                    // -------------------
                }
                
                else if translation.y >= 0 {
                    if oldTranslation == +1 {
                        Image.image = UIImage(named: "ChairFeetDown")
                    }
                    oldTranslation = -1
                    
                    // --> Placeholder <--
                    // Put Actuator Function for feet down here
                    // -------------------
                }
            }
            
            //--------------------------------------------------------------------------
            //-- Status: Ended --> Pan has ended. Reestablish starting-condition --
            else if recognizer.state == UIGestureRecognizer.State.ended {
                oldTranslation = 0 //set back to start-value
                Image.image = UIImage(named: "ChairNormal")
            }
        }
        else if start.x > viewWidth/2 {
            //-------------------------------------------
            //-- Status: Began --> Setup-phase for Pan --
            if recognizer.state == UIGestureRecognizer.State.began {
                if translation.y < 0 {
                    oldTranslation = 1
                    Image.image = UIImage(named: "ChairChestUp")
                } else if translation.y >= 0 {
                    oldTranslation = -1
                    Image.image = UIImage(named: "ChairChestDown")
                }
            }
                
                //-------------------------------------------
                //-- Status: Changed --> Pan in Action ------
            else if recognizer.state == UIGestureRecognizer.State.changed {
                if translation.y < 0 {
                    if oldTranslation == -1 {
                        Image.image = UIImage(named: "ChairChestUp")
                    }
                    oldTranslation = 1
                    
                    // --> Placeholder <--
                    // Put Actuator Function for feet up here
                    // -------------------
                }
                    
                else if translation.y >= 0 {
                    if oldTranslation == +1 {
                        Image.image = UIImage(named: "ChairChestDown")
                    }
                    oldTranslation = -1
                    
                    // --> Placeholder <--
                    // Put Actuator Function for feet down here
                    // -------------------
                }
            }
                
                //--------------------------------------------------------------------------
                //-- Status: Ended --> Pan has ended. Reestablish starting-condition --
            else if recognizer.state == UIGestureRecognizer.State.ended {
                oldTranslation = 0 //set back to start-value
                Image.image = UIImage(named: "ChairNormal")
            }
        }
    }
}

