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
            self.bluetoothCoordinator?.bluetoothOff()
        // Tell the user to power on bluetooth
        case .poweredOn:
            print("The systems bluetooth is turned on")
            self.bluetoothCoordinator?.bluetoothOn()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if (!availablePeripherals.contains(peripheral)){
            availablePeripherals.append(peripheral)
        }
        
        // This is not good practice, we should match it with the UUID (Can't implement it, since I dont have access to it rn)
        let deviceName = peripheral.name ?? ""
        if (isOkinDevice(name:deviceName)){
            connectedPeripheral = peripheral;
            self.bluetoothCoordinator?.discoveredPeripheral()
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
        connectedPeripheral!.delegate = self
        peripheralsList?.append(peripheral.identifier)
        connectedPeripheral!.discoverServices([Bluetooth.commandService]);
        //self.bluetoothCoordinator?.connected(peripheral: connectedPeripheral!)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from control unit")
        self.bluetoothCoordinator?.disconnected(failure: false)
        //self.bluetoothCoordinator?.reconnect()
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Connection to control unit has failed!")
        // Give the user clear feedback in the UI
        self.bluetoothCoordinator?.disconnected(failure: true)
        //self.bluetoothCoordinator?.reconnect()
    }
    
    
}
