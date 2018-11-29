//
//  RemoteControlController.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 19.11.18.
//  Copyright © 2018 Nima Rahrakhshan. All rights reserved.
//

import UIKit
import CoreBluetooth

class RemoteControlController: UIViewController {
    
    fileprivate var discoveredPeripheral: CBPeripheral?
    
    var centralManager: CBCentralManager!
    var dewertOkinControllerPeripheral: CBPeripheral!
    var commandService = CBUUID(string: "62741523-52F9-8864-B1AB-3B3A8D65950B")
    var keycodeUUID = CBUUID(string: "62741525-52F9-8864-B1AB-3B3A8D65950B")
    var feedbackUUID = CBUUID(string: "62741625-52F9-8864-B1AB-3B3A8D65950B")
    var csService = CBUUID(string: "90311623-25FA-3346-12EF-FB7A2556AC")
    var csCommandUUID = CBUUID(string: "90311625-25FA-3346-12EF-FB7A2556AC")
    var csFeedbackUUID = CBUUID(string: "90311725-25FA-3346-12EF-FB7A2556AC")
    var remoteControl = RemoteControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // Memory warning, possible overload?
    override func didReceiveMemoryWarning() {
        print("There is an overload!")
        super.didReceiveMemoryWarning()
    }
}

extension RemoteControlController: CBCentralManagerDelegate {
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("The statee is unkown")
        case .resetting:
            print("The system is resetting its state")
        case .unsupported:
            print("The state is unsupported")
        case .unauthorized:
            print("The state is unauthorized")
        case .poweredOff:
            print("The systems bluetooth is turned off")
        // Tell the user to power on bluetooth
        case .poweredOn:
            print("The systems bluetooth is turned on")
            centralManager.scanForPeripherals(withServices: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if RSSI.intValue < -15 && RSSI.intValue > -35 {
            print("Device is not in range")
            // Error Message on UI
        }
        
        
        // This is not good practice, we should match it with the UUID (Can't implement it, since I dont have access to it rn)
        print("Discovered \(peripheral.name!) at range \(RSSI)")
        let deviceName = peripheral.name ?? ""
        if (isOkinDevice(name:deviceName)){
            dewertOkinControllerPeripheral = peripheral;
            dewertOkinControllerPeripheral.delegate = self
            central.stopScan()
            central.connect(dewertOkinControllerPeripheral)
        }
    }
    
    // This should be deleted after the didDiscover function was reworked
    func isOkinDevice(name: String) -> Bool {
        if (name.lowercased().range(of:"okin") != nil) {
            print("The Dewert Okin device was found")
            return true;
        }
        
        return false;
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connection to control unit established")
        dewertOkinControllerPeripheral.discoverServices(nil);
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Connection to control unit has failed!")
        // Give the user clear feedback in the UI
    }
}

extension RemoteControlController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            print("Error discovering the services: \(error!.localizedDescription)")
            return
        }
        
        guard let services = peripheral.services else { return }
        
        for service in services {
            if(service.uuid == commandService){
                peripheral.discoverCharacteristics(nil, for: service) // Can I call if only for commandService?
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil else {
            print("Error discovering the characteristics: \(error!.localizedDescription)")
            return
        }
        
        guard let characteristics = service.characteristics else { return }
        
        // Now we have fetched all the data
        for characteristic in characteristics {
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error updating the characteristics: \(error!.localizedDescription)")
            return
        }
        
        guard NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue) != nil else {
            print("Invalid data")
            return
        }
        
        if(characteristic.uuid == keycodeUUID) {
            let moveUp = remoteControl.getKeycode(name: keycode.m1Out)
            peripheral.writeValue(moveUp, for: characteristic, type: CBCharacteristicWriteType.withResponse)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if(characteristic.isNotifying) {
            print("Notification began on \(characteristic)")
        } else {
            print("Notification stopped on \(characteristic)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        print("The device is now disconnected")
        discoveredPeripheral = nil
        centralManagerDidUpdateState(centralManager)
    }
}
