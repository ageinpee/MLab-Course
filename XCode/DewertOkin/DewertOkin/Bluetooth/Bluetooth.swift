//
//  Bluetooth.swift
//  BluetoothTest
//
//  Created by Nima Rahrakhshan on 02.12.18.
//  Copyright © 2018 Nima Rahrakhshan. All rights reserved.
//

import UIKit
import CoreBluetooth

class Bluetooth: NSObject {
    
    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    var availablePeripherals = [CBPeripheral]()
    var characteristics: [CBCharacteristic]!
    var characteristic: CBCharacteristic?
    var bluetoothState: CBManagerState { return self.centralManager.state }
    
    static var commandService = CBUUID(string: "62741523-52F9-8864-B1AB-3B3A8D65950B")
    static var keycodeUUID = CBUUID(string: "62741525-52F9-8864-B1AB-3B3A8D65950B")
    static var feedbackUUID = CBUUID(string: "62741625-52F9-8864-B1AB-3B3A8D65950B")
    static var remoteControl = RemoteController()
    
    var bluetoothCoordinator: BluetoothCoordinator?
    
    class var sharedBluetooth: Bluetooth {
        struct Static {
            static let instance = Bluetooth()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScan() {
        print("Starting to scan")
        self.connectedPeripheral = nil
        guard self.centralManager.state == .poweredOn else { return }
        self.centralManager.scanForPeripherals(withServices: [Bluetooth.commandService])
        self.bluetoothCoordinator?.scanStarted()
    }
    
    func stopScan() {
        print("Stopping scan")
        self.centralManager.stopScan()
        self.bluetoothCoordinator?.scanStopped()
    }
    
    func retrievePeripherals() -> [CBPeripheral] {
        guard self.centralManager.state == .poweredOn else { return [] }
        self.centralManager.scanForPeripherals(withServices: nil)
        let peripherals = availablePeripherals
        return peripherals
    }
    
    func connect() {
        print("Connecting to peripheral")
        guard self.centralManager.state == .poweredOn else { return }
        guard let peripheral = self.connectedPeripheral else { return }
        self.centralManager.connect(peripheral)
    }
    
    func disconnect() {
        print("Disconnecting from peripheral")
        guard let peripheral = self.connectedPeripheral else { return }
        self.centralManager.cancelPeripheralConnection(peripheral)
    }
}

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
        
        if !availablePeripherals.contains(peripheral){
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
        connectedPeripheral!.discoverServices([Bluetooth.commandService]);
        self.bluetoothCoordinator?.connected(peripheral: connectedPeripheral!)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from control unit")
        self.bluetoothCoordinator?.disconnected(failure: false)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Connection to control unit has failed!")
        // Give the user clear feedback in the UI
        self.bluetoothCoordinator?.disconnected(failure: true)
    }
}

extension Bluetooth: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            if(service.uuid == Bluetooth.commandService){
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        // Now we have fetched all the data
        for characteristic in characteristics {
            //            if characteristic.properties.contains(.read) {
            //                peripheral.readValue(for: characteristic)
            //                print("Successfully read characteristic")
            //            }
            //            if characteristic.properties.contains(.notify) {
            //                peripheral.setNotifyValue(true, for: characteristic)
            //                print("Successfully subscribed characteristic")
            //            }
            if(characteristic.uuid == Bluetooth.keycodeUUID){
                peripheral.setNotifyValue(true, for: characteristic)
                self.characteristic = characteristic
                self.bluetoothCoordinator?.ableToWrite() // Here or in didUpdateValueFor?
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Updating value")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Data successfully updated")
    }
}

extension Bluetooth {
    func getCharacteristics() {
        self.connectedPeripheral?.readValue(for: self.characteristic!)
    }
}
