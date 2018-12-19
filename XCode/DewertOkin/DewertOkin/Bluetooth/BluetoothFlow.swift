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
    private var pairingWorkitem: DispatchWorkItem?
    private var pairing = false
    var paired = false
    
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
        self.waitForBluetooth = { }
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
    
    func reconnect(completion: @escaping () -> Void) {
        guard !self.pairing else {
            print("You are already pairing")
            return
        }
        self.paired = false
        checkBluetoothState {
            self.waitForPeripheral {
                self.pair { result in
                    self.paired = true
                }
            }
        }
    }
    
    private func checkBluetoothState(completion: @escaping () -> Void) {
        while (self.bluetoothService?.bluetoothState != .poweredOn){
            print("Bluetooth is not on")
        }
        self.waitForBluetooth = completion
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
