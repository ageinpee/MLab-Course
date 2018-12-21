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
    var peripheralsList: [UUID]?
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
        //self.bluetoothCoordinator?.scanStarted()
    }
    
    func stopScan() {
        print("Stopping scan")
        self.centralManager.stopScan()
        //self.bluetoothCoordinator?.scanStopped()
    }
    
    func retrievePeripherals() -> [CBPeripheral] {
        print("Returning all advertising peripherals")
        guard self.centralManager.state == .poweredOn else { return [] }
        self.centralManager.scanForPeripherals(withServices: [Bluetooth.commandService])
        let peripherals = availablePeripherals
        return peripherals
    }
    
    func connect() {
        print("Connecting to peripheral")
        guard self.centralManager.state == .poweredOn else { return }
        guard let peripheral = self.connectedPeripheral else { return }
        self.centralManager.connect(peripheral)
    }
    
    func reconnect() {
        print("Trying to reconnect")
        guard self.centralManager.state == .poweredOn else { return }
        self.connectedPeripheral = nil
        let peripherals = self.centralManager.retrievePeripherals(withIdentifiers: [])
        self.centralManager.connect(peripherals[0])
    }
    
    func disconnect() {
        print("Disconnecting from peripheral")
        guard let peripheral = self.connectedPeripheral else { return }
        self.centralManager.cancelPeripheralConnection(peripheral)
    }
}
