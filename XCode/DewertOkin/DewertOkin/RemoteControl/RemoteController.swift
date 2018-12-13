//
//  RemoteController.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 29.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit
import HealthKit
import CoreBluetooth


class RemoteController: UIViewController{
    
    //----------------------------------------
    //------ Fancy Remote UI-Elements --------
    @IBOutlet weak var PresetsButtonObj: UIButton!
    @IBOutlet weak var AddPresetsButtonObj: UIButton!
    @IBOutlet weak var ExtraFunctionsButtonObj: UIButton!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var stepsLabel: UILabel!
    
    //----------------------------------------
    //------ Fancy Remote Attributes ---------
    var oldTranslation = 0 //used to define in which direction the old translation was going
    var panState = UIGestureRecognizer.State.ended

    
    //----------------------------------------
    //--------- Fancy Remote Setup -----------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("view loading")
        
        self.bluetooth.bluetoothCoordinator = self.bluetoothFlow
        setupButtons()
        
        Health.requestHealthKitPermission()
        
        let swipeRec = UISwipeGestureRecognizer(target: self, action: #selector(showOldRemote))
        swipeRec.direction = .up
        ExtraFunctionsButtonObj.addGestureRecognizer(swipeRec)
        
        AddPresetsButtonObj.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(displaySteps)))
        
        Image.image = UIImage(named: "ChairNormal")
        Image.contentMode = .scaleAspectFit
        //print("view loaded")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.checkBluetoothState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    private func setupButtons() {
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
        
        width = ExtraFunctionsButtonObj.frame.width
        ExtraFunctionsButtonObj.layer.cornerRadius = width/2
        ExtraFunctionsButtonObj.layer.masksToBounds = true
        ExtraFunctionsButtonObj.layer.borderWidth = 1
        ExtraFunctionsButtonObj.layer.borderColor = UIColor.gray.cgColor
    }
    
    @objc
    private func showOldRemote() {
        print("Swipe recognized")
        let storyBoard: UIStoryboard = UIStoryboard(name: "OldRemote", bundle: nil)
        let newViewController = storyBoard.instantiateInitialViewController() as! OldRemoteViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    //---------------------------------------
    //----- Bluetooth Dependencies ----------
    var remoteControlConfig = RemoteControlConfig()
    var bluetooth = Bluetooth.sharedBluetooth
    lazy var bluetoothFlow = BluetoothFlow(bluetoothService: self.bluetooth)
    var peripheral: CBPeripheral?
    var characteristic: CBCharacteristic?
    var paired = false
    
    
    //---------------------------------------
    //----- Fancy Design Remote Actions -----
    
    var underBedLighting: UIAlertAction?
    
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
        underBedLighting = option2
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
        let viewHeight = self.view.frame.height
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
                if recognizer.location(in: self.view).y < viewHeight/2 {
                    if oldTranslation == -1 {
                        Image.image = UIImage(named: "ChairFeetUp")
                    }
                    oldTranslation = 1
                    
//                    goUpFeet()
                    print("FeetUp", Int.random(in: 1...100))
                }
                else if recognizer.location(in: self.view).y >= viewHeight/2 {
                    if oldTranslation == +1 {
                        Image.image = UIImage(named: "ChairFeetDown")
                    }
                    oldTranslation = -1
                    
//                    goDownFeet()
                    print("FeetDown", Int.random(in: 1...100))
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
                    
                    goUp()
                    //print("ChestUp", Int.random(in:1...100))
                }
                    
                else if translation.y >= 0 {
                    if oldTranslation == +1 {
                        Image.image = UIImage(named: "ChairChestDown")
                    }
                    oldTranslation = -1
                    
                    goDown()
                    //print("ChestDown", Int.random(in: 1...100))
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
    
    //-------------------------------------------
    //------ Bluetooth related functions --------
    private func Connect() {
        self.bluetoothFlow.waitForPeripheral {
            self.bluetoothFlow.pair { result in
                self.peripheral = self.bluetooth.connectedPeripheral
                self.characteristic = self.bluetooth.characteristic
                self.paired = true
            }
        }
    }
    
    
    private func checkBluetoothState() {
        if self.bluetooth.bluetoothState != .poweredOn {
            DispatchQueue.main.asyncAfter(deadline: .now()+2){
                self.checkBluetoothState()
            }
        }
    }
    
    func goUp() {
        guard self.bluetooth.bluetoothState == .poweredOn else { return }
        guard self.paired else {
            Connect()
            return
        }
        guard !(self.characteristic == nil) else {
            self.characteristic = self.bluetooth.characteristic
            return
        }
        let moveUp = self.remoteControlConfig.getKeycode(name: keycode.m1In)
        peripheral?.writeValue(moveUp, for: characteristic!, type: CBCharacteristicWriteType.withResponse)
    }
    
    func goDown() {
        guard self.bluetooth.bluetoothState == .poweredOn else { return }
        guard self.paired else {
            Connect()
            return
        }
        guard !(self.characteristic == nil) else {
            self.characteristic = self.bluetooth.characteristic
            return
        }
        let moveDown = self.remoteControlConfig.getKeycode(name: keycode.m1Out)
        peripheral!.writeValue(moveDown, for: characteristic!, type: CBCharacteristicWriteType.withResponse)
    }
    
//    func goUpFeet() {
//        guard self.bluetooth.bluetoothState == .poweredOn else {return}
//        let moveUp = self.remoteControlConfig.getKeycode(name: keycode.m2In)
//        peripheral?.writeValue(moveUp, for: characteristic!, type: CBCharacteristicWriteType.withResponse)
//    }
//
//    func goDownFeet() {
//        guard self.bluetooth.bluetoothState == .poweredOn else {return}
//        let moveUp = self.remoteControlConfig.getKeycode(name: keycode.m2Out)
//        peripheral?.writeValue(moveUp, for: characteristic!, type: CBCharacteristicWriteType.withResponse)
//    }
    
    
    //-------------------------------------------
    //--------                          ---------
    
    @objc
    private func displaySteps() {
        guard Health.healthStore.authorizationStatus(for: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!) == .sharingAuthorized else { return }
        Health.getLastHoursSteps { (result) in
            print(result)
            DispatchQueue.main.async {
                self.stepsLabel.text = "❤️ \(Int(result))"
            }
        }
    }
}

