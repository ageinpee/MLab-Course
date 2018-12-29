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
    
    private let timeout = 15.0
    private var waitForPeripheralHandler: () -> Void = { }
    private var waitForBluetooth: () -> Void = { }
    private var pairingHandler: (Bool) -> Void = { _ in }
    private var pairingWorkItem: DispatchWorkItem?
    private var connectedWorkItem: DispatchWorkItem?
    
    func waitForPeripheral(completion: @escaping () -> Void) {
        guard !self.pairing else {
            print("Already paired")
            self.waitForPeripheralHandler = completion
            return
        }
        self.pairing = false
        self.paired = false
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
        guard !self.pairing else { return }
        guard self.bluetoothService?.centralManager.state == .poweredOn else {
            self.pairingFailed()
            return
        }
        guard let peripheral = self.bluetoothService?.connectedPeripheral else {
            self.pairingFailed()
            return
        }
        self.pairing = true
        self.pairingWorkItem = DispatchWorkItem { self.pairingFailed() }
        DispatchQueue.main.asyncAfter(deadline: .now() + self.timeout, execute: self.pairingWorkItem!)

        self.pairingHandler = completion
        self.bluetoothService?.centralManager.connect(peripheral)
        self.paired = true
    }
    
    func cancel() {
        self.bluetoothService?.stopScan()
        self.bluetoothService?.disconnect()
        self.pairingWorkItem?.cancel()
        
        self.pairing = false
        self.pairingHandler = { _ in }
        self.waitForPeripheralHandler = { }
        self.waitForBluetooth = { }
    }
    
    override func ableToWrite() {
        guard self.pairing else { return }
        self.bluetoothService?.getCharacteristics()
        self.pairingWorkItem?.cancel()
    }
    
    override func connect(peripheral: CBPeripheral, completion: @escaping (Bool) -> Void) {
        guard !self.pairing else { return }
        guard self.bluetoothService?.centralManager.state == .poweredOn else {
            self.pairingFailed()
            return
        }
        self.pairing = true
        self.pairingWorkItem = DispatchWorkItem { self.pairingFailed() }
        DispatchQueue.main.asyncAfter(deadline: .now() + self.timeout, execute: self.pairingWorkItem!)
        
        self.pairingHandler = completion
        self.bluetoothService?.centralManager.connect(peripheral)
        connectedWorkItem = DispatchWorkItem {
            if self.bluetoothService?.connectedPeripheral != nil {
                self.pairing = false
                self.paired = true
                self.pairingWorkItem?.cancel()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + (self.timeout / 2), execute: self.connectedWorkItem!)
    }
    
    override func disconnected(failure: Bool) {
        self.pairingFailed()
        self.waitForBluetooth = { }
    }
    
    private func pairingFailed() {
        self.pairingHandler(false)
        self.cancel()
    }
    
}
