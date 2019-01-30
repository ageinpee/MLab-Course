//
//  BluetoothCentral.swift
//  DewertOkin
//
//  Created by Nima Rahrakhshan on 15.12.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import Foundation
import CoreBluetooth

extension Bluetooth: CBCentralManagerDelegate {
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("The state is unkown")
        case .resetting:
            print("The system is resetting its state")
        case .unsupported:
            print("The state is unsupported")
        case .unauthorized:
            print("The state is unauthorized")
        case .poweredOff:
            print("The systems bluetooth is turned off")
            self.stopScan()
            self.disconnect()
        // Tell the user to power on bluetooth
        case .poweredOn:
            print("The systems bluetooth is turned on")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if (!availablePeripherals.contains(peripheral)){
            availablePeripherals.append(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connection to control unit established")
        connectedPeripheral = peripheral
        connectedPeripheral!.delegate = self
        
        if !(onceConnectedPeripherals.contains(peripheral.identifier.uuidString)) {
        onceConnectedPeripherals.append(peripheral.identifier.uuidString)
        saveDevice(peripheral: peripheral)
        }
        
//        globalDeviceObject = DeviceObject(withUUID: self.connectedPeripheral?.identifier.uuidString ?? "ERROR - no entry found",
//                                          named: self.connectedPeripheral?.name ?? "ERROR - no entry found",
//                                          withHandheldID: self.devicesList[indexPath.row].handheld ?? "NaN",
//                                          withStyle: self.devicesList[indexPath.row].style ?? "filled",
//                                          withExtraFunctions: DeviceObject.convertStringToExtraFunctions(withString: self.devicesList[indexPath.row].extraFunctions ?? ""))
//        UserDefaults.standard.set(globalDeviceObject.uuid, forKey: "lastConnectedDevice_uuid")
        
        defaults.set(onceConnectedPeripherals, forKey: "Peripherals")
        connectedPeripheral!.discoverServices([Bluetooth.commandService])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from control unit")
        self.bluetoothCoordinator?.disconnected(failure: false)
        connectedPeripheral = nil
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Connection to control unit has failed!")
        // Give the user clear feedback in the UI
        self.bluetoothCoordinator?.disconnected(failure: true)
        connectedPeripheral = nil
    }
        
    func saveDevice(peripheral: CBPeripheral) {
        let device = Devices(context: PersistenceService.context)
        device.name = peripheral.name
        device.type = peripheral.description
        device.uuid = peripheral.identifier.uuidString
        PersistenceService.saveContext()
    }
    
}
