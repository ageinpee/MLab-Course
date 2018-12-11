//
//  BluetoothFlow.swift
//  BluetoothTest
//
//  Created by Nima Rahrakhshan on 05.12.18.
//  Copyright © 2018 Nima Rahrakhshan. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothFlow: BluetoothCoordinator {
    
    let timeout = 15.0
    var waitForPeripheralHandler: () -> Void = { }
    var pairingHandler: (Bool) -> Void = { _ in }
    var pairingWorkitem: DispatchWorkItem?
    var pairing = false
    var paired = false
    
    func waitForPeripheral(completion: @escaping () -> Void) {
        guard !self.pairing else {
            print("Already paired")
            self.waitForPeripheralHandler = completion
            return
        }
        self.pairing = false
        self.pairingHandler = { _ in }
        
        self.bluetoothService?.startScan()
        self.waitForPeripheralHandler = completion
    }
    
    override func retrievePeripherals() -> [CBPeripheral] {
        guard self.bluetoothService?.centralManager.state == .poweredOn else {
            print("Bluetooth is off")
            return []
        }
        let peripherals = self.bluetoothService?.retrievePeripherals()
        return peripherals!
    }
    
    func pair(completion: @escaping (Bool) -> Void) {
        guard !self.pairing else {
            print("Don't pair, already paired")
            return
        }
        guard self.bluetoothService?.centralManager.state == .poweredOn else {
            print("Bluetooth is off")
            self.pairingFailed()
            return
        }
        guard let peripheral = self.bluetoothService?.connectedPeripheral else {
            print("Peripheral not found")
            self.pairingFailed()
            return
        }
        self.pairing = true
        self.pairingWorkitem = DispatchWorkItem {
            print("Pairing timed out")
            self.pairingFailed()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + self.timeout, execute: self.pairingWorkitem!)
        
        print("Pairing...")
        self.pairingHandler = completion
        self.bluetoothService?.centralManager.connect(peripheral)
        completion(true)
    }
    
    func cancel() {
        self.bluetoothService?.stopScan()
        self.bluetoothService?.disconnect()
        self.pairingWorkitem?.cancel()
        
        self.pairing = false
        self.pairingHandler = { _ in }
        self.waitForPeripheralHandler = { }
    }
    
    override func discoveredPeripheral() {
        self.bluetoothService?.stopScan()
        self.waitForPeripheralHandler()
    }
    
    override func ableToWrite() {
        guard self.pairing else { return }
        self.bluetoothService?.getCharacteristics()
        self.pairingWorkitem?.cancel()
    }
    
    override func reconnect() {
        guard !self.pairing else {
            print("You are already pairing")
            return
        }
    }
    
    override func disconnected(failure: Bool) {
        self.pairingFailed()
    }
    
    private func pairingFailed() {
        self.pairingHandler(false)
        self.cancel()
    }
    
}
