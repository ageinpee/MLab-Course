//
//  OldRemoteViewController.swift
//  DewertOkin
//
//  Created by Jan Robert on 03.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import UIKit
import CoreBluetooth

class OldRemoteViewController: UIViewController {
    
    @IBOutlet weak var remoteView: UIView!
    @IBOutlet weak var deviceNameLabel: UILabel!
    
    @IBOutlet weak var backUpButton: UIButton!
    @IBOutlet weak var backDownButton: UIButton!
    @IBOutlet weak var feetUpButton: UIButton!
    @IBOutlet weak var feetDownButton: UIButton!
    @IBOutlet weak var bothUpButton: UIButton!
    @IBOutlet weak var bothDownButton: UIButton!
    @IBOutlet weak var memory1Button: UIButton!
    @IBOutlet weak var memory2Button: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var ublButton: UIButton!
    @IBOutlet weak var torchButton: UIButton!
    
    var buttonList: [UIButton] = [UIButton]()
    var buttonList2: [UIButton] = [UIButton]()
    
    //Bluetooth Dependencies
    var remoteControlConfig = RemoteControlConfig()
    var bluetooth = Bluetooth.sharedBluetooth
    lazy var bluetoothFlow = BluetoothFlow(bluetoothService: self.bluetooth)
    lazy var bluetoothBackgroundHandler = BluetoothBackgroundHandler(bluetoothService: self.bluetooth)
    var peripheral: CBPeripheral?
    var characteristic: CBCharacteristic?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonList = [backUpButton, backDownButton,
                      feetUpButton, feetDownButton,
                      bothUpButton, bothDownButton,
                      memory1Button, memory2Button,
                      saveButton, ublButton,
                      torchButton]
        self.buttonList2 = [backUpButton, backDownButton,
                       feetUpButton, feetDownButton,
                       bothUpButton, bothDownButton,
                       memory1Button, memory2Button,
                       saveButton, ublButton]
        
        constrainButtons()
        
        self.deviceNameLabel.text = globalDeviceObject.name
        self.bluetooth.bluetoothCoordinator = self.bluetoothFlow
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //checkBluetoothConnectivity()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    lazy var noConnectionBanner: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: -90, width: self.view.frame.width, height: 80))
        view.backgroundColor = .red
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 12.0
        view.layer.shadowOpacity = 0.7
        return view
    }()
    
    let noConnectionLabel: UILabel = {
        let label = UILabel()
        label.text = "No device connected."
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func checkBluetoothConnectivity() {
        if !bluetoothBackgroundHandler.checkStatus() {
            showNoConnectionBanner()
        } else {
            dismissNoConnectionBanner()
        }
    }
    
    private func showNoConnectionBanner() {
        guard !self.view.subviews.contains(noConnectionBanner) else {return}
        self.view.addSubview(noConnectionBanner)
        noConnectionBanner.addSubview(noConnectionLabel)
        noConnectionBanner.addConstraint(NSLayoutConstraint.init(item: noConnectionLabel, attribute: .centerX, relatedBy: .equal, toItem: noConnectionBanner, attribute: .centerX, multiplier: 1, constant: 0))
        noConnectionBanner.addConstraint(NSLayoutConstraint.init(item: noConnectionLabel, attribute: .centerY, relatedBy: .equal, toItem: noConnectionBanner, attribute: .centerY, multiplier: 3/2, constant: 0))
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.noConnectionBanner.transform = CGAffineTransform.init(translationX: 0, y: 80)
        }) { (_) in
        }
    }
    
    private func dismissNoConnectionBanner() {
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.noConnectionBanner.transform = CGAffineTransform.init(translationX: 0, y: -80)
        }) { (_) in
            self.noConnectionBanner.removeFromSuperview()
        }
    }
    
    func moveHeadUp() {
        guard bluetoothBackgroundHandler.checkStatus() else { return }
        self.characteristic = self.bluetooth.writeCharacteristic
        triggerCommand(keycode: keycode.m1In)
    }
    
    func moveHeadDown() {
        guard bluetoothBackgroundHandler.checkStatus() else { return }
        self.characteristic = self.bluetooth.writeCharacteristic
        triggerCommand(keycode: keycode.m1Out)
    }
    
    func moveFeetUp() {
        guard bluetoothBackgroundHandler.checkStatus() else { return }
        self.characteristic = self.bluetooth.writeCharacteristic
        triggerCommand(keycode: keycode.m4In)
    }
    
    func moveFeetDown() {
        guard bluetoothBackgroundHandler.checkStatus() else { return }
        self.characteristic = self.bluetooth.writeCharacteristic
        triggerCommand(keycode: keycode.m4Out)
    }
    
    func triggerCommand(keycode: keycode) {
        let movement = self.remoteControlConfig.getKeycode(name: keycode)
        bluetooth.connectedPeripheral!.writeValue(movement, for: characteristic!, type: CBCharacteristicWriteType.withResponse)
        
    }
    
    func constrainButtons() {
        
        guard let superView = remoteView.superview else { return }
        
        let frameWidth = superView.frame.width
        let frameHeight = superView.frame.height
        
        let initialOffset = frameHeight/14
        var offset = frameHeight/14
        var rowCount = 0
        
        
        for button in buttonList {
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frameWidth/5.83).isActive = true
            NSLayoutConstraint(item: button, attribute: .height
                , relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frameHeight/18.66).isActive = true
            NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: remoteView, attribute: .top, multiplier: 1, constant: offset).isActive = true
            
            if rowCount%2 != 0 {
                offset = offset + initialOffset
            }
            rowCount = rowCount+1
        }
        
        var flagLeftRight = true //true == left, false == right
        for button in buttonList2 {
            if flagLeftRight {
                
                NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: remoteView, attribute: .centerX, multiplier: 1, constant: (frameWidth/4.06)-40).isActive = true
                
                flagLeftRight = false
                
            } else {
                
                NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: remoteView, attribute: .centerX, multiplier: 1, constant: -(frameWidth/4.06)+40).isActive = true
                
                flagLeftRight = true
            }
        }
        
        NSLayoutConstraint(item: torchButton, attribute: .centerX, relatedBy: .equal, toItem: remoteView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    
    @IBAction func backUpAction(_ sender: Any) {
        moveHeadUp()
    }
    
    @IBAction func backDownAction(_ sender: Any) {
        moveHeadDown()
    }
    
    @IBAction func feetUpAction(_ sender: Any) {
        moveFeetUp()
    }
    
    @IBAction func feetDownAction(_ sender: Any) {
        moveFeetDown()
    }
    
    @IBAction func bothUpAction(_ sender: Any) {
        
    }
    
    @IBAction func bothDownAction(_ sender: Any) {
        
    }
    
    @IBAction func memory1Action(_ sender: Any) {
        
    }
    
    @IBAction func memory2Action(_ sender: Any) {
        
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
    }
    
    @IBAction func ublAction(_ sender: Any) {
        
    }
    
    @IBAction func torchAction(_ sender: Any) {
        
    }
    
}
