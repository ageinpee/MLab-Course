//
//  Bluetooth.swift
//  BluetoothTest
//
//  Created by Nima Rahrakhshan on 02.12.18.
//  Copyright © 2018 Nima Rahrakhshan. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreData

class Bluetooth: NSObject {
    
    let defaults = UserDefaults.standard
    var onceConnectedPeripherals = [String]()
    
    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    var availablePeripherals = [CBPeripheral]()
    var writeCharacteristic: CBCharacteristic?
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
        onceConnectedPeripherals = defaults.stringArray(forKey: "Peripherals") ?? []
    }
    
    func startScan() {
        print("Starting to scan")
        guard self.centralManager.state == .poweredOn else { return }
        self.connectedPeripheral = nil
        //self.availablePeripherals = []
        self.centralManager.scanForPeripherals(withServices: [Bluetooth.commandService])
    }
    
    func stopScan() {
        print("Stopping scan")
        self.centralManager.stopScan()
    }
    
    func retrievePeripherals() -> [CBPeripheral] {
        print("Returning all advertising peripherals")
        guard self.centralManager.state == .poweredOn else { return [] }
        self.startScan()
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
