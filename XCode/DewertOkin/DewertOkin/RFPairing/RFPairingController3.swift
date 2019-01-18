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

class RFPairingController3: UIViewController {
    
    @IBOutlet weak var dottedCircleImage: UIImageView!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet var pairingView: UIView!
    let backgroundView = UIView()
    
    @IBOutlet weak var remoteImageView: UIImageView!
    
    var devicesList = [Devices]()
    
    var selectedRemote: Remote = Remote()
    var device: DeviceObject = DeviceObject()
    
    var remoteImage: UIImage = UIImage()
    
    var remoteControl = RemoteController()
    var bluetooth = Bluetooth.sharedBluetooth
    lazy var bluetoothFlow = BluetoothFlow(bluetoothService: self.bluetooth)
    lazy var bluetoothBackgroundHandler = BluetoothBackgroundHandler(bluetoothService: self.bluetooth)
    
    override func viewDidLoad() {
        
        remoteImage = selectedRemote.image
        remoteImageView.image = remoteImage
        
        textLabel.text = "As soon as the Control Unit stops flashing, please press any button on your remote. Your device will be paired automatically afterwards."
        textLabel.textColor = UIColor.gray
        
        layoutConstraints()
        
        fetchDevices()
        
        let reader = CSVReader()
        let remoteData = reader.readCSV(fileName: "handsender1_extended", fileType: "csv")
        
        for row in remoteData {
            if row[0] == selectedRemote.id {
                device = DeviceObject(withUUID: UUID().uuidString, named: "New Device", withHandheldID: row[0], withStyle: DeviceStyle.empty.rawValue)
            }
        }
        
    }
    
    @objc
    private func dismissSelf() {
        //guard bluetoothBackgroundHandler.checkStatus() else { return }
        
        /*
         
        insert bluetooth pairing process
         
 
        saveDevice(withUUID: device.uuid, named: device.name, forHandheldID: device.handheldID, withStyle: device.style)
        */
        
        self.dismiss(animated: true)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.window = UIWindow(frame: UIScreen.main.bounds)
            delegate.window?.makeKeyAndVisible()
            delegate.window?.rootViewController = MainViewController()
        }
//        present(MainViewController(), animated: true, completion: nil)
        
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
    
    
    func saveDevice(withUUID: String, named: String, forHandheldID: String, withStyle: String) {
        let device = Devices(context: PersistenceService.context)
        device.uuid = withUUID
        device.name = named
        device.handheld = forHandheldID
        device.style = withStyle
        PersistenceService.saveContext()
    }
    
    
    
    func layoutConstraints() {
        remoteImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: remoteImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: pairingView.frame.height/2).isActive = true
        dottedCircleImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: dottedCircleImage, attribute: .top, relatedBy: .equal, toItem: pairingView, attribute: .top, multiplier: 1, constant: 3*(pairingView.frame.height/4)).isActive = true
        
        proceedButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
    }
}
