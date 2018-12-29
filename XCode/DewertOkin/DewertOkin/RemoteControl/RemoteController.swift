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


class RemoteController: UIViewController, UIGestureRecognizerDelegate, Themeable{
    
    //----------------------------------------
    //------ Fancy Remote UI-Elements --------
    @IBOutlet weak var PresetsButtonObj: UIButton!
    @IBOutlet weak var AddPresetsButtonObj: UIButton!
    @IBOutlet weak var ExtraFunctionsButtonObj: UIButton!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var arrowsImageView: UIImageView!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var leftPanArea: UIView!
    @IBOutlet weak var rightPanArea: UIView!
    @IBOutlet weak var currentDeviceLabel: UILabel!
    
    //----------------------------------------
    //------ Fancy Remote Attributes ---------
    var oldTranslation = 0 //used to define in which direction the old translation was going
    var panState = UIGestureRecognizer.State.ended
    let filledStyle = deviceStyle(withStrings: ["chair_full_normal",
                                                "chair_full_chestUp",
                                                "chair_full_chestDown",
                                                "chair_full_feetUp",
                                                "chair_full_feetDown"])
    let emptyStyle = deviceStyle(withStrings: ["chair_empty_normal",
                                               "chair_empty_chestUp",
                                               "chair_empty_chestDown",
                                               "chair_empty_feetUp",
                                               "chair_empty_feetDown"])
    var currentStyle: deviceStyle = deviceStyle()
    var opacity = CGFloat(0.75)
    
    //----------------------------------------
    //--------- Fancy Remote Setup -----------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bluetooth.bluetoothCoordinator = self.bluetoothFlow
        
        currentStyle = filledStyle
        setupButtons()
        setupPanAreas()
        
        Themes.setupTheming(for: self)

        Health.requestHealthKitPermission()
        
        let swipeRec = UISwipeGestureRecognizer(target: self, action: #selector(showOldRemote))
        swipeRec.direction = .up
        ExtraFunctionsButtonObj.addGestureRecognizer(swipeRec)
        
        AddPresetsButtonObj.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(displaySteps)))
        
        Image.image = currentStyle.stylesImages[0]
        Image.contentMode = .scaleAspectFit
    }
    
    override func viewDidAppear(_ animated: Bool) {
        arrowsImageView.alpha = 0
        animateFade(withAlpha: opacity)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    var statusBarStyle: UIStatusBarStyle = .default
    func setDarkTheme() {
        self.view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        
        //self.view.backgroundColor = UIColor.gray
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.tabBarController?.tabBar.barStyle = UIBarStyle.black
        statusBarStyle = .lightContent
        self.currentDeviceLabel.textColor = .white
        self.stepsLabel.textColor = .white
        self.PresetsButtonObj.setTitleColor(UIColor.orange, for: .normal)
        self.AddPresetsButtonObj.setTitleColor(UIColor.orange, for: .normal)
        self.ExtraFunctionsButtonObj.setTitleColor(UIColor.orange, for: .normal)
    }
    
    func setDefaultTheme() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.largeTitleTextAttributes = nil
        self.navigationController?.navigationBar.titleTextAttributes = nil
        self.navigationController?.navigationBar.tintColor = nil
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.tabBarController?.tabBar.barStyle = UIBarStyle.default
        statusBarStyle = .default
        self.currentDeviceLabel.textColor = .black
        self.stepsLabel.textColor = .black
        self.PresetsButtonObj.setTitleColor(nil, for: .normal)
        self.AddPresetsButtonObj.setTitleColor(nil, for: .normal)
        self.ExtraFunctionsButtonObj.setTitleColor(nil, for: .normal)
    }
    
    @objc func darkModeEnabled(_ notification: Notification) {
        setDarkTheme()
    }
    
    @objc func darkModeDisabled(_ notification: Notification) {
        setDefaultTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
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
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(option1)
        alert.addAction(option2)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        print("Extra Functions Button pressed")
    }
    
    
    //-------------------------------------------------------------
    
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
    
    func goUp() {
        guard self.bluetooth.bluetoothState == .poweredOn else { return }
        guard bluetoothFlow.paired else { return }
        guard !(self.characteristic == nil) else {
            self.characteristic = self.bluetooth.characteristic
            return
        }
        let moveUp = self.remoteControlConfig.getKeycode(name: keycode.m1In)
        bluetooth.connectedPeripheral!.writeValue(moveUp, for: characteristic!, type: CBCharacteristicWriteType.withResponse)
    }
    
    func goDown() {
        guard self.bluetooth.bluetoothState == .poweredOn else { return }
        guard bluetoothFlow.paired else { return }
        guard !(self.characteristic == nil) else {
            self.characteristic = self.bluetooth.characteristic
            return
        }
        let moveDown = self.remoteControlConfig.getKeycode(name: keycode.m1Out)
        bluetooth.connectedPeripheral!.writeValue(moveDown, for: characteristic!, type: CBCharacteristicWriteType.withResponse)
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

