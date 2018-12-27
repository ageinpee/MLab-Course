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
    
    let defaults = UserDefaults.standard
    
    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    var availablePeripherals = [CBPeripheral]()
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
        availablePeripherals = []
    }
    
    func startScan() {
        print("Starting to scan")
        guard self.centralManager.state == .poweredOn else { return }
        self.connectedPeripheral = nil
        availablePeripherals = []
        self.centralManager.scanForPeripherals(withServices: [Bluetooth.commandService])
    }
    
    func stopScan() {
        print("Stopping scan")
        self.centralManager.stopScan()
        availablePeripherals = []
    }
    
    func retrievePeripherals() -> [CBPeripheral] {
        print("Returning all advertising peripherals")
        guard self.centralManager.state == .poweredOn else { return [] }
        availablePeripherals = []
        self.centralManager.scanForPeripherals(withServices: [Bluetooth.commandService])
        let peripherals = availablePeripherals
        return peripherals
    }
    
    func connect() {
        print("Connecting to peripheral")
        guard self.centralManager.state == .poweredOn else { return }
        availablePeripherals = []
        guard let peripheral = self.connectedPeripheral else { return }
        self.centralManager.connect(peripheral)
    }
    
    func reconnect(peripheral: CBPeripheral) {
        print("Trying to reconnect")
        guard self.centralManager.state == .poweredOn else { return }
        availablePeripherals = []
        self.connectedPeripheral = nil
        self.centralManager.scanForPeripherals(withServices: [Bluetooth.commandService])
        if (availablePeripherals.contains(peripheral)) {
            self.centralManager.connect(peripheral)
        } else {
            print("Device not in range!")
            // Handle this error visually
        }
    }
    
    func disconnect() {
        print("Disconnecting from peripheral")
        guard let peripheral = self.connectedPeripheral else { return }
        availablePeripherals = []
        self.centralManager.cancelPeripheralConnection(peripheral)
    }
}
