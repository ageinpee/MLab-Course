//
//  RFPairingController3.swift
//  DewertOkin
//
//  Created by MacBook-Benutzer on 27.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
import CoreData

class RFPairingController3: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var dottedCircleImage: UIImageView!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var deviceNameTextfield: UITextField!
    
    @IBOutlet var pairingView: UIView!
    let backgroundView = UIView()
    
    @IBOutlet weak var remoteImageView: UIImageView!
    
    var devicesList = [Devices]()
    
    var selectedRemote: Remote = Remote()
    var device: DeviceObject = DeviceObject()
    
    var remoteImage: UIImage = UIImage()
    private var failCounter = 0
    
    var remoteControl = RemoteController()
    
    override func viewDidLoad() {
        
        remoteImage = selectedRemote.image
        remoteImageView.image = remoteImage
        
        textLabel.text = "As soon as the Control Unit stops flashing, please press any button on your remote. Your device will be paired automatically afterwards."
        textLabel.textColor = UIColor.gray
        
        layoutConstraints()
        
        fetchDevices()
        
        deviceNameTextfield.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.view.removeFromSuperview()
    }
    
    @IBAction func ProceedAction(_ sender: Any) {
        failCounter = failCounter+1
        
        if failCounter == 3 {
            failCounter = 0
            let renameController = UIAlertController(title: "Connecting failed", message: "Maybe try to turn on Bluetooth?", preferredStyle: .alert)
            
            renameController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                UIView.animate(withDuration: 1.0, animations: {
                    self.view.alpha = 0
                }) { (_) in
                    UIApplication.shared.keyWindow?.rootViewController = MainViewController()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {self.view.removeFromSuperview()})
                }
            }))
            self.present(renameController, animated: true, completion: {
                
            })
        }
 
        let reader = CSVReader()
        let remoteData = reader.readCSV(fileName: "handsender1_extended", fileType: "csv")
    
        for row in remoteData {
            if row[0] == selectedRemote.id {
                device = DeviceObject(withUUID: UUID().uuidString, named: "New Device", withHandheldID: row[0], withStyle: DeviceStyle.filled.rawValue)
                break
            }
        }
 
        device.name = "New Device"
        if deviceNameTextfield.text! != "" {
            device.name = deviceNameTextfield.text!
        }
        
        saveDevice(withUUID: device.uuid,
                   named: device.name,
                   forHandheldID: device.handheldID,
                   withStyle: device.style,
                   withExtraFucntions: DeviceObject.convertExtraFunctionsToString(functions: device.availableExtraFunctions))
 
        
        globalDeviceObject = device
        UserDefaults.standard.set(globalDeviceObject.uuid, forKey: "lastConnectedDevice_uuid")
        
        UIView.animate(withDuration: 1.0, animations: {
            self.view.alpha = 0
        }) { (_) in
            UIApplication.shared.keyWindow?.rootViewController = MainViewController()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {self.view.removeFromSuperview()})
            if let transition = NSClassFromString("UITransitionView") {
                for subview in self.view.subviews where subview.isKind(of: transition) {
                    subview.removeFromSuperview()
                }
            }
        }
    
    }
    
    func fetchDevices() {
        let fetchRequest: NSFetchRequest<Devices> = Devices.fetchRequest()
        
        do {
            let savedDevices = try PersistenceService.context.fetch(fetchRequest)
            self.devicesList = savedDevices
        } catch {
            print("Couldn't update the Devices, reload!")
        }
    }
    
    
    func saveDevice(withUUID: String, named: String, forHandheldID: String, withStyle: String, withExtraFucntions: String) {
        let device = Devices(context: PersistenceService.context)
        device.uuid = withUUID
        device.name = named
        device.handheld = forHandheldID
        device.style = withStyle
        device.extraFunctions = withExtraFucntions
        PersistenceService.saveContext()
    }
    
    
    
    func layoutConstraints() {
        remoteImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: remoteImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: pairingView.frame.height/2).isActive = true
        dottedCircleImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: dottedCircleImage, attribute: .top, relatedBy: .equal, toItem: pairingView, attribute: .top, multiplier: 1, constant: 3*(pairingView.frame.height/4)).isActive = true
        
        //proceedButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        print("Too much load")
    }
}
