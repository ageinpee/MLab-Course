//
//  BluetoothCoordinator.swift
//  BluetoothTest
//
//  Created by Nima Rahrakhshan on 05.12.18.
//  Copyright © 2018 Nima Rahrakhshan. All rights reserved.
//

import Foundation
import CoreBluetooth

// Our Coordinator interface
class BluetoothCoordinator {
    
    weak var bluetoothService = Bluetooth.sharedBluetooth
    
    init(bluetoothService: Bluetooth) { self.bluetoothService = bluetoothService }
    
    func retrievePeripherals() -> [CBPeripheral] { return [] }
    
    func connect(peripheral: CBPeripheral, completion: @escaping (Bool) -> Void) { }
    
    func connect() { }
    
    func disconnected(failure: Bool) { }
    
    func ableToWrite() { }
    
}
